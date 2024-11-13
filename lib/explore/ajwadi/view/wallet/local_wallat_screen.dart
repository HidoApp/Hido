import 'package:ajwad_v4/auth/controllers/auth_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/trip_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/view/hoapatility/widget/wallet_details_card.dart';
import 'package:ajwad_v4/payment/controller/payment_controller.dart';
import 'package:ajwad_v4/profile/controllers/profile_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:ajwad_v4/widgets/custom_card%20_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalWalletScreen extends StatefulWidget {
  const LocalWalletScreen({super.key});

  @override
  State<LocalWalletScreen> createState() => _LocalWalletScreenState();
}

class _LocalWalletScreenState extends State<LocalWalletScreen> {
  final _getStorage = GetStorage();
  final _authController = Get.put(AuthController());

  final _profileController = Get.put(ProfileController());
  final _tripController = Get.put(TripController());
  final _paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        'wallet'.tr,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24, top: 10),
                  child: CustomCard(),
                ),
              ),
              const SizedBox(height: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      AppUtil.rtlDirection2(context)
                          ? "المعاملات المالية"
                          : 'Financial transactions',
                      style: const TextStyle(
                        color: Color(0xFF070708),
                        fontSize: 17,
                        fontFamily: 'HT Rakik',
                        fontWeight: FontWeight.w500,
                        height: 0.10,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_paymentController.wallet.value.transactions!.isNotEmpty)
                    SingleChildScrollView(
                      child: Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          itemCount: _paymentController
                              .wallet.value.transactions!.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 11,
                            );
                          },
                          itemBuilder: (context, index) {
                            final transaction = _paymentController
                                .wallet.value.transactions![index];

                            if (transaction.details!.placeId!.isNotEmpty) {
                              return WalletDetailsCard(
                                  transaction: transaction,
                                  icon: 'tour_category',
                                  date: 'tour',
                                  color: const Color(0xFFECF9F1));
                            }
                            if (transaction.details!.adventureId!.isNotEmpty) {
                              return WalletDetailsCard(
                                transaction: transaction,
                                icon: 'adventure_category',
                                date: 'adve',
                                color: const Color(0xFFF9F4EC),
                              );
                            }
                            if (transaction
                                .details!.hospitalityId!.isNotEmpty) {
                              return WalletDetailsCard(
                                transaction: transaction,
                                icon: 'host_category',
                                date: 'host',
                                color: const Color(0xFFF5F2F8),
                              );
                            }
                            if (transaction.details!.eventId!.isNotEmpty) {
                              return WalletDetailsCard(
                                transaction: transaction,
                                icon: 'event_category',
                                color: const Color(0xFFFEFDF1),
                                date: 'event',
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
