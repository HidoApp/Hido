import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/view/custom_ajwadi_card.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/request/tourist/view/show_ajwadi_info_sheet.dart';
import 'package:ajwad_v4/request/widgets/CansleDialog.dart';
import 'package:ajwad_v4/request/widgets/timer_app_bar.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({
    super.key,
    required this.place,
    required this.booking,
  });
  final Place place;
  final Booking booking;

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final _offerController = Get.put(OfferController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("offer");
    print(_offerController.offers.length);

    return Scaffold(
        appBar: TimerAppBar(
          'offers'.tr,
          action: true,
          onPressedAction: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CancelBookingDialog(
                  // dialogWidth: MediaQuery.of(context).size.width * 0.588,
                  // buttonWidth: MediaQuery.of(context).size.width * 0.191,
                  dialogWidth: 256,
                  buttonWidth: 268,
                  booking: widget.booking,
                  offerController: _offerController,
                );
              },
            );
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppUtil.rtlDirection2(context)
                  ? const EdgeInsets.only(top: 25, right: 28)
                  : const EdgeInsets.only(top: 25, left: 28),
              child: CustomText(
                text: "selectLocal".tr,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              //  physics:const NeverScrollableScrollPhysics(),
              itemCount: _offerController.offers.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 7,
                );
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _offerController.getOfferById(
                      context: context,
                      offerId: _offerController.offers[index].offerId!,
                    );
                    print('image');
                    print(_offerController.offers[index].image ?? '');
                    // name: _offerController.offers[index].name!??'',
                    // rating: _offerController.offers[index].rating!??0,
                    // price: _offerController.offers[index].price!??0,
                    // tripNumber: _offerController.offers[index].tourNumber??0,
                    Get.to(() => LocalOfferInfo(
                        place: widget.place,
                        image: _offerController.offers[index].image ?? '',
                        name: _offerController.offers[index].name!,
                        profileId: _offerController.offers[index].profileId!,
                        rating: _offerController.offers[index].tourRating ?? 0,
                        price: _offerController.offers[index].price!,
                        tripNumber:
                            _offerController.offers[index].tourNumber ?? 0));
                  },
                  child: CustomAjwadiCard(
                    image: _offerController.offers[index].image ?? '',
                    name: _offerController.offers[index].name ?? '',
                    rating: _offerController.offers[index].tourRating ?? 0,
                    price: _offerController.offers[index].price ?? 0,
                    tripNumber: _offerController.offers[index].tourNumber ?? 0,
                  ),
                );
              },
            ),
          ],
        ));
  }
}
