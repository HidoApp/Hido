import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class ShareServices {
  static Future<Uri> createLink(
      {required String id, required String type}) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.hido.app/"),
      uriPrefix: "https://hido.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.hido.app.android"),
      iosParameters: const IOSParameters(bundleId: "com.hido.app.ios"),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    // 4. Log the Dynamic Link
    log("Dynamic Link:");
    log(dynamicLink.toString()); // Get the short URL
    return dynamicLink;
    // 5. Use the Dynamic Link (e.g., share it)
    // You can now use the dynamicLink.shortUrl to share the link
  }
}
