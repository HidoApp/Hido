import 'dart:developer';

import 'package:ajwad_v4/services/view/hospitality_details.dart';
import 'package:ajwad_v4/services/view/local_event_details.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

class ShareServices {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  // Generate dynamic link with ID
  static Future<Uri> generateLink({
    required String viewId,
    required String type,
  }) async {
    final dynamicLinkParameters = DynamicLinkParameters(
      // longDynamicLink: Uri.parse(
      // "https://hido.page.link/?link=https://hido.page.link/hospitality?view_id=$viewId%26type=$type&apn=com.hido.hidoapp&isi=6477162077&ibi=com.hido.hidoapp&efr=1"),
      link:
          Uri.parse('https://hido.page.link/$type?view_id=$viewId&type=$type'),

      uriPrefix: "https://hido.page.link",
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
      androidParameters: const AndroidParameters(
        packageName: "com.hido.app",
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.hido.app.ios",
        appStoreId: '6477162077',
      ),
    );

    // Generate short DynamicLink
    final shortDynamicLink = await dynamicLinks.buildShortLink(
        dynamicLinkParameters,
        shortLinkType: ShortDynamicLinkType.unguessable);
    return shortDynamicLink.shortUrl;
  }

  // Navigate to the correct screen
  static moveToScreen({
    required String contentId,
    required String contentType,
  }) {
    switch (contentType) {
      case "hospitality":
        Get.to(() => HospitalityDetails(hospitalityId: contentId));
        break;
      case "event":
        Get.to(() => LocalEventDetails(eventId: contentId));
        break;
      default:
        log("Invalid content type: $contentType");
    }
  }

  // Handle dynamic link when the app is in the background
  static Future initDynamicLink() async {
    // ignore: deprecated_member_use
    await FirebaseDynamicLinks.instance.getInitialLink();

    dynamicLinks.onLink.listen((event) async {
      final Uri deepLink = event.link;
      log("Dynamic link received: $deepLink");
      log("Dynamic link received: $event");
      var receivedId = event.link.queryParameters['view_id'];
      var contentType = event.link.queryParameters["type"];
      log(receivedId ?? "no ID");
      log(contentType ?? "no content");
      moveToScreen(contentId: receivedId ?? "", contentType: contentType ?? "");
    }).onError((error) {
      log("Error in dynamic link listener: $error");
    });
  }

  // Handle dynamic link when the app is closed
  static Future initDynamicLinkClosedApp() async {
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    if (data != null) {
      final Uri deepLink = data.link;
      log("Initial dynamic link received: $deepLink");
      var receivedId = deepLink.queryParameters['view_id'];
      var contentType = deepLink.queryParameters["type"];
      if (receivedId != null && contentType != null) {
        moveToScreen(contentId: receivedId, contentType: contentType);
      }
    }
  }
}