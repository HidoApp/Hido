import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/explore/tourist/controller/tourist_explore_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:ajwad_v4/widgets/trip_booking_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    super.key,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  List<String> status = ['canceled', 'waiting', 'confirmed'];

  TouristExploreController _touristExploreController =
      Get.put(TouristExploreController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _touristExploreController.getTouristBooking(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar('tourHistory'.tr),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.only(
            top: 20,
            right: 24,
            left: 24,
          ),
          child: _touristExploreController.isBookingLoading.value
              ? const Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        color: colorGreen,
                      )))
              : _touristExploreController.bookingList.isEmpty
                  ?
                  // !widget.hasTickets
                  Center(
                    child: CustomEmptyWidget(
                        title: 'noTour'.tr,
                        image: 'no_tickets',
                      ),
                  )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _touristExploreController.bookingList.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 11,
                          color: tileGreyColor,
                        );
                      },
                      itemBuilder: (context, index) {
                        print(    _touristExploreController.bookingList[index].place!.price);
                        return TripBookingWidget(
                            booking:
                                _touristExploreController.bookingList[index],bookingId:    _touristExploreController.bookingList[index].id!,touristExploreController: _touristExploreController,);
                      },
                    ),
        ),
      ),
    );
  }
}
