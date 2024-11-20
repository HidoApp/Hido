import 'dart:developer';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/services/bookmark_services.dart';
import 'package:ajwad_v4/profile/widget/bookmark_card.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({
    super.key,
  });

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _profileController.bookmarkList(BookmarkService.getBookmarks());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.of(context).size.height;
    log(_profileController.bookmarkList.length.toString());
    log(GetStorage().read('user_id') ?? "NULL");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        'bookmark'.tr,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: width * 0.041,
          right: width * 0.041,
          bottom: width * 0.030,
          top: width * 0.030,
        ),
        child: Obx(
          () => _profileController.bookmarkList.isEmpty
              ? Center(
                  child: CustomEmptyWidget(
                    title: 'noBookmarks'.tr,
                    subtitle: 'emptyBookmarkText'.tr,
                    height: 38,
                    width: 38,
                    image: 'bookmark_empty',
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: width * 0.041,
                    crossAxisSpacing: width * 0.046,
                  ),
                  itemCount: _profileController.bookmarkList.length,
                  itemBuilder: (context, index) => BookmarkCard(
                      onTap: () {
                        final bookmark = _profileController.bookmarkList[index];
                        _profileController.isbookMarked(
                            !_profileController.isbookMarked.value);
                        if (_profileController
                            .bookmarkList[index].isBookMarked) {
                          BookmarkService.removeBookmark(
                              _profileController.bookmarkList[index].id);
                        } else {
                          BookmarkService.addBookmark(bookmark);
                        }
                        _profileController
                            .bookmarkList(BookmarkService.getBookmarks());
                        setState(() {});
                      },
                      isBookMarked:
                          _profileController.bookmarkList[index].isBookMarked,
                      title: AppUtil.rtlDirection2(context)
                          ? _profileController.bookmarkList[index].titleAr
                          : _profileController.bookmarkList[index].titleEn,
                      image: _profileController.bookmarkList[index].image,
                      type: _profileController.bookmarkList[index].type,
                      index: index,
                      id: _profileController.bookmarkList[index].id),
                ),
        ),
      ),
    );
  }
}
