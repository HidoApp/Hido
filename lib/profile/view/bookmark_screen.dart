import 'dart:developer';

import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/widget/floating_timer.dart';
import 'package:ajwad_v4/explore/widget/progress_sheet.dart';
import 'package:ajwad_v4/explore/widget/rating_sheet.dart';
import 'package:ajwad_v4/payment/widget/webview_sheet.dart';
import 'package:ajwad_v4/widgets/bottom_sheet_indicator.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_bookmark_card.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:floating_draggable_advn/floating_draggable_advn_bk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key, this.hasTickets = true});

  final bool hasTickets;

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  List<String> status = ['canceled', 'waiting', 'confirmed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: lightGreyBackground,
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Icon(Icons.add),
      //   onPressed: () {
      //     Get.bottomSheet(
      //         isScrollControlled: true,
      //         WebViewSheet(
      //             height: 700,
      //             url: 'https://docs.myfatoorah.com/docs/test-cards',
      //             title: "title"));
      //   },
      // ),
      appBar: CustomAppBar(
        'bookmark'.tr,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          log('loading');
        },
        child: Container(
          height: height * 0.9,
          width: width,
          padding: const EdgeInsets.only(
            top: 10,
            right: 24,
            left: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.separated(
                    itemBuilder: (builder, index) {
                      return CustomBookmarkCard();
                    },
                    separatorBuilder: (builder, index) {
                      return SizedBox(
                        height: 20,
                      );
                    },
                    itemCount: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
