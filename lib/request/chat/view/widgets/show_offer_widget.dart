import 'package:ajwad_v4/explore/tourist/model/place.dart';
import 'package:ajwad_v4/payment/view/check_out_screen.dart';
import 'package:ajwad_v4/request/tourist/controllers/offer_controller.dart';
import 'package:flutter/material.dart';
import 'package:ajwad_v4/widgets/check_container_widget.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/total_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ShowOfferWidget extends StatelessWidget {
  final OfferController offerController;
  final Place place;
  const ShowOfferWidget({
    super.key,
    required this.offerController,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckContainerWidget(offerController: offerController),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                  10,
                  (index) => Container(
                        width: 20,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.24,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0xFF979797),
                            ),
                          ),
                        ),
                      ))
            ],
          ),
        ),
      //  const AvailableContainerWidget(),
        TotalWidget(
          offerController: offerController,
          place: place,
        ),
        CustomButton(
          title: 'confirm'.tr,
          icon: SvgPicture.asset('assets/icons/circular_forward.svg'),
          onPressed: () {
            Get.to(
              () => CheckOutScreen(
                total: (place.price! *
                        offerController
                            .offerDetails.value.booking!.guestNumber!) +
                    (offerController.totalPrice.value *
                        offerController
                            .offerDetails.value.booking!.guestNumber!),
                offerDetails: offerController.offerDetails.value,
                offerController: offerController,
              ),
            )?.then((value) {

              Get.back();
            

            });
          },
        )
      ],
    );
  }
}
