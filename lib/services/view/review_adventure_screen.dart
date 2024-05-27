import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/model/adventure.dart';
import 'package:ajwad_v4/services/view/widgets/review_details_tile.dart';
import 'package:ajwad_v4/services/view/widgets/review_guests.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_button.dart';
import 'package:ajwad_v4/widgets/custom_text.dart';
import 'package:ajwad_v4/widgets/dotted_line_separator.dart';
import 'package:ajwad_v4/widgets/payment_web_view.dart';
import 'package:ajwad_v4/widgets/promocode_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReviewAdventure extends StatefulWidget {
  const ReviewAdventure({
    super.key,
    required this.person,
    required this.adventure,
  });
  final int person;
  final Adventure adventure;

  @override
  State<ReviewAdventure> createState() => _ReviewAdventureState();
}

class _ReviewAdventureState extends State<ReviewAdventure> {
  final _adventureController = Get.put(AdventureController());
  final paymentController = Get.put(PaymentController());
  Invoice? invoice;
  bool isCheckingForPayment = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar("Review Booking"),
      extendBodyBehindAppBar: false,
      body: Container(
        padding: EdgeInsets.all(width * 0.041),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Adventure Details",
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 4,
                ),
                ReviewDetailsTile(
                    title: AppUtil.rtlDirection2(context)
                        ? widget.adventure.regionAr!
                        : widget.adventure.regionEn!,
                    image: "assets/icons/locationHos.svg"),
                const SizedBox(
                  height: 4,
                ),
                // Details
                ReviewDetailsTile(
                    title: DateFormat('E-dd-MMM').format(
                      DateTime.parse(widget.adventure!.date!),
                    ),
                    image: 'assets/icons/grey_calender.svg'),
                const SizedBox(
                  height: 4,
                ),
                const ReviewDetailsTile(
                    title: "5:00-8:00 AM ", image: "assets/icons/timeGrey.svg"),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: almostGrey,
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomText(
                  text: "Number of People",
                  fontSize: 18,
                ),
                ReviewGuestsTile(
                  guest: widget.person,
                  title: "person",
                ),
                SizedBox(
                  height: width * .041,
                ),
                const Divider(
                  color: almostGrey,
                ),
                SizedBox(
                  height: width * 0.5,
                ),

                ///discount widget
                const PromocodeField(),
                SizedBox(
                  height: width * 0.051,
                ),

                DottedSeparator(
                  color: almostGrey,
                  height: width * 0.002,
                ),
                SizedBox(
                  height: width * 0.07,
                ),
                Row(
                  children: [
                    CustomText(
                      text: 'Total',
                      fontSize: 20,
                    ),
                    Spacer(),
                    CustomText(
                      text: 'SAR ${widget.adventure.price.toString()}',
                      fontSize: 20,
                    )
                  ],
                ),
                SizedBox(
                  height: width * 0.051,
                ),
                Obx(() => _adventureController.ischeckBookingLoading.value ||
                        paymentController.isPaymenInvoiceLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: () async {
                          print("invoice != null");
                          print(invoice != null);

                          invoice ??= await paymentController.paymentInvoice(
                              context: context,
                              description: 'DESCRIPTION ADVENTURE',
                              amount: widget.adventure.price * widget.person);
                          if (invoice != null) {
                            await _adventureController.checkAdventureBooking(
                                adventureID: widget.adventure.id,
                                context: context,
                                personNumber: widget.person,
                                invoiceId: invoice!.id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentWebView(
                                        url: invoice!.url!,
                                        title: 'Payment'))).then((value) async {
                              setState(() {
                                isCheckingForPayment = true;
                              });

                              final checkInvoice =
                                  await paymentController.paymentInvoiceById(
                                      context: context, id: invoice!.id);

                              if (checkInvoice!.invoiceStatus != 'faild') {
                                await _adventureController
                                    .checkAdventureBooking(
                                        adventureID: widget.adventure.id,
                                        context: context,
                                        personNumber: widget.person,
                                        invoiceId: invoice!.id);
                                setState(() {
                                  isCheckingForPayment = false;
                                });

                                if (checkInvoice.invoiceStatus == 'failed' ||
                                    checkInvoice.invoiceStatus == 'initiated') {
                                  Get.back();

                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                  'assets/images/paymentFaild.gif'),
                                              CustomText(text: "paymentFaild"),
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  print('YES');
                                  Get.back();
                                  Get.back();

                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        surfaceTintColor: Colors.white,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                                'assets/images/paymentSuccess.gif'),
                                            CustomText(text: "paymentSuccess"),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else {}
                            });
                          }
                        },
                        title: 'Checkout'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
