module SilentVoices
  def self.pages
    @pages ||= []
  end

  class Page
    attr_accessor :path, :name, :links, :verses

    def initialize path, name, chapter = nil
      @path     = path
      @name     = name
      @chapter  = chapter
      @links    = []
      @verses   = []
      SilentVoices.pages << self
    end

    def add_link text, href
      href = '/' == href ? '/index.html' : "/voices#{href}.html"
      @links << "<a href='#{href}'>#{text}</a>"
    end

    def add_verse verse
      @verses << verse
    end

    def write
      File.open(outfile, 'w') {|f| f.write html }
    end

    def outfile
      SilentVoices::Directory + (path == '/' ? '/index.html' : "/voices/#{path}.html")
    end

    def html
      h = "<html><body>"
      h << "#{prev_link} &middot #{next_link}" unless '/' == path
      links.each do |link|
        h << link
        h << "<br />"
      end
      verses.each do |verse|
        h << "<div class='verse'>#{verse[:number]}: #{verse[:text]}</div>"
      end
      h << "</body></html>"
      h
    end

    def prev_link

      if path =~ /\d\d\d-\d\d\d/ # previous chapter
        book_number, chapter_number = path.split('-')
        prev_chapter = (chapter_number.to_i - 1).to_s.rjust(3, '0')
        prev_page = SilentVoices.pages.detect {|page| page.path == "#{book_number}-#{prev_chapter}" }

      elsif path =~ /\d\d\d/ # previous book
        prev_book = (path.to_i - 1).to_s.rjust(3, '0')
        prev_page = SilentVoices.pages.detect {|page| page.path == "#{prev_book}" }
      end

      "<a href='/voices/#{prev_page.path}'> &laquo; #{prev_page.name}</a>" if prev_page
    end

    def next_link

      if path =~ /\d\d\d-\d\d\d/ # next chapter
        book_number, chapter_number = path.split('-')
        next_chapter = (chapter_number.to_i + 1).to_s.rjust(3, '0')
        next_page = SilentVoices.pages.detect {|page| page.path == "#{book_number}-#{next_chapter}" }

      elsif path =~ /\d\d\d/ # next book
        next_book = (path.to_i + 1).to_s.rjust(3, '0')
        next_page = SilentVoices.pages.detect {|page| page.path == "#{next_book}" }
      end

      "<a href='/voices/#{next_page.path}'> &laquo; #{next_page.name}</a>" if next_page
    end

    def self.write_all
      SilentVoices.pages.each do |page|
        puts "writing: #{page.name} => #{page.path}"
        page.write
      end
    end
  end
end