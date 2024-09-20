import 'dart:developer';

import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../request/tourist/controllers/offer_controller.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  final String title;

  const PaymentWebView({super.key, required this.url, required this.title});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  final OfferController offerController = Get.put(OfferController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(widget.title),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color.fromARGB(0, 255, 254, 254))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {},
              onPageFinished: (String url) {
                //return after payment
                Uri uri = Uri.parse(url);
                var isValid = uri.path.contains('/callback');
                if (isValid) {
                  log('will back');
                  Future.delayed(const Duration(seconds: 1), () => Get.back());
                }
              },
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) async {
                return NavigationDecision.navigate;
              },
              onUrlChange: (change) {},
            ),
          )
          ..loadRequest(Uri.parse(widget.url)),
      ),
    );
  }
}

/* await Future.delayed(const Duration(seconds: 2));
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }*/
