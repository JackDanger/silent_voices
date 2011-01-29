module SilentVoices
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
        # output some framing html
      end

      def each_book
        ret = []
        rxp = /^Book (\d\d) (.*)/
        begin
          index        = @source.index(rxp)
          line         = @source[rxp]
          number, name = @source.scan(rxp).first.flatten
          offset       = index + line.size
          next_index   = @source[offset, @source.size].index(rxp)
          endpoint     = next_index ? next_index : @source.size
          text         = @source[offset, endpoint - offset]
          chapters     = yield text
          # trim the remaining source
          @source = @source[endpoint, @source.length]
          ret << { :name => name,
                   :number => number.to_i,
                   :chapters => chapters }
        end while next_index
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
          ret << {:number => marker.to_i,
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
          ret << {:number => marker.to_i,
                  :text   => text}
          marker.succ!
        end while next_index
        ret
      end

      def normalize string
        string.gsub(/[\s\n]+/, ' ').sub(/^[\s\n]|[\s\n]$/, '')
      end

      def strip_comments string
        string.gsub /(.*)(\{.*\})(.*)/, '\1\3'
      end

      def feminize string
        Feminizer.feminize_text string
      end

      def set_feminizing_forms
        Feminizer.forms = SilentVoices::Gender.forms
      end
  end
end