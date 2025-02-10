# Kronos - NTP plugin for Flutter

[![pub package](https://img.shields.io/pub/v/flutter_kronos_plus.svg)](https://github.com/Mo0Khaled/flutter-kronos-plus.git)
[![pub package](https://img.shields.io/github/license/hautvfami/flutter-kronos.svg?style=flat)](https://github.com/Mo0Khaled/flutter-kronos-plus.git)
[![pub package](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/Mo0Khaled/flutter-kronos-plus.git)

A continuation of the original Flutter [plugin](https://github.com/hautvfami/flutter-kronos.git)
that allows you to call Network Time Protocol (NTP) synchronization library for providing a trusted clock.


Unlike the device clock, the time reported by Kronos is unaffected when the local time is changed while your app is running. Instead, Kronos stores accurate time along with a delta between the NTP time and the system uptime. Since uptime increases monotonically, Kronos isn't affected by device time changes. Accessing `KronosClock.getCurrentTimeMs()` will return the local time based on the last known accurate time + delta since last sync.

Since it relies on system uptime, Kronos detects and requires a new sync after each reboot. 

This plugin is based on [`Kronos`][1] in iOS and [`Kronos-Android`][2] in android for the whole SNTP protocol implementation.

## Installation

Just add `flutter_kronos_plus` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

### Android

Add the following permission in your Android Manifest file:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Usage

### Sync clock using a pool of NTP servers

Calling `FlutterKronosPlus.sync` will fire a bunch of NTP requests to up to 5 of the
servers on the given NTP pool. As soon as
we get the first response, the given closure is called but the `FlutterKronosPlus`
will keep trying to get a more accurate response.

```dart
FlutterKronosPlus.sync();
```

### Get an NTP time

```dart
int? FlutterKronosPlus.getCurrentTimeMs(); //return time from the fallback clock if Kronos has not yet been synced
int? FlutterKronosPlus.getCurrentNtpTimeMs(); //return null if Kronos has not yet been synced
DateTime? FlutterKronosPlus.getDateTime(); //return null if Kronos has not yet been synced
DateTime? FlutterKronosPlus.getNtpDateTime(); //return null if Kronos has not yet been synced
```


<p align="center">
    <img src="https://www.pngplay.com/wp-content/uploads/8/In-Time-Transparent-Background.png" />
</p>

[1]: https://github.com/lyft/Kronos
[2]: https://github.com/lyft/Kronos-Android