import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:ajwad_v4/request/tourist/view/custom_ajwadi_card.dart';
import 'package:ajwad_v4/request/tourist/view/local_offer_info.dart';
import 'package:ajwad_v4/request/tourist/view/show_ajwadi_info_sheet.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key, required this.place});
  final Place place;

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final _offerController = Get.put(OfferController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: CustomAppBar(
          'offers'.tr,
          action: true,
          onPressedAction: () {},
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
                    Get.to(() => LocalOfferInfo(
                        place: widget.place,
                        image: _offerController.offers[index].image ?? '',
                        name: _offerController.offers[index].name!,
                        profileId: _offerController.offers[index].profileId!,
                        rating: _offerController.offers[index].rating!,
                        price: _offerController.offers[index].price!,
                        tripNumber:
                            _offerController.offers[index].tripNumber!));
                  },
                  child: CustomAjwadiCard(
                    image: _offerController.offers[index].image ?? '',
                    name: _offerController.offers[index].name!,
                    rating: _offerController.offers[index].rating!,
                    price: _offerController.offers[index].price!,
                    tripNumber: _offerController.offers[index].tripNumber!,
                  ),
                );
              },
            ),
          ],
        ));
  }
}