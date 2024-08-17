import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewSheet extends StatelessWidget {
  const WebViewSheet(
      {super.key, required this.url, required this.title, this.height});
  final String url;
  final double? height;

  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Container(
        height: height,
        color: Colors.white,
        child: WebViewWidget(
          controller: WebViewController()
            ..enableZoom(false)
            ..setBackgroundColor(Colors.white)
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color.fromARGB(0, 255, 254, 254))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {},
                onPageStarted: (String url) {},
                onPageFinished: (String url) {
                  Uri uri = Uri.parse(url);
                  var isValid = uri.path.contains('/callback');
                  if (isValid) {
                    log('will back');
                    Future.delayed(
                        const Duration(seconds: 1), () => Get.back());
                  }
                },
                onWebResourceError: (WebResourceError error) {
                  log('error');
                  log(error.description);
                },
                onNavigationRequest: (NavigationRequest request) async {
                  return NavigationDecision.navigate;
                },
                onUrlChange: (change) {},
              ),
            )
            ..loadRequest(Uri.parse(url)),
        ),
      ),
    );
  }
}
