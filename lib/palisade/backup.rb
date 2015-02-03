require 'yaml'
require 'fileutils'

module Palisade
  class Backup

    def initialize
    end

    def self.backup
      Palisade::Backup.new.backup
    end

    def backup
      do_the_backup
    end

    private

      def do_the_backup
        projects.each do |name, config|
          verify_project_dir(name)
          if config['db']
            verify_db_dir(name)
            rsync(config['db'], db_dir(name))
          end
          config['assets'].each do |asset_name, data|
            method = data['method']
            method = 'rsync' if method.nil? || method == ''
            case method
            when 'rsync'
              rsync(data['route'], project_dir(name))
            when 's3cmd'
              s3cmd(data['route'], project_dir(name))
            end
          end
        end
      end

      def rsync(src, dest)
        system("rsync #{rsync_options} #{src} #{dest}")
      end

      # ------------------------------------------ Directory Management

      def project_dir(name)
        "#{dest_root}/#{name}"
      end

      def db_dir(name)
        "#{project_dir(name)}/db"
      end

      def verify_project_dir(name)
        unless Dir.exists?(project_dir(name))
          FileUtils.mkdir_p(project_dir(name))
        end
      end

      def verify_db_dir(name)
        unless Dir.exists?(db_dir(name))
          FileUtils.mkdir_p(db_dir(name))
        end
      end

      # ------------------------------------------ Configuration / Options

      def config_file
        @config_file ||= "#{`echo $HOME`.strip}/.palisade/config.yml"
      end

      def load_config
        @load_config ||= YAML.load_file(config_file)
      end

      def config
        @config ||= load_config['config']
      end

      def projects
        @projects ||= load_config['projects']
      end

      def dest_root
        @dest_root ||= config['root']
      end

      def rsync_options
        @rsync_options ||= '-chavz --stats'
      end

      def daystamp
        @daystamp ||= Time.now.strftime('%d')
      end

  end
end