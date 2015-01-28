module Palisade
  class Message

    def initialize(name, vars = {})
      @name = name
      @vars = vars
    end

    def self.print(name, vars = {})
      Palisade::Message.new(name.to_s, vars).print
    end

    def print
      puts template_contents
    end

    private

      def template_file
        File.expand_path("../../messages/#{@name}.txt", __FILE__)
      end

      def template_contents
        eval('"' + File.read(template_file) + '"')
      end

  end
end
