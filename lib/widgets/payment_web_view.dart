import 'dart:developer';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:amplitude_flutter/events/base_event.dart';
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
                //   var isValid = uri.path.contains('/callback');
                var isSuccess = uri.path.contains('/success');
                var isFailed = uri.path.contains('/failed');

                if (isSuccess) {
                  log('succes');
                  log(url);
                  AmplitudeService.amplitude.track(BaseEvent(
                    'user reach  to success screen and the payment was successful',
                  ));
                  Future.delayed(const Duration(seconds: 3), () => Get.back());
                }
                if (isFailed) {
                  log('failed');
                  log(url);
                  AmplitudeService.amplitude.track(BaseEvent(
                    'user reach to failed screen and the payment was failed',
                  ));
                  Future.delayed(const Duration(seconds: 3), () => Get.back());
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
