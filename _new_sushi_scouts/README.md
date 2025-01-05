# sushi_scouts

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Requirements

To develop the app for iOS and Android, we will need to install a few softwares. You will need a lot of time and lot of space to install everything, so try to clean up your computer if you're low on space and install these at home.
- XCode
- Android Studio
- Flutter SDK

There are more specific setup requirements for each individual system. I also recommend using VSCode with the Flutter extension.

### General Setup
- \[Optional\] VSCode -- You don't have to use VSCode, but I recommend it. You can even use the same VSCode installation as the one for WPILib, although I'd recommend making a separate profile for your flutter extensions and configuration.
    - Flutter Extension -- This extension will also get you the Dart extension, which provides Dart language support (the programming language Flutter is built on). The Flutter extension provides many helpful features to streamline your development.
- \[Optional\] Git -- Most IDEs will come with version management capabilites, but it is helpful to be able to use git from the command line as well

### Mac Setup
To setup on mac, you can generally follow the [official installation instructions](https://docs.flutter.dev/get-started/install/macos/mobile-ios/), but I have compiled everything you need and provided ways to install it here.
- \[Optional\] Homebrew -- I recommend using homebrew to manage your packages, as it pretty easy to use for a beginner. It can be installed by running `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` as specified on the website [brew.sh](https://brew.sh/)
- \[Optional\] Git -- `brew install git` to download command line git with homebrew, if you want
- Xcode -- You will need to download Xcode from the app store, and then open a terminal and type `sudo xcodebuild -license`, then follow the on-screen instructions to agree to the license.
    - After installing, configure the command line tools to use Xcode with `sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'`
- Flutter SDK
    - Homebrew -- brew install --cask flutter
    - Nix -- add pkgs.flutter327 to your nix package
    - VSCode -- The flutter extension will prompt you to let it install the Flutter SDK automatically if it can't find it
    - Directly -- Follow the instructions [here](https://docs.flutter.dev/get-started/install/macos/mobile-ios#download-then-install-flutter)
- Rosetta -- Some Flutter components require the Rosetta 2 translation process on Macs running Apple silicon, to install run `sudo softwareupdate --install-rosetta --agree-to-license`
- CocoaPods
    - Homebrew -- brew install cocoapods
    - Nix -- pkgs.cocoapods
    - Directly -- Follow the instructions [here](https://guides.cocoapods.org/using/getting-started.html)
- Android Studio -- You will need to open it and run the initial standard setup of accepting licenses and installing the SDK and such. You will also need to open "More Actions" and select "SDK Manager", go to the "SDK Tools" tab, and ensure Android SDK Build-Tools and Android SDK Command-line Tools are selected, then click "Ok".
    - Homebrew -- brew install android-studio
    - Nix -- pkgs.android-studio (only available on )
    - Directly -- Follow the instructions [here](https://developer.android.com/studio/install#mac). If you use this way, you may need to "locate SDK" still in VSCode.
- iOS Simulator -- run `xcodebuild -downloadPlatform iOS`
- If you want to run MacOS apps as well, and you downloaded items directly, you may need to add certain things to your `PATH`, as specified [here](https://docs.flutter.dev/get-started/install/macos/desktop)

### Windows Setup
To setup on windows, you can follow the [official installation instructions](https://docs.flutter.dev/get-started/install/windows/mobile/), or follow my abbreviated instructions here.
- \[Optional\] Git for Windows -- You don't need git for windows if you are using VSCode, as it comes with it's own packaged version of git accessible via the source control tab.
- Android Studio -- You will need to open it and run the initial standard setup of accepting licenses and installing the SDK and such. You will also need to open "More Actions" and select "SDK Manager", go to the "SDK Tools" tab, and ensure Android SDK Build-Tools and Android SDK Command-line Tools are selected, then click "Ok".
    - Directly -- Follow the instructions [here](https://developer.android.com/studio/install#mac)
- Flutter SDK
    - VSCode -- The flutter extension will prompt you to let it install the Flutter SDK automatically if it can't find it, [here are the instructions](https://docs.flutter.dev/get-started/install/windows/mobile#use-vs-code-to-install-flutter) for that way
    - Directly -- Follow the instructions [here](https://docs.flutter.dev/get-started/install/macos/mobile-ios#download-then-install-flutter). If you use this way, you will likely need to "locate SDK" still in VSCode.
Note that you will not be able to emulate iOS devices on a windows machine. You may be able to use a cloud simulator to test, but we'll leave that as a future endeavor.

### Linux Setup
TODO

## Running the App
The basic workflow of running the app is to launch any necessary emulator for your app to run on, and then run the app.

### Emulators
There are emulators available for iPhone via Xcode and Android via Android Studio. Either of these can be launched via the command palette in VSCode `CMD+SHIFT+P` from "Flutter: Launch Emulator".

### Debug Mode
First navigate to the main file of the app, `lib/main.dart`. This is the launch point for the application.

Ensure the correct platform is selected via the selector in the bottom right. You may see many options including
- Medium Phone API 35 (Android)
- Chrome (web)
- Mac Designed for iPad (desktop)
- macOS (desktop)
- iPhone (iOS)
You will only see available options, so if you don't see what you are looking for, your required emulator is likely not running.

Now you can run the program by pressing `F5`, or going to the "Run and Debug" tab on VSCode and clicking the "Run and Debug" button, or by clicking the run and debug icon on the tab bar.

Tips
- Invoke "debug painting" (choose the "Toggle Debug Paint" action in the IDE, or press "p" in the console), to see the wireframe for each widget.

## Deployment

### Building

### Publishing