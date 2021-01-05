# unity3d plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-unity3d)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-unity3d`, add it to your project by running:

```bash
fastlane add_plugin unity3d
```

## About unity3d

fastlane pulgin for unity3d engine

## Usage

```ruby
unity3d(
  execute_method: "SomeClass.YourBuildMethod"
)
```

**recommend**:

Add the following code to your `build script` to get a better experience

```c#
var result = BuildPipeline.BuildPlayer(scene, path, isAndroid ? BuildTarget.Android : BuildTarget.iOS, option);
var summary = result.summary;
var summaryJson = JsonConvert.SerializeObject(summary);
        
System.IO.File.WriteAllText(@".build_summary.json", summaryJson);
```



## Context Values

if you genreated the `.build_summary.json` , There will be some [Lane Variables](https://docs.fastlane.tools/advanced/lanes/#lane-context)

| SharedValue                                | **Description** |
| ------------------------------------------ | --------------- |
| SharedValues::UNITY3D_OUTPUT_PATH          |                 |
| SharedValues::UNITY3D_BUILD_STARTED_AT     |                 |
| SharedValues::UNITY3D_BUILD_ENDED_AT       |                 |
| SharedValues::UNITY3D_PLATFORM             |                 |
| SharedValues::UNITY3D_OPTIONS              |                 |
| SharedValues::UNITY3D_TOTAL_ERRORS         |                 |
| SharedValues::UNITY3D_TOTAL_TOTAL_WARNINGS |                 |
| SharedValues::UNITY3D_TOTAL_TIME           |                 |
| SharedValues::UNITY3D_TOTAL_SIZE           |                 |



## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
