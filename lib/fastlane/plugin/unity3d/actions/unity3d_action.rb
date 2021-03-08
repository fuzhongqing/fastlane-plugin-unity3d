require 'fastlane/action'
require_relative '../helper/unity3d_helper'

module Fastlane
  module Actions

    module SharedValues
      UNITY3D_OUTPUT_PATH = :UNITY3D_OUTPUT_PATH
      UNITY3D_BUILD_STARTED_AT = :UNITY3D_BUILD_STARTED_AT
      UNITY3D_BUILD_ENDED_AT = :UNITY3D_BUILD_ENDED_AT
      UNITY3D_PLATFORM = :UNITY3D_PLATFORM
      UNITY3D_OPTIONS = :UNITY3D_OPTIONS 
      UNITY3D_TOTAL_ERRORS = :UNITY3D_TOTAL_ERRORS
      UNITY3D_TOTAL_TOTAL_WARNINGS = :UNITY3D_TOTAL_TOTAL_WARNINGS
      UNITY3D_TOTAL_TIME =:UNITY3D_TOTAL_TIME
      UNITY3D_TOTAL_SIZE =:UNITY3D_TOTAL_SIZE
    end

    class Unity3dAction < Action
      def self.run(params)

        UI.error "no executable found" unless params[:executable]

        build_cmd = "#{params[:executable]}"
        build_cmd << " -projectPath '#{params[:project_path]}'"
        build_cmd << " -batchmode"
        build_cmd << " -quit"
        build_cmd << " -logfile #{params[:logfile]}"
        build_cmd << " -nographics" if params[:nographics]
        build_cmd << " -executeMethod #{params[:execute_method]}" if params[:execute_method]
        build_cmd << " -buildTarget #{params[:build_target]}" if params[:build_target]

        UI.message "\n#{
          Terminal::Table.new(
            title: "Unity".green,
            headings: ["Option", "Value"],
            rows: params.values
        )}\n"


        UI.message "Start running"

        sh build_cmd unless params[:skip_building]

        if File.exist?('.build_summary.json') then
          summary = Helper::BuildSummary.new(JSON.parse(File.read('.build_summary.json')))

          UI.message "\n#{
            Terminal::Table.new(
              title: "build summary".green,
              headings: ["Key", "Value"],
              rows: summary.kv
          )}\n"

          UI.error "build faild, check logfile" unless summary.success?

          Actions.lane_context[SharedValues::UNITY3D_BUILD_STARTED_AT] = summary.kv['buildStartedAt']
          Actions.lane_context[SharedValues::UNITY3D_PLATFORM] = summary.kv['platform']
          Actions.lane_context[SharedValues::UNITY3D_OPTIONS] = summary.kv['options']
          Actions.lane_context[SharedValues::UNITY3D_OUTPUT_PATH] = summary.kv['outputPath']
          Actions.lane_context[SharedValues::UNITY3D_TOTAL_SIZE] = summary.kv['totalSize']
          Actions.lane_context[SharedValues::UNITY3D_TOTAL_TIME] = summary.kv['totalTime']
          Actions.lane_context[SharedValues::UNITY3D_BUILD_ENDED_AT] = summary.kv['buildEndedAt']
          Actions.lane_context[SharedValues::UNITY3D_TOTAL_ERRORS] = summary.kv['totalErrors']
          Actions.lane_context[SharedValues::UNITY3D_TOTAL_TOTAL_WARNINGS] = summary.kv['totalWarnings']

          if summary.is_android? then
            build_script_file = Dir[File.join(summary.build_path, '*', 'build.gradle')].find { |path| File.exist?(path) }
            if build_script_file then
              # if export mode
              sh "gradle -p \'#{File.dirname(build_script_file)}\' wrapper"
              ENV["FL_GRADLE_PROJECT_DIR"] = File.dirname(build_script_file)
            end
          end

        else
          UI.message "file `build_summary.json` not found"
        end

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "fastlane plugin for unity3d engine"
      end

      def self.authors
        ["fuzhongqing"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "fastlane for unity3d engine"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :executable,
                                       env_name: "FL_UNITY_EXECUTABLE",
                                       description: "Path for Unity executable",
                                       optional: true,
                                       default_value: Helper::Unity3dHelper.default_exe_path),

          FastlaneCore::ConfigItem.new(key: :project_path,
                                       env_name: "FL_UNITY_PROJECT_PATH",
                                       description: "Path for Unity project",
                                       optional: true,
                                       default_value: "#{Dir.pwd}"),

          FastlaneCore::ConfigItem.new(key: :execute_method,
                                       env_name: "FL_UNITY_EXECUTE_METHOD",
                                       description: "Method to execute",
                                       optional: true,
                                       default_value: nil),

          FastlaneCore::ConfigItem.new(key: :build_type,
                                       env_name: "FL_UNITY_BUILD_TYPE",
                                       description: "`Debug` or `Release`",
                                       optional: true,
                                       default_value: "Release"),

          FastlaneCore::ConfigItem.new(key: :nographics,
                                       env_name: "FL_UNITY_NOGRAPHICS",
                                       description: "Initialize graphics device or not",
                                       optional: true,
                                       is_string: false,
                                       default_value: true),

          FastlaneCore::ConfigItem.new(key: :logfile,
                                       env_name: "FL_UNITY_LOGFILE",
                                       description: "log file",
                                       optional: true,
                                       is_string: true,
                                       default_value: ""),

          FastlaneCore::ConfigItem.new(key: :skip_building,
                                       env_name: "FL_UNITY_SKIP_BUILDING",
                                       description: "Need skip building",
                                       optional: true,
                                       is_string: false,
                                       default_value: false),

          FastlaneCore::ConfigItem.new(key: :target,
                                       env_name: "FL_UNITY_BUILD_TARGET",
                                       description: "build target",
                                       optional: true,
                                       is_string: true,
                                       default_value: "Standalone"),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end

      def self.category
        :building
      end

    end
  end
end
