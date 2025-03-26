import 'dart:developer';

import 'package:ajwad_v4/share/controller/dynamic_link_controller.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicLinkService {
  static final DynamicLinkController _controller = Get.find();

  static Future<void> init() async {
    final appLinks = AppLinks();
    Uri? initialUri = await appLinks.getInitialLink();
    log('Initial URI: $initialUri');

    if (initialUri != null) {
      _handleDynamicLinkFromUri(initialUri);
    }

    // Wait a bit to ensure dynamic link processing before UI shows
    // await Future.delayed(const Duration(milliseconds: 500));

    // Listen for incoming links when the app is running
    appLinks.uriLinkStream.listen((uri) {
      log('Received URI from stream: $uri');
      _handleDynamicLinkFromUri(uri);
    }, onError: (err) {
      log('Error handling incoming links: $err');
    });
  }

  static void _handleDynamicLinkFromUri(Uri uri) {
    log('Received Dynamic link: $uri');

    final slug = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    final params = uri.queryParameters;

    if (slug != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleDynamicLink({
          'slug': slug,
          ...params,
        });
      });
    } else {
      log('Invalid Dynamic link: No slug found.');
    }
  }

  static void _handleDynamicLink(Map<String, dynamic> data) {
    _controller.handleDynamicLink(data);
  }
}
