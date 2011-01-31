module SilentVoices

  Directory      = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  ViewsDirectory = File.expand_path(File.join(File.dirname(__FILE__), '..', 'views'))

  def self.pages
    @pages ||= []
  end

  def self.start_page
    @start_page
  end
  def self.start_page= page
    @start_page = page
  end

  def self.index_page
    @index_page
  end
  def self.index_page= page
    @index_page = page
  end

  class Page
    attr_accessor :path, :name, :links, :verses

    def initialize *args
      SilentVoices.pages << self
    end

    def write
      File.open(outfile, 'w') {|f| f.write render }
    end

    def decrement_string string
      length = string.length
      (string.to_i - 1).to_s.rjust(length, '0')
    end

    def increment_string string
      string.succ
    end

    def render
      template =  Haml::Engine.new(File.read(ViewsDirectory + '/template.haml'), :filename => 'template')
      template.render(self) {
        view = Haml::Engine.new(File.read(ViewsDirectory + '/' + view_file), :filename => view_file)
        view.render(self)
      }
    end

    def stylesheet_path
      '../style.css'
    end

    def facebook_like
      %Q{<div id="fb-root"></div>
<script>
window.fbAsyncInit = function() {
FB.init({appId: '186246214732289', status: true, cookie: true,
xfbml: true});
};
</script><fb:like href="http://silentvoicesbible.com/#{path_from(SilentVoices.start_page)}" show_faces="false" width="120" action="like" font="lucida grande" layout="button_count"></fb:like>}
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

    def path_from(page)
      page.is_a?(StartPage) ? 'index.html' :  "../ddindex.html"
    end

    def stylesheet_path
      'style.css'
    end

    def title
      "Silent Voices | The Feminist Bible For a Billion Women"
    end

    def view_file
      'start_page.haml'
    end

    def outfile
      SilentVoices::Directory + '/index.html'
    end

    def write
      puts ''
      print "writing: #{name} => index.html"
      super
    end
  end

  class IndexPage < Page

    def initialize
      super
      SilentVoices.index_page = self
    end

    def name
      'Silent Voices Bible'
    end
    def title
      "Silent Voices | Feminist Translations of Books of the Bible"
    end

    def prev_page; nil; end
    def next_page; nil; end

    def outfile
      SilentVoices::Directory + '/voices/index.html'
    end

    def book_pages
      @book_pages ||= SilentVoices.pages.select {|page| BookPage === page }.sort_by(&:number)
    end

    def books_grouped
      [
        ['Old Testament',
          [
            ['The Torah', book_pages[0, 5]],
            ['Communal History', book_pages[5, 13]],
            ['Poetry',          book_pages[18, 4]],
            ['Major Prophets',  book_pages[22, 5]],
            ['Minor Prophets',  book_pages[27, 12]]
          ]
        ],
        ['New Testament',
          [
            ['The Gospels', book_pages[39, 5]],
            ['The Letters', book_pages[44, 21]],
            ['Apokálypsis', book_pages[65, 1]]
          ]
        ]
      ]
    end

    def path_from(page)
      page.is_a?(StartPage) ? 'voices/index.html' : 'index.html'
    end

    def outfile
      SilentVoices::Directory + '/voices/index.html'
    end

    def view_file
      'index.haml'
    end

    def stylesheet_path
      '../style.css'
    end

    def write
      puts ''
      print "writing: #{name} => voices/index.html"
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

    def name
      book[:name]
    end

    def number
      book[:number]
    end

    def title
      "The Feminist Bible | #{name}"
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

    def view_file
      'book.haml'
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
      @book_page ||= SilentVoices.pages.detect {|page| book[:name] == page.name }
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

    def name(num = number)
      "#{book[:name]} #{num.to_i}"
    end

    def number
      @chapter[:number]
    end

    def verses
      @chapter[:verses]
    end

    def title
      "The Feminist Bible | #{name}"
    end

    def filename
      "#{book[:number]}-#{book[:name].downcase.gsub(' ', '_')}-#{number}.html"
    end

    def path_from(page)
      page.is_a?(StartPage) ? "voices/#{filename}" : filename
    end

    def outfile
      SilentVoices::Directory + '/voices/' + filename
    end

    def view_file
      'chapter.haml'
    end

    def write
      print '.'
      STDOUT.flush
      super
    end
  end
end