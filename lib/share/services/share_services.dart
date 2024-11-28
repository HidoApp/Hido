import 'dart:developer';

import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

class ShareServices {
  static Future<Uri> createLink(
      {required String id, required String type}) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          'https://hido.page.link/$type/$id'), // Include ID in the URL
      uriPrefix: "https://hido.page.link",
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
      androidParameters: const AndroidParameters(
        packageName: "com.hido.app.android",
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.hido.app.ios",
        appStoreId: '6477162077',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Hido Event',
        description: 'Check out this $type event',
      ),
    );

    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      // shortLinkType: ShortDynamicLinkType.unguessable,
    );

    log("Dynamic Link: ${dynamicLink.previewLink}");

    return dynamicLink.shortUrl;
  }

  static void handleDynamicLinks() {
    // Handle dynamic links when app is running
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData? dynamicLink) {
        final Uri? deepLink = dynamicLink?.link;
        if (deepLink != null) {
          _processDeepLink(deepLink);
        }
      },
      onError: (error) {
        log('Dynamic Link Error: $error');
      },
    );

    // Handle initial dynamic link when app is first opened
    _checkInitialDynamicLink();
  }

  static void _processDeepLink(Uri deepLink) {
    log('Processing Deep Link: ${deepLink.toString()}');

    // Split path segments to extract type and ID
    final pathSegments = deepLink.pathSegments;

    // Check if the link has enough segments
    if (pathSegments.length >= 2) {
      final type = pathSegments[0];
      final id = pathSegments[1];

      log('Link Type: $type');
      log('Link ID: $id');

      // Navigate based on the type
      switch (type) {
        case 'hospitality':
          log("Navigating to Hospitality");
          // Example navigation
          // Get.offAll(() => HospitalityDetailPage(id: id));
          break;
        case 'event':
          log("Navigating to Event");
          // Example navigation
          // Get.offAll(() => EventDetailPage(id: id));
          break;
        default:
          log("Unknown link type: $type");
      }
    }
  }

  static Future<void> _checkInitialDynamicLink() async {
    try {
      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (initialLink != null) {
        final Uri? deepLink = initialLink.link;
        if (deepLink != null) {
          log('Initial Deep Link: ${deepLink.toString()}');
          _processDeepLink(deepLink);
        }
      }
    } catch (e) {
      log('Error checking initial dynamic link: $e');
    }
  }
}
