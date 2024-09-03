import 'dart:developer';
import 'package:ajwad_v4/auth/view/sigin_in/phone_otp_new.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/profile/models/bookmark.dart';
import 'package:ajwad_v4/profile/services/bookmark_services.dart';
import 'package:ajwad_v4/profile/widget/bookmark_card.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_bookmark_card.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      //  backgroundColor: lightGreyBackground,
      backgroundColor: lightGreen,
      appBar: CustomAppBar(
        'bookmark'.tr,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: width * 0.041,
          right: width * 0.041,
          top: width * 0.030,
        ),
        child: Obx(
          () => _profileController.bookmarkList.isEmpty
              ? Center(
                  child: CustomEmptyWidget(title: 'No book marks'),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 18,
                  ),
                  itemCount: _profileController.bookmarkList.length,
                  itemBuilder: (context, index) => BookmarkCard(
                    title: _profileController.bookmarkList[index].titleEn,
                    image: _profileController.bookmarkList[index].image,
                    type: _profileController.bookmarkList[index].type,
                    index: index,
                  ),
                ),
        ),
      ),
    );
  }
}
