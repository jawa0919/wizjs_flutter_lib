library wizjs_flutter_lib;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'core/Base.dart';

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

  WizSdk(
    this.context,
    this.ctrl, {
    this.userTokenCallback,
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
        case "test":
          return Base.test();
        case "env":
          return Base.env();
        case "getSystemInfo":
          return Base.getSystemInfo(context);

        default:
          return Future.error("Todo $api");
      }
    }).then((value) async {
      log("then: $value");
      String codeStr = jsonEncode(value);
      String evalCode = "$CHANNEL_NAME.$api$id.resolve($codeStr)";
      await (await ctrl.future).evaluateJavascript(evalCode);
    }).catchError((error) async {
      log("error: $error");
      String codeStr = jsonEncode(error);
      String evalCode = "$CHANNEL_NAME.$api$id.reject($codeStr)";
      await (await ctrl.future).evaluateJavascript(evalCode);
    });
  }
}
