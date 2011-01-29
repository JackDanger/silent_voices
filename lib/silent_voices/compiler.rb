module SilentVoices
  class Compiler
    def initialize(source)
      @source = source
      set_feminizing_forms
    end

    def process
      books do |book|
        write_book book
      end
      write_layout
    end

    protected

      def write_layout
        # output some framing html
      end

      def write_book book
        chapters book do |chapter|
          verses chapter do |verse|
            verse = compile         verse
            verse = strip_comments  verse
            verse = feminize        verse
            verse = format          verse
            verse
          end
        end
      end

      def books
        @source.scan(/^Book (\d\d) (.*)$/).each do |book|
          yield book
        end
      end

      def source
        @source
      end

      def parse
        source
      end

      def feminize string
        Feminizer.feminize_text string
      end

      def set_feminizing_forms
        Feminizer.forms = SilentVoices::Gender.forms
      end
  end
end