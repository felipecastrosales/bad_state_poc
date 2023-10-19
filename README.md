# Bad State POC. 

POC to reproduce the bad state error.

Debug Mode:

https://github.com/felipecastrosales/bad_state_poc/assets/59374587/dc2f5316-8d3d-4aa4-8930-2b484ff00f5d

Release Mode:

https://github.com/felipecastrosales/bad_state_poc/assets/59374587/95abeae8-ed1d-4106-b348-2a1b0326a3a5

---

```
════════ Exception caught by image resource service ════════════════════════════
Bad state: Cannot clone a disposed image.
The clone() method of a previously-disposed Image was called. Once an Image object has been disposed, it can no longer be used to create handles, as the underlying data may have been released.
════════════════════════════════════════════════════════════════════════════════

════════ Exception caught by scheduler library ═════════════════════════════════
'package:flutter/src/painting/image_stream.dart': Failed assertion: line 127 pos 12: '(image.debugGetOpenHandleStackTraces()?.length ?? 1) > 0': is not true
════════════════════════════════════════════════════════════════════════════════
```

---

- flutter doctor -v

```
[✓] Flutter (Channel stable, 3.13.7, on macOS 14.1 23B5056e darwin-arm64, locale en-BR)
    • Flutter version 3.13.7 on channel stable at /Users/felipecastrosales/fvm/versions/3.13.7
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 2f708eb839 (9 days ago), 2023-10-09 09:58:08 -0500
    • Engine revision a794cf2681
    • Dart version 3.1.3
    • DevTools version 2.25.0

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.1)
    • Android SDK at /Users/felipecastrosales/Library/Android/sdk
    • Platform android-34, build-tools 33.0.1
    • ANDROID_HOME = /Users/felipecastrosales/Library/Android/sdk
    • ANDROID_SDK_ROOT = /Users/felipecastrosales/Library/Android/sdk
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 17.0.6+0-17.0.6b802.4-9586694)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 14.3.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14E300c
    • CocoaPods version 1.13.0

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2022.2)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 17.0.6+0-17.0.6b802.4-9586694)

[✓] VS Code (version 1.74.3)
    • VS Code at /Users/felipecastrosales/Downloads/app/Visual Studio Code.app/Contents
    • Flutter extension version 3.60.0

[✓] Connected device (4 available)
    • M2003J15SC (mobile) • 192.168.1.16:5555         • android-arm64  • Android 11 (API 30)
    • iPhone (mobile)     • 00008020-000A5C900A60802E • ios            • iOS 17.0.3 21A360
    • macOS (desktop)     • macos                     • darwin-arm64   • macOS 14.1 23B5056e darwin-arm64
    • Chrome (web)        • chrome                    • web-javascript • Google Chrome 118.0.5993.70
    ! Error: iPhone is busy: Making iPhone ready for development. Xcode will continue when iPhone is finished. (code -10)

[✓] Network resources
    • All expected network resources are available.

• No issues found!
```