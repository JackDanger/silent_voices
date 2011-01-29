module SilentVoices
  Directory = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '_site'))

  class Compiler

    def initialize source
      @source = source
      set_feminizing_forms
    end

    def process
      @compiled = compile
      write_layout
    end

    protected

      def compile
        each_book do |book_text|
          puts book_text.class.name
          each_chapter book_text do |chapter_text|
            each_verse chapter_text do |verse|
              verse = normalize       verse
              verse = strip_comments  verse
              verse = feminize        verse
              verse
            end
          end
        end
      end

      def write_layout
        start = Page.new('/', 'Silent Voices')
        @compiled.each do |book|
          book_name = "#{book[:number]} #{book[:name]}"
          path = "/#{book[:number]}"
          start.add_link(book_name, path)
          book_page = Page.new(path, book_name)
          book[:chapters].each do |chapter|
            path = "/#{book[:number]}-#{chapter[:number]}"
            chapter_page = Page.new(path, "#{book_name}", chapter[:number].to_i)
            chapter[:verses].each do |verse|
              chapter_page.add_verse verse
            end
          end
        end
        Page.write_all
      end

      def each_book
        ret = []
        @source.split(/^Book*/).each do |book|
          next unless book =~ /^ (\d\d) (.*)/
          header       = book[/^ (\d\d) (.*)/]
          number, name = book.scan(/^ (\d\d) (.*)/).first.flatten
          book         = book[header.size, book.size] # trim the header
          chapters     = yield book
          puts "#{number} - #{name}"
          puts "# chapters: #{chapters.size}"
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
          index = string.index /^#{marker}:/
          next_index = string.index /^#{marker.succ}:/
          endpoint = next_index ? next_index : string.size
          verses = yield string[index, endpoint-index]
          ret << {:number => marker,
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
          ret << {:number => marker,
                  :text   => text}
          marker.succ!
        end while next_index
        ret
      end

      def normalize string
        return string
        string.gsub(/[\s\n]+/, ' ').sub(/^[\s\n]|[\s\n]$/, '')
      end

      def strip_comments string
        return string
        string.gsub /(.*)(\{.*\})(.*)/, '\1\3'
      end

      def feminize string
        return string
        Feminizer.feminize_text string
      end

      def set_feminizing_forms
        Feminizer.forms = SilentVoices::Gender.forms
      end
  end
end