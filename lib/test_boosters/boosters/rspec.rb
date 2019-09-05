module TestBoosters
  module Boosters
    class Rspec < Base

      FILE_PATTERN = "spec/**/*_spec.rb".freeze

      def initialize
        super(FILE_PATTERN, split_configuration_path, command)
      end

      def display_header
        super

        TestBoosters::ProjectInfo.display_ruby_version
        TestBoosters::ProjectInfo.display_bundler_version
        TestBoosters::ProjectInfo.display_rspec_version
      end

      def after_job
        TestBoosters::InsightsUploader.upload("rspec", report_path)
      end

      def command
        @command ||= "bundle exec rspec #{rspec_options}"
      end

      def rspec_options
        @rspec_options ||= begin
          output_formatter = ENV.fetch("TB_RSPEC_FORMATTER", "documentation")
          # rubocop:disable LineLength
          "#{ENV["TB_RSPEC_OPTIONS"]} --format RspecJunitFormatter --require #{formatter_path} --format progress --out #{report_path}"
        end
      end

      def report_path
        @report_path ||= ENV["REPORT_PATH"] || "#{ENV["HOME"]}/rspec_report.xml"
      end

      def split_configuration_path
        ENV["RSPEC_SPLIT_CONFIGURATION_PATH"] || "#{ENV["HOME"]}/rspec_split_configuration.json"
      end

      def formatter_path
        @formatter_path ||= File.join(::TestBoosters::ROOT_PATH, "rspec_formatters/semaphore_rspec3_json_formatter.rb")
      end

    end
  end
end
