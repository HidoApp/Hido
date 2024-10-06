import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/view/custom_ajwadi_card.dart';
import 'package:ajwad_v4/request/tourist/view/show_ajwadi_info_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/offer_controller.dart';

class SelectAjwadySheet extends StatefulWidget {
  const SelectAjwadySheet({
    Key? key,
    // required this.booking,
    required this.place,
  }) : super(key: key);

  // final Booking booking;
  final Place place;

  @override
  State<SelectAjwadySheet> createState() => _SelectAjwadySheet();
}

class _SelectAjwadySheet extends State<SelectAjwadySheet> {
  final _offerController = Get.put(OfferController());
  late double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onDoubleTap: (() {
        Get.back();
      }),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: height * 0.55,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: ListView(
              //  physics: ,
              children: [
                const Icon(
                  Icons.keyboard_arrow_up,
                  size: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: !AppUtil.rtlDirection(context)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: CustomText(
                    text: "findLocal".tr,
                    textAlign: TextAlign.start,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
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
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            )),
                            context: context,
                            builder: (context) {
                              return Obx(() {
                                if (_offerController.isOfferLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }
                                return ShowAjwadiInfoSheet(
                                    // booking: widget.booking,
                                    place: widget.place,
                                    image:
                                        _offerController.offers[index].image ??
                                            '',
                                    name: _offerController.offers[index].name!,
                                    rating:
                                        _offerController.offers[index].tourRating!,
                                    price:
                                        _offerController.offers[index].price!,
                                    tripNumber: _offerController
                                        .offers[index].tourNumber!);
                              });
                            });
                      },
                      child: CustomAjwadiCard(
                        image: _offerController.offers[index].image ?? '',
                        name: _offerController.offers[index].name!,
                        rating: _offerController.offers[index].tourRating!,
                        price: _offerController.offers[index].price!,
                        tripNumber: _offerController.offers[index].tourNumber!,
                      ),
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
