import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagesServicesWidget extends StatelessWidget {
  const ImagesServicesWidget({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft:
                  Radius.circular(MediaQuery.of(context).size.width * 0.04),
              bottomRight:
                  Radius.circular(MediaQuery.of(context).size.width * 0.04)),
          child: CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) => Image.asset(
              'assets/images/Placeholder.png',
              fit: BoxFit.cover,
            ),
            fit: BoxFit.fill,
          )),
    );
  }
}
