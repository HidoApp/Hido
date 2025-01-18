import 'package:ajwad_v4/share/controller/dynamic_link_controller.dart';
import 'package:uni_links/uni_links.dart';
import 'package:get/get.dart';

class DynamicLinkService {
  static final DynamicLinkController _controller = Get.find();

  static Future<void> init() async {
    // Handle initial link (app opened via a Dynamic link)
    Uri? initialUri = await getInitialUri();
    if (initialUri != null) {
      _handleDynamicLinkFromUri(initialUri);
    }

    // Listen for incoming links (app already opened)
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDynamicLinkFromUri(uri);
      }
    }, onError: (err) {
      print('Error handling incoming links: $err');
    });
  }

  static void _handleDynamicLinkFromUri(Uri uri) {
    print('Received Dynamic link: $uri');

    final slug = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    final params = uri.queryParameters;

    if (slug != null) {
      _handleDynamicLink({
        'slug': slug,
        ...params,
      });
    } else {
      print('Invalid Dynamic link: No slug found.');
    }
  }

  static void _handleDynamicLink(Map<String, dynamic> data) {
    _controller.handleDynamicLink(data);
  }
}
