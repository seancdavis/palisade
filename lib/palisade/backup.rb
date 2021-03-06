require 'yaml'
require 'fileutils'
require 'palisade/log'

module Palisade
  class Backup

    def initialize
      @log = Palisade::Log.new
    end

    def self.backup
      Palisade::Backup.new.backup
    end

    def backup
      do_the_backup
    end

    private

      def do_the_backup
        @log.add_heading("Begin Backup: #{Time.now}", 1)
        projects.each do |name, config|
          @log.add_heading("Project: #{name}", 2)
          verify_project_dir(name)
          if config['db']
            @log.add_heading("Backing up database to: #{db_dir(name)}", 3)
            verify_db_dir(name)
            rsync(config['db'], db_dir(name))
          end
          config['assets'].each do |asset_name, data|
            method = data['method']
            method = 'rsync' if method.nil? || method == ''
            case method
            when 'rsync'
              @log.add_heading(
                "Backing up assets: #{asset_name}\nTo: #{project_dir(name)}", 3
              )
              rsync(data['route'], project_dir(name))
            when 's3cmd'
              @log.add_heading(
                "Backing up assets: #{asset_name}\nTo: #{s3_dir(name, asset_name)}\n", 
                3
              )
              verify_s3_dir(name, asset_name)
              s3cmd(data['route'], s3_dir(name, asset_name), data['config'])
            end
          end
        end
      end

      def rsync(src, dest)
        @log.add(`rsync #{rsync_options} #{src} #{dest}`)
      end

      def s3cmd(src, dest, config = nil)
        config = "-c #{config}" unless config.nil?
        @log.add(`s3cmd get -vr --skip-existing #{config} s3://#{src}/ #{dest} -`)
      end

      # ------------------------------------------ Directory Management

      def project_dir(name)
        "#{dest_root}/#{name}"
      end

      def db_dir(name)
        "#{project_dir(name)}/db"
      end

      def s3_dir(name, asset_name)
        "#{project_dir(name)}/#{asset_name}"
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

      def verify_s3_dir(name, asset_name)
        unless Dir.exists?(s3_dir(name, asset_name))
          FileUtils.mkdir_p(s3_dir(name, asset_name))
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