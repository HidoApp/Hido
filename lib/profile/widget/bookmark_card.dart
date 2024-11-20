import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/image_cache_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BookmarkCard extends StatefulWidget {
  const BookmarkCard(
      {super.key,
      required this.title,
      required this.image,
      required this.type,
      required this.id,
      required this.onTap,
      required this.isBookMarked,
      required this.index});
  final String title;
  final String image;
  final String id;
  final String type;
  final int index;
  final bool isBookMarked;
  final Function() onTap;

  @override
  State<BookmarkCard> createState() => _BookmarkCardState();
}

class _BookmarkCardState extends State<BookmarkCard> {
  final _profileController = Get.put(ProfileController());
  bool isMarked = false;
  @override
  void initState() {
    // TODO: implement initState
    _profileController.isbookMarked.value =
        _profileController.bookmarkList[widget.index].isBookMarked;
    super.initState();
  }

  String getIconType() {
    switch (widget.type) {
      case 'event':
        return 'assets/icons/event.svg';
      case 'hospitality':
        return 'assets/icons/hospitality.svg';
      case 'tour':
        return 'assets/icons/place.svg';
      case 'adventure':
        return 'assets/icons/adventure.svg';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
        decoration: BoxDecoration(
            boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
            borderRadius: BorderRadius.circular(8),
            color: black),
        child: GridTile(
          header: Align(
            alignment: AppUtil.rtlDirection2(context)
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    widget.isBookMarked
                        ? 'assets/icons/bookmark_fill.svg'
                        : "assets/icons/bookmark_icon.svg",
                    width: width * 0.06,
                    height: width * 0.06,
                  ),
                ),
              ),
            ),
          ),
          footer: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.030, vertical: width * .0205),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: CustomText(
                    text: widget.title,
                    fontFamily: AppUtil.SfFontType(context),
                    fontSize: width * 0.03,
                  ),
                ),
                SvgPicture.asset(
                  getIconType(),
                  width: width * 0.035,
                  height: width * 0.030,
                )
              ],
            ),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageCacheWidget(image: widget.image)),
        ));
  }
}
