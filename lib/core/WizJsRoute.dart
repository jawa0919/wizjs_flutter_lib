/*
 * @FilePath     : /wizjs_flutter_lib/lib/core/WizJsRoute.dart
 * @Date         : 2021-07-22 10:10:54
 * @Author       : jawa0919 <jawa0919@163.com>
 * @Description  : 路由
 */

import 'package:flutter/material.dart';

class WizJsRoute {
  /// 关闭所有页面，打开到应用内的某个页面
  static Future reLaunch(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    String routeName = uri.path;
    Map<String, String> arguments = uri.queryParameters;
    NavigatorState of = Navigator.of(context);
    return await of.pushNamedAndRemoveUntil(routeName, (route) => false,
        arguments: arguments);
  }

  /// 关闭当前页面，跳转到应用内的某个页面
  static Future redirectTo(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    String routeName = uri.path;
    Map<String, String> arguments = uri.queryParameters;
    NavigatorState of = Navigator.of(context);
    return await of.popAndPushNamed(routeName, arguments: arguments);
  }

  /// 保留当前页面，跳转到应用内的某个页面
  static Future navigatorTo(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    String routeName = uri.path;
    Map<String, String> arguments = uri.queryParameters;
    NavigatorState of = Navigator.of(context);
    return await of.pushNamed(routeName, arguments: arguments);
  }
}
