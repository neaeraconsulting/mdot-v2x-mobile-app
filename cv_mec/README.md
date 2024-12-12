# CV_MEC

This folder contains the source code for building out the CV_MEC mobile application. The Mobile application is built using flutter and currently only supports the Android platform. If you are just trying to get a copy of this application for testing, please consider downloading the app from the google play store instead.

## Getting Started

This project is a starting point for a Flutter application. If you have not yet setup a development environment for flutter please read below for the required programs and recommended installation strategies. After setting up an environment perform the following

### Make sure flutter is setup correctly

To Start run:

```
flutter doctor
```

Currently, this application is only supported on Android, so make sure all Android required components are installed. If non-android components are missing (such as windows app) that is Ok.

### Download Dependencies

```
flutter pub clean
flutter pub get
```

\*These commands will not work unless you are inside the cv_mec directory. To avoid confusion, the proper cv_mec directory is the one with the pubspec.yaml file.

### Run the app

```
flutter run
```

## Development Environment (Windows)

Video tutorial for all described steps: https://www.youtube.com/playlist?list=PL__UlMMmv_rzDm5i-_HXiQ5YoQKsyurfA

You will need the following software packages:

- Flutter
- Android Studio
- VS Code

### Flutter

[Flutter Download](https://docs.flutter.dev/get-started/install/windows)

Must be installed and added to system path
You can test your installation by running the following command in powershell:

```
flutter
```

It should print a large page of white text. If it fails, it will print red text, likely starting with: flutter : The term 'flutter' is not recognized as the name of a cmdlet, function, script file, or operable program.
this means that you did not add it to your system path correctly, or you just need to close and restart powershell

### Android Studio

[Android Studio Download](https://developer.android.com/studio/install)

Must be installed, and you must be able to use the AVD manager to [launch/manage emulated android devices](https://developer.android.com/studio/run/emulator)

### VS Code

[VS Code Download](https://code.visualstudio.com/download)

You must install VS code, and add the [flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter#:~:text=This%20VS%20Code%20extension%20adds,menu%20for%20full%20debugging%20functionality.)

### Flutter FFI and Native Sources

This application utilizes the same ASN.1 C compiler used by the JPO-ODE and other connected vehicle applications. This is done by taking the pre-generated ASN.1 C code and calling it using the Flutter foreign function interface. This process can be done manually, or by using the included dockerfile to automatically build out these sources. For simplicity, it is recommended to use the docker builder for this procedure, as this process has many dependencies. To generate the required build files run the following

```
docker build --target=ffi --output type=local,dest=lib,source=generated_bindings.dart --output type=local,dest=src/,source=generated-files/2020 .
```

### .env file setup
This repo uses a .env file to load sensitive keys into the application. A template sample.env file is included in the repo. Before building the application make sure to copy the sample.env file to .env and populate all keys

```
cp sample.env .env
```
