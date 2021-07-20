/*
 * @FilePath     : /wizjs_flutter_lib/lib/core/Base.dart
 * @Date         : 2021-07-20 14:35:37
 * @Author       : wangjia <jawa0919@163.com>
 * @Description  : Base
 */

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class Base {
  /// test
  static Future test() async {
    return "test";
  }

  /// env
  static Future env() async {
    return "dsad/dasd";
  }

  /// getSystemInfo
  static Future getSystemInfo(BuildContext context) async {
    if (Platform.isAndroid) {
      final build = await DeviceInfoPlugin().androidInfo;
      return {
        "brand": build.brand,
        "model": build.model,
        "pixelRatio": "test",
        "screenWidth": "test",
        "screenHeight": "test",
        "statusBarHeight": "test",
        "version": "test",
        "system": build.version.sdkInt,
        "platform": "Android",
        "deviceOrientation": "test"
      };
    } else if (Platform.isIOS) {
      final data = await DeviceInfoPlugin().iosInfo;
      return {
        "brand": data.systemName,
        "model": data.model,
        "pixelRatio": "test",
        "screenWidth": "test",
        "screenHeight": "test",
        "statusBarHeight": "test",
        "version": "test",
        "system": data.utsname.version,
        "platform": "IOS",
        "deviceOrientation": "test"
      };
    } else {
      throw UnsupportedError("other Platform");
    }
  }
}
