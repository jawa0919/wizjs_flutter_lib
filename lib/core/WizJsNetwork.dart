/*
 * @FilePath     : /wizjs_flutter_lib/lib/core/WizJsNetwork.dart
 * @Date         : 2021-07-22 14:18:40
 * @Author       : jawa0919 <jawa0919@163.com>
 * @Description  : 网络
 */

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_log/dio_log.dart';
import 'package:flutter/material.dart';

class WizJsNetwork {
  /// 创建dio
  static Dio _createDio({int? timeout}) {
    Dio dio = Dio();
    dio.options.connectTimeout = timeout ?? 3 * 1000;
    dio.options.receiveTimeout = timeout ?? 3 * 1000;
    dio.options.sendTimeout = timeout ?? 3 * 1000;

    final adapter = (dio.httpClientAdapter as DefaultHttpClientAdapter);
    adapter.onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) => true;
    };
    dio.interceptors.add(DioLogInterceptor());
    return dio;
  }

  /// 网络请求
  static Future request(BuildContext context, Map<String, dynamic> req) async {
    String url = req["url"] ?? "";
    String method = req["method"] ?? "GET";
    Map<String, dynamic> header = req["header"] ?? {};
    final data = req["data"];
    if (url.isEmpty) return Future.error("url isEmpty");
    Dio dio = _createDio();
    final options = Options(method: method, headers: header);
    Response response = await dio.request(url, data: data, options: options);
    return {
      "data": response.data,
      "statusCode": response.statusCode,
      "header": response.headers.map,
    };
  }

  /// 下载文件资源到本地
  static Future downloadFile(BuildContext context, Map<String, dynamic> req,
      {ProgressCallback? onReceiveProgress}) async {
    String url = req["url"] ?? "";
    String method = req["method"] ?? "GET";
    Map<String, dynamic> header = req["header"] ?? {};
    Map<String, dynamic> data = req["data"] ?? {};
    String filePath = req["filePath"] ?? "";
    if (url.isEmpty) return Future.error("url isEmpty");
    if (filePath.isEmpty) return Future.error("filePath isEmpty");
    Dio dio = _createDio(timeout: 10 * 60 * 1000);
    final options = Options(method: method, headers: header);
    Response response = await dio.download(url, filePath,
        data: data, onReceiveProgress: onReceiveProgress, options: options);
    return {
      "data": response.data,
      "statusCode": response.statusCode,
      "header": response.headers,
    };
  }

  /// 将本地资源上传到服务器
  static Future uploadFile(BuildContext context, Map<String, dynamic> req,
      {ProgressCallback? onSendProgress}) async {
    String url = req["url"] ?? "";
    String method = req["method"] ?? "GET";
    Map<String, dynamic> header = req["header"] ?? {};
    Map<String, dynamic> data = req["data"] ?? {};
    String filePath = req["filePath"] ?? "";
    if (url.isEmpty) return Future.error("url isEmpty");
    if (filePath.isEmpty) return Future.error("filePath isEmpty");
    Dio dio = _createDio(timeout: 10 * 60 * 1000);
    final options = Options(method: method, headers: header);

    String fileName = filePath.split("/").last;
    final uFile = await MultipartFile.fromFile(filePath, filename: fileName);
    Map<String, dynamic> flieMap = {"files": uFile};
    data.addAll(flieMap);
    FormData formData = FormData.fromMap(data);

    Response response = await dio.post(url,
        data: formData, onSendProgress: onSendProgress, options: options);
    return {
      "data": response.data,
      "statusCode": response.statusCode,
      "header": response.headers,
    };
  }
}
