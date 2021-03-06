require 'fileutils'
require 'palisade/message'

module Palisade
  class Install

    def initialize
    end

    def self.add_config
      Palisade::Install.new.add_config
    end

    def add_config
      mk_config_dir
      copy_config_file
      print_install_message
    end

    private

      def home_dir
        `echo $HOME`.strip
      end

      def config_dir
        "#{home_dir}/.palisade"
      end

      def config_file
        "#{config_dir}/config.yml"
      end

      def config_template
        File.expand_path('../../templates/config.yml', __FILE__)
      end

      def mk_config_dir
        unless Dir.exists?(config_dir)
          FileUtils.mkdir(config_dir)
        end
      end

      def copy_config_file
        unless File.exists?(config_file)
          system("cp #{config_template} #{config_file}")
        end
      end

      def print_install_message
        Palisade::Message.print(
          :install, 
          {
            :config_file => config_file 
          }
        )
      end

  end
end
