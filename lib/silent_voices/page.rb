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

    def template
      h = ["<html><body>"]
      unless is_a?(StartPage)
        h << "<div class='prev_link'>#{prev_link}</div>"
        h << "<div class='next_link'>#{next_link}</div>"
      end
      yield h
      unless is_a?(StartPage)
        h << "<div class='prev_link'>#{prev_link}</div>"
        h << "<div class='next_link'>#{next_link}</div>"
      end
      h << "</body></html>"
      h.join('\n')
    end

    def prev_link
      "<a href='#{prev_page.path_from(self)}'> &laquo; #{prev_page.name}</a>" if prev_page
    end

    def next_link
      "<a href='#{next_page.path_from(self)}'> &raquo; #{next_page.name}</a>" if next_page
    end

    def decrement_string string
      (string.to_i - 1).to_s.rjust(3, '0')
    end

    def increment_string string
      string.succ
    end

    def self.write_all
      SilentVoices.pages.each do |page|
        puts "writing: #{page.name} => #{page.path}"
        page.write
      end
    end
  end

  class StartPage < Page
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
        h << "<ul class='links books'>"
        book_pages.each do |book|
          h << "<li><a href='#{book.path_from(self)}'>#{book.name}</a></li>"
        end
        h << "</ul>"
      end
    end

    def path_from(page)
      "../index.html"
    end
  end

  class BookPage < Page
    attr_accessor :book
    def initialize book
      @book = book
    end

    def prev_page
      @prev_page ||= SilentVoices.pages.detect {|page| BookPage === page && decrement_string(number) == page.number }
    end

    def next_page
      @next_page ||= SilentVoices.pages.detect {|page| BookPage === page && increment_string(number) == page.number }
    end

    def chapter_pages
      @chapter_pages ||= SilentVoices.pages.select {|page| ChapterPage === page && book == page.book }.sort_by(&:number)
    end

    def html
      template do |h|
        h << "<ul class='links chapters'>"
        chapter_pages.each do |chapter|
          h << "<li><a href='#{chapter.path_from(self)}'>#{chapter.name}</a></li>"
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
      page == StartPage ? "voices/#{filename}" : filename
    end

    def outfile
      SilentVoices::Directory + '/voices/' + filename
    end
  end

  class ChapterPage < Page
    attr_accessor :book

    def initialize chapter, book
      @chapter = chapter
      @book = book
    end

    def book_page
      @book_page ||= SilentVoices.pages.detect {|page| @book[:number] == page.number }
    end

    def prev_page
      @prev_page ||= SilentVoices.pages.detect {|page| name(decrement_string(number)) == page.name }
    end

    def next_page
      @next_page ||= SilentVoices.pages.detect {|page| name(increment_string(number)) == page.name }
    end

    def html
      template do |h|
        h << "<div class='chapter'>"
        verses.each do |verse|
          h << "<p class='verse'>"
          h << "<span class='number'>#{verse[:number]}</span><span class='text'>#{verse[:text]}</span>"
          h << "</p>"
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
      page == StartPage ? "voices/#{filename}" : filename
    end

    def outfile
      SilentVoices::Directory + '/voices/' + filename
    end
  end
end