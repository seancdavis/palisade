module Palisade
  class Log

    def initialize
    end

    def add(content)
      File.open(log_file, 'a') { |f| f.write("#{content}\n") }
    end

    def add_heading(content, level = 1)
      case level
      when 1
        self.add "#{'*' * 39}\n#{'*' * 39}\n#{content}\n#{'*' * 39}\n#{'*' * 39}\n"
      when 2
        self.add "#{'=' * 20}\n#{content}\n#{'=' * 20}\n"
      when 3
        self.add "#{'-' * 20}\n#{content}\n#{'-' * 20}\n"
      when 4
        self.add ">>> #{content}"
      end
    end

    private

      def log_file
        @log_file ||= "#{`echo $HOME`.strip}/.palisade/palisade.log"
      end

  end
end
