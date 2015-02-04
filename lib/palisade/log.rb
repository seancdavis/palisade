module Palisade
  class Log

    def initialize
      @contents = ''
    end

    def add(content)
      @contents += "#{content}\n"
    end

    def add_heading(content, level = 1)
      case level
      when 1
        self.add "#{'=' * 20}\n#{content}\n#{'=' * 20}"
      when 2
        self.add "#{'-' * 20}\n#{content}\n#{'-' * 20}"
      when 3
        self.add ">>> #{content}"
      end
    end

    def write
      File.open(log_file, 'a') { |f| f.write(@contents) }
      @contents = ''
    end

    private

      def log_file
        @log_file ||= "#{`echo $HOME`.strip}/.palisade/palisade.log"
      end

  end
end
