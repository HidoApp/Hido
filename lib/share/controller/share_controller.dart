// controoler

import "dart:developer";
import "package:ajwad_v4/services/controller/hospitality_controller.dart";
import "package:ajwad_v4/services/view/hospitality_details.dart";
import "package:ajwad_v4/services/view/local_event_details.dart";
import "package:firebase_dynamic_links/firebase_dynamic_links.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:share_plus/share_plus.dart";

class DynamicLinkController extends GetxController {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  //Generate dynamicLink with id
  generateCourseLink(String id, String type) async {
    final dynamicLinkParameters = DynamicLinkParameters(
      link: Uri.parse("https://hido.page.link/?view_id=$id&type=$type"),
      uriPrefix: "uriPrefix",
      androidParameters: AndroidParameters(
        packageName: "packageName", //IF App is installed => opens app
        fallbackUrl: Uri.parse("fallbackUrl/"), //IF Not installed => AppStore
      ),
      iosParameters: IOSParameters(
        bundleId: "bundleId", //IF App is installed => opens app
        appStoreId: "appStoreId",
        fallbackUrl: Uri.parse("fallbackUrl/"), //IF Not installed => AppStore
      ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: course?.title ?? "",
      //   imageUrl: Uri.parse(course?.logo.toString() ?? ""),
      //   description: course?.description ?? "",
      // ),
    );

    //Generate short DynamicLink
    final shortDynamicLink = await FirebaseDynamicLinks.instance
        .buildShortLink(dynamicLinkParameters);

    // Save Coures/PracticalProject index
    Share.share(shortDynamicLink.shortUrl.toString());
  }

  // Move to Correct Item Screen
  moveToScreen({
    required String contentId,
    required String contentType,
  }) {
    switch (contentType) {
      case "hospitality":
        // final hospitaltyController = Get.put(HospitalityController());
        Get.to(() => HospitalityDetails(hospitalityId: contentId));
        break;
      case "event":
        Get.to(() => LocalEventDetails(eventId: contentId));
        break;

      default:
    }
  }

// ==========================================================
// Open link (App in the Background)
  Future initDynamicLink() async {
    dynamicLinks.onLink.listen(
      (event) async {
        var receivedId = event.link.queryParameters.values.first;
        var contentType = event.link.queryParameters["type"];
        moveToScreen(contentId: receivedId, contentType: contentType ?? "");
      },
    );
    // ignore: unused_label
    onError:
    (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    };
  }

// To Do..
// ==========================================================
// Open Link (App Closed)
  initDynamicLinkClosedApp() async {
    // Search for Dynamic Link
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    if (data != null) {
      try {
        // Save Course Id from received Link
        // Move to Correct Item Details Screen

        // moveToScreen(course);
      } catch (e) {
        log(e.toString());
      }
    } else {}
  }
}

// used ->
// onPressed: () {
//                 DynamicLinkController dynamicLinkController = Get.find<DynamicLinkController>();

//                 dynamicLinkController.course = course;

//                 dynamicLinkController.generateCourseLink(courseId!, course!, contentType!);
//               },