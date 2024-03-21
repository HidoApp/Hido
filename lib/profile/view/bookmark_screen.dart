import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_bookmark_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      backgroundColor: Colors.white,
      appBar: CustomAppBar('bookmark'.tr),
      body: Container(
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
            )
          ],
        ),
      ),
    );
  }
}
