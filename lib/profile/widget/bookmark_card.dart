import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/bookmark.dart';
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
      required this.index});
  final String title;
  final String image;
  final String type;
  final int index;

  @override
  State<BookmarkCard> createState() => _BookmarkCardState();
}

class _BookmarkCardState extends State<BookmarkCard> {
  final _profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    _profileController.isbookMarked.value =
        _profileController.bookmarkList[widget.index].isBookMarked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
        height: 158,
        width: 170,
        decoration: BoxDecoration(
            boxShadow: const [BoxShadow(blurRadius: 15, color: Colors.black26)],
            borderRadius: BorderRadius.circular(8),
            color: black),
        child: GridTile(
          header: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Obx(
                () => GestureDetector(
                  onTap: () {
                    if (_profileController.isbookMarked.value) {
                      _profileController.isbookMarked(!_profileController.isbookMarked.value);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      _profileController.isbookMarked.value
                          ? 'assets/icons/bookmark_fill.svg'
                          : "assets/icons/bookmark_icon.svg",
                      width: 14,
                      height: 14,
                    ),
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
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: widget.title,
                  fontFamily: AppUtil.SfFontType(context),
                  fontSize: width * 0.03,
                ),
                SvgPicture.asset(
                  'assets/icons/hospitality.svg',
                  width: 14,
                  height: 12,
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
