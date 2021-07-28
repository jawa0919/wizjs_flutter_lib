/*
 * @FilePath     : /wizjs_flutter_lib/lib/core/WizJsStorage.dart
 * @Date         : 2021-07-22 17:12:59
 * @Author       : jawa0919 <jawa0919@163.com>
 * @Description  : 数据缓存
 */

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../wizjs_flutter_lib.dart';

class WizJsStorage {
  /// js存储的前缀
  static const String _PREFIX = "JsStorage_${WizSdk.CHANNEL_NAME}_";

  /// 将数据存储在本地缓存中指定的 key 中
  static Future<bool> setStorage(Map<String, dynamic> req) async {
    String key = req['key'] ?? "";
    dynamic value = req['value'] ?? "";
    if (key.isEmpty) return Future.error("key.isEmpty");
    if (null == value) return Future.error("value null");
    final sp = await SharedPreferences.getInstance();
    String keyStr = "$_PREFIX$key";
    String keyValueStr = jsonEncode({key: value});

    return await sp.setString(keyStr, keyValueStr);
  }

  /// 从本地缓存中移除指定 key
  static Future<bool> removeStorage(Map<String, dynamic> req) async {
    String key = req['key'] ?? "";
    if (key.isEmpty) return Future.error("key.isEmpty");
    final sp = await SharedPreferences.getInstance();
    String keyStr = "$_PREFIX$key";

    return await sp.remove(keyStr);
  }

  /// 从本地缓存中异步获取指定 key 的内容
  static Future getStorage(Map<String, dynamic> req) async {
    String key = req['key'] ?? "";
    if (key.isEmpty) return Future.error("key.isEmpty");
    final sp = await SharedPreferences.getInstance();
    String keyStr = "$_PREFIX$key";
    String keyValueStr = sp.getString(keyStr) ?? "";

    if (keyValueStr.isEmpty) return Future.error("no find key-value");
    final keyValueMap = jsonDecode(keyValueStr);
    return keyValueMap[key];
  }

  /// 获取当前storage的相关信息
  static Future<Map<String, dynamic>> getStorageInfo() async {
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys().where((e) => e.startsWith(_PREFIX));
    return {"keys": keys.map((e) => e.replaceFirst(_PREFIX, "")).toList()};
  }

  /// 清理本地数据缓存
  static Future<bool> clearStorage() async {
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys().where((e) => e.startsWith(_PREFIX));
    final v = await Future.wait<bool>(keys.map((e) => sp.remove(e)));
    return v.fold<bool>(true, (p, e) => p && e);
  }
}
