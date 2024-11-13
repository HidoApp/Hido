import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/experience_type.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/widget/custom_experience_item.dart';
import 'package:ajwad_v4/reviews/review_card.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TouristReviewsScreen extends StatefulWidget {
  const TouristReviewsScreen({super.key});

  @override
  State<TouristReviewsScreen> createState() => _TouristReviewsScreenState();
}

class _TouristReviewsScreenState extends State<TouristReviewsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: lightGreyBackground,
      appBar: CustomAppBar(
        'reviews'.tr,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.041,
                    left: width * 0.041,
                  ),
                  child:
                      // ?
                      // SizedBox(
                      //     //new
                      //     width: width,
                      //     child: CustomEmptyWidget(
                      //       title: 'noReview'.tr,
                      //       image: 'noReview',
                      //       subtitle: 'noReviewSub'.tr,
                      //     ))
                      //:
                      ListView.separated(
                    shrinkWrap: true,
                    itemCount: 12,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 11,
                      );
                    },
                    itemBuilder: (context, index) {
                      return const ReviewCard(
                        name: 'John Doe',
                        rating: 4,
                        description: 'Great product! Really enjoyed using it.',
                        image: 'https://example.com/image.jpg',
                        created: '2024-11-11',
                        status: 'approved',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
