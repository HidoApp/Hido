import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Container(
        height: height,
        color: Colors.white,
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color.fromARGB(0, 255, 254, 254))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {},
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
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
