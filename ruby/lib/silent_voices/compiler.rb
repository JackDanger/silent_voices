module SilentVoices
  class Compiler

    def initialize source, level
      @source = source
      @level = level
      set_feminizing_forms
    end

    def process *media
      @compiled = compile
      write_layout media
    end

    protected

      def run_books?
        %{books fast}.include? @level
      end

      def fast_compile?
        'fast' == @level
      end

      def compile
        return [] unless run_books?
        each_book do |book_text|
          each_chapter book_text do |chapter_text|
            each_verse chapter_text do |verse|
              unless fast_compile?
                verse = normalize       verse
                verse = strip_comments  verse
                verse = feminize        verse
              end
              verse
            end
          end
        end
      end

      def write_layout media
        StartPage.new
        if run_books?
          IndexPage.new
          @compiled.each do |book|
            BookPage.new book
            book[:chapters].each do |chapter|
              ChapterPage.new chapter, book
            end
          end
        end
        Page.write_all media
      end

      def each_book
        ret = []
        @source.split(/^Book*/).each do |book|
          next unless book =~ /^ (\d\d) (.*)/
          header       = book[/^ (\d\d) (.*)/]
          number, name = book.scan(/^ (\d\d) (.*)/).first.flatten
          puts ''
          print "compiling: #{name} "
          book         = book[header.size, book.size] # trim the header
          chapters     = yield book
          ret << { :name => name,
                   :number => number,
                   :chapters => chapters }
        end
        ret
      end

      def each_chapter string
        marker = '001'
        ret = []
        begin
          print '.'
          STDOUT.flush
          index = string.index /^#{marker}:/
          next_index = string.index /^#{marker.succ}:/
          endpoint = next_index ? next_index : string.size
          verses = yield string[index, endpoint-index]
          ret << {:number => marker.dup,
                  :verses => verses}
          marker.succ!
        end while next_index
        ret
      end

      def each_verse string
        marker = '001'
        ret = []
        begin
          index = string.index /^\d\d\d:#{marker}/
          line  = string[/^\d\d\d:#{marker}\s?/]
          next_index = string.index /^\d\d\d:#{marker.succ}/
          endpoint = next_index ? next_index : string.size
          text = yield string[index + line.size, endpoint - index - line.size]
          ret << {:number => marker.dup,
                  :text   => text}
          marker.succ!
        end while next_index
        ret
      end

      def normalize string
        string.gsub(/[\s\n]+/, ' ').sub(/^[\s\n]|[\s\n]$/, '')
      end

      def strip_comments string
        string = string.gsub(/<</, '(').gsub(/>>/, ')')
        string = string.gsub /(.*)?(\{.*\})(.*)?/, '\1\3'
        string = string.gsub /\[(.*)\]/, '\1'
        string
      end

      def feminize string
        Gender.feminize_text string
      end

      def set_feminizing_forms
        Feminizer.forms = SilentVoices::Gender.forms
      end
  end
end
