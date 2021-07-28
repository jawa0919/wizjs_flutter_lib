/*
 * @FilePath     : /wizjs_flutter_lib/wizjs_flutter_lib_example/lib/H5Page.dart
 * @Date         : 2021-07-20 10:21:22
 * @Author       : jawa0919 <jawa0919@163.com>
 * @Description  : H5Page
 */

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wizjs_flutter_lib/wizjs_flutter_lib.dart';

class H5Page extends StatefulWidget {
  final String url;
  final String title;
  final WebViewCreatedCallback? createdCallback;

  H5Page({
    Key? key,
    this.url = "http://192.168.205.202:9876/",
    this.title = "",
    this.createdCallback,
  }) : super(key: key);

  @override
  _H5PageState createState() => _H5PageState();
}

class _H5PageState extends State<H5Page> {
  final String jsErudaDebug = """
  javascript: (function () {
    var script = document.createElement("script");
    script.src = "//cdn.jsdelivr.net/npm/eruda";
    document.body.appendChild(script);
    script.onload = function () {
      eruda.init();
    };
    })();
    """;

  final Completer<WebViewController> _ctrl = Completer<WebViewController>();

  String _userAgent = "";
  bool _isLoading = true;

  late WizSdk sdk;

  @override
  void initState() {
    super.initState();
    log("_H5PageState initState");
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title.isEmpty ? null : AppBar(title: Text(widget.title)),
      body: Builder(builder: (context) {
        sdk = WizSdk(context, _ctrl);
        return Stack(
          alignment: Alignment.center,
          children: [
            SafeArea(
              child: WebView(
                key: widget.key,
                onWebViewCreated: (WebViewController controller) {
                  log('---------------onWebViewCreated: ');
                  _onWebViewCreated(context, controller);
                },
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: _initJsChannels(context),
                navigationDelegate: (NavigationRequest request) {
                  log('---------------navigationDelegate: $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  log('---------------onPageStarted: $url');
                },
                onPageFinished: (String url) {
                  log('---------------onPageFinished: $url');
                  Future.delayed(Duration(milliseconds: 100), () {
                    _isLoading = false;
                    setState(() {});
                  });
                },
                onProgress: (int progress) {
                  log('---------------onProgress: $progress');
                },
                onWebResourceError: (error) {
                  log('---------------onWebResourceError: ${error.description}');
                },
                gestureNavigationEnabled: true,
                userAgent: _userAgent,
                allowsInlineMediaPlayback: true,
              ),
            ),
            if (_isLoading)
              Scaffold(body: Center(child: CircularProgressIndicator())),
          ],
        );
      }),
    );
  }

  void _onWebViewCreated(BuildContext context, WebViewController ctrl) {
    _ctrl.complete(ctrl);
    if (_userAgent.isEmpty) {
      final jscmd = 'ShowUA.postMessage(navigator.userAgent)';
      ctrl.evaluateJavascript(jscmd);
      Future.delayed(Duration(milliseconds: 100), () {
        ctrl.evaluateJavascript(jsErudaDebug);
      });
    }
  }

  Set<JavascriptChannel> _initJsChannels(BuildContext context) {
    log('---------------_initJsChannels');
    return [
      sdk.channel(),
      JavascriptChannel(
        name: "ShowUA",
        onMessageReceived: (JavascriptMessage message) {
          _userAgent = "${message.message} WizAppWebView";
        },
      ),
    ].toSet();
  }
}
