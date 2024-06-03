
import 'package:ajwad_v4/constants/colors.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/payment/model/invoice.dart';
import 'package:ajwad_v4/profile/view/ticket_details_screen.dart';
import 'package:ajwad_v4/request/local_notification.dart';
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
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

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
  int finalCost = 0;
//   final String timeZoneName = 'Asia/Riyadh';
//   late tz.Location location;

  
//   bool isDateBeforeToday() {
//     DateTime adventureDate =
//         DateFormat('yyyy-MM-dd').parse(widget.adventure.date!);
// tz.initializeTimeZones();
//     location = tz.getLocation(timeZoneName);

//     DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
//     return adventureDate.isBefore(currentDateInRiyadh);
//   }

//   bool isSameDay() {
//     tz.initializeTimeZones();
//     location = tz.getLocation(timeZoneName);

//     DateTime currentDateInRiyadh = tz.TZDateTime.now(location);
//     DateTime adventureDate =
//     DateFormat('yyyy-MM-dd').parse(widget.adventure.date!);

//      DateTime Date =
//     DateFormat('HH:mm').parse(widget.adventure.times!.last.startTime!);

    


//     DateTime AdventureStartDate = DateTime(adventureDate.year, adventureDate.month,adventureDate.day,Date.hour, Date.minute,Date.second);


//     DateTime bookingDeadline = AdventureStartDate.subtract(Duration(hours: 24));


//     print (AdventureStartDate);
//     print(currentDateInRiyadh);
//     print(bookingDeadline);

//     return bookingDeadline.isBefore(currentDateInRiyadh);
//   }


 void initState() {
    // TODO: implement initState
    super.initState();
    finalCost = widget.adventure.price * widget.person;
    
  }  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(widget.adventure.times?.last.startTime);

    return Scaffold(
      appBar: CustomAppBar(
        "Review Booking",
        action: true,
        onPressedAction: () {},
      ),
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
              
                 ReviewDetailsTile(
                  title: widget.adventure.times != null && widget.adventure.times!.isNotEmpty
                    ?widget.adventure.times!.map((time) => AppUtil.formatStringTimeWithLocale(context, time.startTime) ).join(', ')
                         : '5:00-8:00 AM',
                        image: "assets/icons/timeGrey.svg"),
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
                     // text: 'SAR ${widget.adventure.price.toString()}',
                       text: 'SAR ${finalCost.toString()}',

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
                                InvoiceValue: widget.adventure.price * widget.person);
                            if (invoice != null)
                            {
                              
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaymentWebView(
                                              url: invoice!.url!,
                                              title: 'Payment')))
                                  .then((value) async {
                                setState(() {
                                  isCheckingForPayment = true;
                               
                                });
                                final checkInvoice =
                                    await paymentController.paymentInvoiceById(
                                        context: context, id: invoice!.id);

                                     print("this state");
                                  print(checkInvoice!.invoiceStatus);

                                if (checkInvoice.invoiceStatus == 'Pending') {
                                  // await _adventureController
                                  //     .checkAdventureBooking(
                                  //         adventureID: widget.adventure.id,
                                  //         context: context,
                                  //         personNumber: widget.person,
                                  //         invoiceId: invoice!.id);
                                  setState(() {
                                    isCheckingForPayment = false;
                                  });
                                  print('No');
                                  // if (checkInvoice.invoiceStatus == 'failed' ||
                                  //     checkInvoice.invoiceStatus ==
                                  //         'initiated') {
                                   // Get.back();
                                 await navigateToPayment(context, invoice!.url!);

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
                                                CustomText(
                                                    text: "paymentFaild"),
                                              ],
                                            ),
                                          );
                                        });
                                  
                                  } else {
                                    print('YES');
                                    print(invoice?.invoiceStatus);

                                    //Get.back();
                                   // Get.back();
                                await _adventureController.checkAdventureBooking(
                                  adventureID: widget.adventure.id,
                                  context: context,
                                  personNumber: widget.person,
                                  invoiceId: invoice!.id);

                                   final updatedAdventure = await _adventureController.getAdvdentureById(
                                      context: context,
                                   id: widget.adventure.id);

                                   print('check');
                                  print(updatedAdventure);

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
                                              CustomText(
                                                  text: "paymentSuccess"),
                                            ],
                                          ),
                                        );
                                      },
                                    ).then((_) {
                                      print("inside notifi");
                                    LocalNotification().showAdventureNotification(context,updatedAdventure!.booking?.last.id,  updatedAdventure.date,updatedAdventure.nameEn,updatedAdventure.nameAr);
                                     Get.to(() =>  TicketDetailsScreen(
                                                             adventure:updatedAdventure,
                                                             icon: SvgPicture.asset(
                                                            'assets/icons/adventure.svg'),
                                                             bookTypeText:'adventure',
                                               
                                           ));
                                         });
                                  }
                              });
                            } else {
                         print('Inovice null');
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
Future<void> navigateToPayment(BuildContext context, String url) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentWebView(
        url: url,
        title: 'Payment',
      ),
    ),
  );
}