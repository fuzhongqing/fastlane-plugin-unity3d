describe Fastlane::Actions::Unity3dAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The unity3d plugin is working!")

      Fastlane::Actions::Unity3dAction.run(nil)
    end
  end
end
