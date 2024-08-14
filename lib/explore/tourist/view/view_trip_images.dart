import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

class _ViewTripImagesState extends State<ViewTripImages> {
  // final imageItems = widget.tripImageUrl.map((e) => null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("images".tr),
      body: SingleChildScrollView(
          child: StaggeredGrid.count(
        crossAxisCount: 2,
        children: widget.fromNetwork ? imagesFromNetWork() : images(),
      )
          //Wrap(children: images()),
          ),
    );
  }

  List<Widget> images() {
    var items = widget.tripImageUrl
        .map(
          (url) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: EdgeInsets.all(6),
            child: Image.asset(
              url,
              fit: BoxFit.fill,
            ),
          ),
        )
        .toList();
    return items;
  }

  List<Widget> imagesFromNetWork() {
    var items = widget.tripImageUrl
        .map((url) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: EdgeInsets.all(6),
            // child: Image.network(
            //   url,
            //   fit: BoxFit.fill,
            // )
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Image.asset(
                'assets/images/Placeholder.png',
                fit: BoxFit.fill,
              ),
              fit: BoxFit.fill,
            )))
        .toList();
    return items;
  }
}
