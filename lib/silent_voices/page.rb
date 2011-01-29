module SilentVoices

  Directory = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

  def self.pages
    @pages ||= []
  end

  def self.start_page
    @start_page
  end
  def self.start_page= page
    @start_page = page
  end

  class Page
    attr_accessor :path, :name, :links, :verses

    def initialize *args
      SilentVoices.pages << self
    end

    def write
      File.open(outfile, 'w') {|f| f.write html }
    end

    def template
      stylesheet_path = is_a?(StartPage) ? 'style.css' : '../style.css'
      h = []
      nav = "<div class='nav'>" +
            "<div class='prev_link'>#{prev_link}</div>" +
            "<div class='home_link'><a href='#{SilentVoices.start_page.path_from(self)}'>Silent Voices</a></div>" +
            "<div class='next_link'>#{next_link}</div>" +
            "</div>"

      h << "<html><head>"
      h << "<link href='#{stylesheet_path}' media='screen' rel='stylesheet' type='text/css' />"
      h << "<link href='http://fonts.googleapis.com/css?family=Bentham' rel='stylesheet' type='text/css'>"
      h << "<link href='http://fonts.googleapis.com/css?family=Neuton' rel='stylesheet' type='text/css'>"
      h << "</head><body>"
      h << "<div class='container'>"
      h << nav unless is_a?(StartPage)
      yield h
      h << nav unless is_a?(StartPage)
      h << "</div>"
      h << "<div class='footer'>Created by <a href='http://jackcanty.com'>Jack</a>, send corrections and feedback to <em>silentvoices at jackcanty dot com</em></div>"
      h << "</body></html>"
      h.join("\n")
    end

    def prev_link
      "<a href='#{prev_page.path_from(self)}'>&laquo; #{prev_page.name}</a>" if prev_page
    end

    def next_link
      "<a href='#{next_page.path_from(self)}'>#{next_page.name} &raquo;</a>" if next_page
    end

    def decrement_string string
      length = string.length
      (string.to_i - 1).to_s.rjust(length, '0')
    end

    def increment_string string
      string.succ
    end

    def self.write_all
      Dir.mkdir Directory + '/voices' rescue ''
      SilentVoices.pages.each do |page|
        page.write
      end
      puts ''
      puts "Wrote #{SilentVoices.pages.size} pages"
    end
  end

  class StartPage < Page

    def initialize
      super
      SilentVoices.start_page = self
    end

    def name
      'Silent Voices'
    end
    def prev_page; nil; end
    def next_page; nil; end

    def outfile
      SilentVoices::Directory + '/index.html'
    end

    def book_pages
      @book_pages ||= SilentVoices.pages.select {|page| BookPage === page }.sort_by(&:number)
    end

    def html
      template do |h|
        h << '<h1>Silent Voices</h1>'
        h << "<h3 class='quote'>\"If God is male then male is God.\" -- Mary Daly</h3>"
        h << "<div class='entries books'>"
        book_pages.each do |book|
          h << "<div class='entry book'>"
          h << "<div class='anchor'>#{book.number}</div>"
          h << "<div class='content'><a href='#{book.path_from(self)}'>#{book.name}</a></div>"
          h << "</div>"
        end
        h << "</div>"
      end
    end

    def path_from(page)
      "../index.html"
    end

    def filename
      'index.html'
    end

    def outfile
      SilentVoices::Directory + '/' + filename
    end

    def write
      puts ''
      print "writing: #{name} => #{filename}"
      super
    end
  end

  class BookPage < Page
    attr_accessor :book
    def initialize book
      @book = book
      super
    end

    def prev_page
      @prev_page ||= SilentVoices.pages.detect {|page| page.is_a?(BookPage) && decrement_string(number).eql?(page.number) }
    end

    def next_page
      @next_page ||= SilentVoices.pages.detect {|page| page.is_a?(BookPage) && increment_string(number).eql?(page.number) }
    end

    def chapter_pages
      @chapter_pages ||= SilentVoices.pages.select {|page| ChapterPage === page && book == page.book }.sort_by(&:number)
    end

    def html
      template do |h|
        h << "<h2 class='book'>#{name}</h2>"
        h << "<div class='entries chapters'>"
        chapter_pages.each do |chapter|
          h << "<div class='entry chapter'>"
          h << "<div class='anchor'>Chapter #{chapter.number.to_i}</div>"
          h << "<div class='content chapter_preview'><a href='#{chapter.path_from(self)}'>#{chapter.verses.first[:text].to_s[0, 45]}[...]</a></div>"
          h << "</div>"
        end
        h << "</ul>"
      end
    end

    def name
      @book[:name]
    end

    def number
      @book[:number]
    end

    def filename
      "#{number}-#{name.downcase.gsub(' ', '_')}.html"
    end

    def path_from(page)
      page.is_a?(StartPage) ? "voices/#{filename}" : filename
    end

    def outfile
      SilentVoices::Directory + '/voices/' + filename
    end

    def write
      puts ''
      print "writing: #{name} => "
      super
    end
  end

  class ChapterPage < Page
    attr_accessor :book

    def initialize chapter, book
      @chapter = chapter
      @book = book
      super
    end

    def book_page
      @book_page ||= SilentVoices.pages.detect {|page| @book[:number] == page.number }
    end

    def prev_page
      @prev_page ||=
        SilentVoices.pages.detect {|page| name(decrement_string(number)) == page.name } ||
        SilentVoices.pages.detect {|page| page.is_a?(BookPage) && decrement_string(book[:number]).eql?(page.number) }
    end

    def next_page
      @next_page ||=
        SilentVoices.pages.detect {|page| name(increment_string(number)) == page.name } ||
        SilentVoices.pages.detect {|page| page.is_a?(BookPage) && increment_string(book[:number]).eql?(page.number) }
    end

    def html
      template do |h|
        h << "<h2 class='chapter'>#{name}</h2>"
        h << "<div class='entries chapter'>"
        verses.each do |verse|
          h << "<div class='entry verse'>"
          h << "<div class='anchor number'><a name='#{verse[:number]}' href='##{verse[:number]}'>#{verse[:number]}</a></div>"
          h << "<div class='content text'>#{verse[:text]}</div>"
          h << "</div>"
        end
        h << "</div>"
      end
    end

    def name(num = number)
      "#{@book[:name]} #{num}"
    end

    def number
      @chapter[:number]
    end

    def verses
      @chapter[:verses]
    end

    def filename
      "#{@book[:number]}-#{@book[:name].downcase.gsub(' ', '_')}-#{number}.html"
    end

    def path_from(page)
      page.is_a?(StartPage) ? "voices/#{filename}" : filename
    end

    def outfile
      SilentVoices::Directory + '/voices/' + filename
    end

    def write
      print '.'
      STDOUT.flush
      super
    end
  end
end