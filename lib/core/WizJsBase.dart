/*
 * @FilePath     : /wizjs_flutter_lib/lib/core/WizJsBase.dart
 * @Date         : 2021-07-20 14:35:37
 * @Author       : jawa0919 <jawa0919@163.com>
 * @Description  : 基础
 */

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class WizJsBase {
  /// test
  static Future test() async {
    return "test";
  }

  /// env
  static Future env() async {
    return "env";
  }

  /// getSystemInfo
  static Future getSystemInfo(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    final ori = MediaQuery.of(context).orientation.toString().split(".").last;
    if (Platform.isAndroid) {
      final build = await DeviceInfoPlugin().androidInfo;
      return {
        "brand": build.brand,
        "model": build.model,
        "version": info.version,
        "system": build.version.sdkInt,
        "platform": "Android",
        "cameraAuthorized": await Permission.camera.isGranted,
        "locationAuthorized": await Permission.location.isGranted,
        "microphoneAuthorized": await Permission.camera.isGranted,
        "deviceOrientation": ori
      };
    } else if (Platform.isIOS) {
      final build = await DeviceInfoPlugin().iosInfo;
      return {
        "brand": build.systemName,
        "model": build.model,
        "version": info.version,
        "system": build.utsname.version,
        "platform": "IOS",
        "cameraAuthorized": await Permission.camera.isGranted,
        "locationAuthorized": await Permission.location.isGranted,
        "microphoneAuthorized": await Permission.microphone.isGranted,
        "deviceOrientation": ori
      };
    } else {
      throw UnsupportedError("other Platform");
    }
  }
}
