import 'package:flutter/material.dart';

class ImagesServicesWidget extends StatelessWidget {
  const ImagesServicesWidget({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)
            ),
        child: Image.network(
          image,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
