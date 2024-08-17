import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageCacheWidget extends StatelessWidget {
  const ImageCacheWidget(
      {super.key,
      required this.image,
      this.height,
      this.width,
      this.placeholder = 'assets/images/Placeholder.png'});
  final String image;
  final String? placeholder;
  final double? height;
  final double? width;
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: BoxFit.cover,
      imageUrl: image,
      placeholder: (context, url) => Image.asset(
        placeholder!,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
      errorWidget: (context, url, error) => Image.asset(
        placeholder!,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }
}
