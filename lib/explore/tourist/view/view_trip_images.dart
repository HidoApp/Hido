import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:get/get.dart';

class ViewTripImages extends StatefulWidget {
  final List<String> tripImageUrl;
  final bool fromNetwork;
  const ViewTripImages(
      {Key? key, required this.tripImageUrl, this.fromNetwork = false})
      : super(key: key);

  @override
  State<ViewTripImages> createState() => _ViewTripImagesState();
}

final List<String> defultImage = ['assets/images/Placeholder.png'];

class _ViewTripImagesState extends State<ViewTripImages> {
  // final imageItems = widget.tripImageUrl.map((e) => null);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: CustomAppBar("images".tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.041),
          child: GalleryImage(
            showListInGalley: true,
            showAppBar: false,
            reverse: true,
            crossAxisCount: 2,
            crossAxisSpacing: width * 0.0205,
            mainAxisSpacing: width * 0.0205,
            imageRadius: 0,
            childAspectRatio: 9 / 12,
            numOfShowImages: widget.tripImageUrl.length,
            closeWhenSwipeDown: true,
            closeWhenSwipeUp: true,
            imageUrls: widget.tripImageUrl,
          ),
        ),
        //Wrap(children: images()),
      ),
    );
  }

  List<Widget> images() {
    var items = widget.tripImageUrl
        .map(
          (url) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(6),
            child: ImageCacheWidget(image: url),
          ),
        )
        .toList();
    return items;
  }

  List<Widget> imagesFromNetWork() {
    var items =
        (widget.tripImageUrl.isNotEmpty ? widget.tripImageUrl : defultImage)
            .map((url) => Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: ImageCacheWidget(
                    image: url,
                  ),
                ))
            .toList();
    return items;
  }
}
