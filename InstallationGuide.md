INSTALLATION GUIDE

Steps to get the flutter sdk and Run the App
* Open a new terminal window
* Type: git clone -b beta https://github.com/flutter/flutter.git
* Wait for the SDK to clone onto your machine
* Type: `export PATH=$PWD/flutter/bin:$PATH` , which adds flutter tool to your path
* Type: flutter doctor , which downloads additional dependencies
* Wait for dependencies to download and install
* After this open Android Studio and install Dart sdk from configurations or try running `flutter version <flutter-version>` latest version is recommended. 
* Git clone the Project Repo from git and Import it from android studio
* In terminal run, Run `flutter doctor -v` to check if everything is working fine [ ticked ]
* Run this command to create and install apk file in debug mode on your device directly => `flutter run -t lib/main.dart -d <device_id>`

Below is the process to generate .aab file and .apk in release mode :=
* Run `flutter build appbundle` => 
A release bundle for the app is created at <app-dir>/build/app/outputs/bundle/release/app.aab
  ```
  This file is published on play store
  
  OUTPUT =>
  
  Running Gradle task 'bundleRelease'...                                  
  Running Gradle task 'bundleRelease'... Done                        87.4s
  ✓ Built build/app/outputs/bundle/release/app-release.aab (21.8MB).
  ```
  
* Run `flutter build apk` => flutter build apk --release
```
  You are building a fat APK that includes binaries for android-arm, android-arm64, android-x64.
If you are deploying the app to the Play Store, it's recommended to use app bundles or split the APK to reduce the APK size.
    To generate an app bundle, run:
        flutter build appbundle --target-platform android-arm,android-arm64,android-x64
        Learn more on: https://developer.android.com/guide/app-bundle
    To split the APKs per ABI, run:
        flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
        Learn more on:  https://developer.android.com/studio/build/configure-apk-splits#configure-abi-split
        
OUTPUT =>

  Removed unused resources: Binary resource data reduced from 707KB to 676KB: Removed 4%
  Running Gradle task 'assembleRelease'...                                
  Running Gradle task 'assembleRelease'... Done                      65.7s
  ✓ Built build/app/outputs/apk/release/app-release.apk (21.5MB).
 ```
  
* To seperately install .apk (device and platform specific) through command line, run `flutter run --release -t lib/main.dart`

  ```
  This not only reduces the app size but also makes the app faster. 
  
  OUTPUT =>
  
  Running Gradle task 'assembleRelease'...                                
  Running Gradle task 'assembleRelease'... Done                      60.4s
  ✓ Built build/app/outputs/apk/release/app-release.apk (9.5MB).
  ```
  
For more information related to installation and publish of apk in flutter framework, visit https://flutter.dev/docs/deployment/android
