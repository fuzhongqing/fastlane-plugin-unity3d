require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class Unity3dHelper
      # class methods that you define here become available in your action
      # as `Helper::Unity3dHelper.your_method`
      #
      # https://github.com/safu9/fastlane-plugin-unity/blob/main/lib/fastlane/plugin/unity/helper/unity_helper.rb
      def self.default_exe_path
        paths = []

        if OS::Underlying.docker?
          # See: https://gitlab.com/gableroux/unity3d
          paths << "/opt/Unity/Editor/Unity"
        end

        if OS.windows?
          paths << "C:\\Program Files\\Unity\\Editor\\Unity.exe"
        elsif OS.mac?
          paths << "/Applications/Unity/Unity.app/Contents/MacOS/Unity"
          paths << Dir[File.join('Applications', '**', 'Unity.app', 'Contents', 'MacOS', 'Unity')]
        elsif OS.linux?
          paths << "~/Unity/Editor/Unity"
        end

        return paths.find { |path| File.exist?(path) }
      end
    end

    class BuildSummary

      @@object = nil

      def initialize(json_obj)
        @object = json_obj
      end

      def build_path
        @object['outputPath']
      end

      def success?
        @object['result'] == 1
      end

      def is_android?
        @object['platform'] == 13
      end

      def is_ios?
        @object['platform'] == 9
      end

      def kv
        @object.merge!(
          {
            "android" => self.is_android?,
            "ios" => self.is_ios?,
          })
      end
    end
  end
end
