library wizjs_flutter_lib;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'core/WizJsBase.dart';
import 'core/WizJsRoute.dart';
import 'core/WizJsNavigate.dart';
import 'core/WizJsShare.dart';
import 'core/WizJsUi.dart';
import 'core/WizJsNetwork.dart';
import 'core/WizJsStorage.dart';
import 'core/WizJsMedia.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

typedef JSCallback = Future<Map<String, dynamic>> Function(
    BuildContext context, Map<String, dynamic> req);

class WizSdk {
  static const CHANNEL_NAME = "Wiz";

  final BuildContext context;
  final Completer<WebViewController> ctrl;

  final JSCallback? userTokenCallback;
  final JSCallback? stopPullDownRefreshCallback;
  final JSCallback? startPullDownRefreshCallback;

  WizSdk(
    this.context,
    this.ctrl, {
    this.userTokenCallback,
    this.stopPullDownRefreshCallback,
    this.startPullDownRefreshCallback,
  });

  JavascriptChannel channel() {
    return JavascriptChannel(
      name: CHANNEL_NAME,
      onMessageReceived: (JavascriptMessage message) {
        _message(message.message);
      },
    );
  }

  void _message(String message) {
    Map<String, dynamic> msg = jsonDecode(message);
    log("$msg");
    String api = msg["api"];
    String id = msg["id"];
    Map<String, dynamic> req = msg["req"];
    List<String> func = msg["func"].cast<String>();
    Future.value(api).then((value) {
      switch (api) {

        /// WizJsBase
        case "test":
          return WizJsBase.test();
        case "env":
          return WizJsBase.env();
        case "getSystemInfo":
          return WizJsBase.getSystemInfo(context);

        /// WizJsRoute
        case "reLaunch":
          return WizJsRoute.reLaunch(context, req["url"]);
        case "redirectTo":
          return WizJsRoute.redirectTo(context, req["url"]);
        case "navigateTo":
          return WizJsRoute.navigatorTo(context, req["url"]);

        /// WizJsNavigate

        /// WizJsShare

        /// WizJsUi
        case "stopPullDownRefresh":
          if (this.stopPullDownRefreshCallback == null)
            throw UnsupportedError("stopPullDownRefreshCallback");
          return this.stopPullDownRefreshCallback?.call(context, {});
        case "startPullDownRefresh":
          if (this.stopPullDownRefreshCallback == null)
            throw UnsupportedError("startPullDownRefresh");
          return this.startPullDownRefreshCallback?.call(context, {});

        /// WizJsNetwork
        case "request":
          return WizJsNetwork.request(context, req);
        case "downloadFile":
          return WizJsNetwork.downloadFile(context, req,
              onReceiveProgress: (count, total) async {
            log("downloadFile Progress: count-$count total-$total");
            final progress = count * 100 ~/ total;
            final v = {
              "progress": progress,
              "totalBytesWritten": count,
              "totalBytesExpectedToWrite": total
            };
            String codeStr = jsonEncode(v);
            String evalCode = "$CHANNEL_NAME.$api$id.${func.first}($codeStr)";
            await (await ctrl.future).evaluateJavascript(evalCode);
          });
        case "uploadFile":
          return WizJsNetwork.uploadFile(context, req,
              onSendProgress: (count, total) async {
            log("uploadFile Progress: count-$count total-$total");
            final progress = count * 100 ~/ total;
            final v = {
              "progress": progress,
              "totalBytesWritten": count,
              "totalBytesExpectedToWrite": total
            };
            String codeStr = jsonEncode(v);
            String evalCode = "$CHANNEL_NAME.$api$id.${func.first}($codeStr)";
            await (await ctrl.future).evaluateJavascript(evalCode);
          });

        /// WizJsStorage
        case "setStorage":
          return WizJsStorage.setStorage(req);
        case "removeStorage":
          return WizJsStorage.removeStorage(req);
        case "getStorage":
          return WizJsStorage.getStorage(req);
        case "getStorageInfo":
          return WizJsStorage.getStorageInfo();
        case "clearStorage":
          return WizJsStorage.clearStorage();

        /// WizJsMedia
        case "saveImageToPhotosAlbum":
          return WizJsMedia.saveImageToPhotosAlbum(req);

        ///
        ///
        ///
        ///
        ///
        ///
        ///
        ///
        ///
        default:
          throw UnsupportedError("$api");
      }
    }).then((value) async {
      log("then: $value");
      String codeStr = jsonEncode(value);
      String evalCode = "$CHANNEL_NAME.$api$id.resolve($codeStr)";
      await (await ctrl.future).evaluateJavascript(evalCode);
    }).catchError((error) async {
      log("error: $error");
      String codeStr = jsonEncode("$error");
      String evalCode = "$CHANNEL_NAME.$api$id.reject($codeStr)";
      await (await ctrl.future).evaluateJavascript(evalCode);
    });
  }
}
