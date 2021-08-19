# marvista

marvista

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Model, api retrofit
```
    flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Icon
```
    flutter pub run flutter_launcher_icons:main
```

### Fastlane

run file BuildApp to compile for android/ios
```

```

###  SkSL warmup
```
As of release 1.20, Flutter provides command line tools for app developers to collect shaders that might be needed for end-users in the SkSL (Skia Shader Language) format. The SkSL shaders can then be packaged into the app, and get warmed up (pre-compiled) when an end-user first opens the app, thereby reducing the compilation jank in later animations. Use the following instructions to collect and package the SkSL shaders:

Run the app with --cache-sksl turned on to capture shaders in SkSL:

content_copy
flutter run --profile --cache-sksl
If the same app has been previously run without --cache-sksl, then the --purge-persistent-cache flag may be needed:

content_copy
flutter run --profile --cache-sksl --purge-persistent-cache
This flag removes older non-SkSL shader caches that could interfere with SkSL shader capturing. It also purges the SkSL shaders so use it only on the first --cache-sksl run.

Play with the app to trigger as many animations as needed; particularly those with compilation jank.

Press M at the command line of flutter run to write the captured SkSL shaders into a file named something like flutter_01.sksl.json. (For best results, capture SkSL shaders on actual Android and iOS devices separately. For iOS, please also read the limitations and considerations section below on Metal versus OpenGL.)

Build the app with SkSL warm-up using the following, as appropriate:

Android:

content_copy
flutter build apk --bundle-sksl-path flutter_01.sksl.json
or

content_copy
flutter build appbundle --bundle-sksl-path flutter_01.sksl.json
iOS:

content_copy
flutter build ios --bundle-sksl-path flutter_01.sksl.json
If it’s built for a driver test like test_driver/app.dart, make sure to also specify --target=test_driver/app.dart (e.g., flutter build ios --bundle-sksl-path flutter_01.sksl.json --target=test_driver/app.dart).

Test the newly built app.

Alternatively, you can write some integration tests to automate the first three steps using a single command. For example:

content_copy
flutter drive --profile --cache-sksl --write-sksl-on-exit flutter_01.sksl.json -t test_driver/app.dart
With such integration tests, you can easily and reliably get the new SkSLs when the app code changes, or when Flutter upgrades. Such tests can also be used to verify the performance change before and after the SkSL warm-up. Even better, you can put those tests into a CI (continuous integration) system so the SkSLs are generated and tested automatically over the lifetime of an app.
```