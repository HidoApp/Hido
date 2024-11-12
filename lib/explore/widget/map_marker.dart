import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MapMarker extends StatelessWidget {
  const MapMarker({
    super.key,
    required this.image,
    required this.region,
  });
  final String image;
  final String region;
  // final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return RepaintBoundary(
      child: Column(children: [
        Container(
          height: width * 0.1,
          width: width * 0.1,
          padding: EdgeInsets.all(width * 0.025),
          margin: EdgeInsets.all(width * 0.025),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              // boxShadow: [
              //   BoxShadow(
              //     color: colorGreen,
              //     blurRadius: width * 0.03,
              //   )
              // ],
              image: DecorationImage(
                filterQuality: FilterQuality.low,
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  maxHeight: 5,
                  maxWidth: 5,
                  errorListener: (p0) =>
                      Image.asset('assets/images/Placeholder.png'),
                  image,
                ),
              ),
              border: Border.all(color: Colors.white, width: 2)),
        ),
        CustomText(
          text: region,
          fontSize: width * 0.03,
          fontWeight: FontWeight.w700,
          shadows: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(1, 1),
            ),
          ],
        )
      ]),
    );
  }
}
