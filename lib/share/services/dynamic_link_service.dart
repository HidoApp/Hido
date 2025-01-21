import 'dart:developer';

import 'package:ajwad_v4/share/controller/dynamic_link_controller.dart';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

class DynamicLinkService {
  static final DynamicLinkController _controller = Get.find();

  static Future<void> init() async {
    final appLinks = AppLinks(); // AppLinks is singleton
// Subscribe to all events (initial link and further)

    // Handle initial link (app opened via a Dynamic link)
    Uri? initialUri = await appLinks.getInitialLink();

    // await getInitialUri();
    if (initialUri != null) {
      _handleDynamicLinkFromUri(initialUri);
    }

    final sub = appLinks.uriLinkStream.listen((uri) {
      // Do something (navigation, ...)
      _handleDynamicLinkFromUri(uri);
    }, onError: (err) {
      log('Error handling incoming links: $err');
    });
    // Listen for incoming links (app already opened)
  }

  static void _handleDynamicLinkFromUri(Uri uri) {
    log('Received Dynamic link: $uri');

    final slug = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    final params = uri.queryParameters;

    if (slug != null) {
      _handleDynamicLink({
        'slug': slug,
        ...params,
      });
    } else {
      log('Invalid Dynamic link: No slug found.');
    }
  }

  static void _handleDynamicLink(Map<String, dynamic> data) {
    _controller.handleDynamicLink(data);
  }
}
