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
    print(widget.url);
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
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) async {


                  // log("request \n ${request.url} \n --------------------->");
                  // if (request.url.contains("status=paid")) {
                  //   // log("offerController.offerDetails.value.id! ${offerController.offerDetails.value.id!}");
                  //   // log(" offerController.offerDetails.value.schedule! ${offerController.offerDetails.value.schedule!.length}");
                  //   // try {
                  //   //   AcceptedOffer? acceptedOffer =
                  //   //       await offerController.acceptOffer(
                  //   //           context: context,
                  //   //           offerId: offerController.offerDetails.value.id!,
                  //   //           schedules:
                  //   //               offerController.offerDetails.value.schedule!);
                  //   //   if (context.mounted && acceptedOffer != null) {
                  //   //     log("acceptedOffer ${acceptedOffer.orderStatus}");
                  //   //     log("offerController.offerDetails.value.id! ${offerController.offerDetails.value.id!}");
                  //   //     OfferDetails? offerDetails =
                  //   //         await offerController.getOfferById(
                  //   //             context: context,
                  //   //             offerId:
                  //   //                 offerController.offerDetails.value.id!);
                  //   //     if (offerDetails != null) {
                  //   //       log("offerDetails.booking!.chatId! ${offerDetails.booking!.chatId!}");
                  //   //       log("offerController.offerDetails.value.booking! ${offerController.offerDetails.value.booking!}");
                  //   //       Get.to(() => ChatScreenLive(
                  //   //             chatId: offerDetails.booking!.chatId!,
                  //   //             booking:
                  //   //                 offerController.offerDetails.value.booking!,
                  //   //             isAjwadi: false,
                  //   //           ));
                  //   //     }
                  //   //   }
                  //   // } catch (e) {
                  //   //   log("e $e");
                  //   // }
                  //   Get.back();
                  //   Get.back();
                  //   Get.back();
                  //   Get.back();
                  //   Get.back();
                  // }

                  return NavigationDecision.navigate;
                },
                onUrlChange: (change) {},
              ),
            )
            ..loadRequest(Uri.parse(widget.url)),
        ));
  }
}

/* await Future.delayed(const Duration(seconds: 2));
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }*/
