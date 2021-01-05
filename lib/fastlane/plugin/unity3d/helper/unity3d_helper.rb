require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class Unity3dHelper
      # class methods that you define here become available in your action
      # as `Helper::Unity3dHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the unity3d plugin helper!")
      end
    end
  end
end
