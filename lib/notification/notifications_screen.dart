import 'dart:developer';

import 'package:ajwad_v4/bottom_bar/ajwadi/view/ajwadi_bottom_bar.dart';
import 'package:ajwad_v4/bottom_bar/tourist/view/tourist_bottom_bar.dart';
import 'package:ajwad_v4/explore/ajwadi/controllers/trip_controller.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/adventure/view/Adventure_summary_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/localEvent/view/event_summary_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/Experience/summary_screen.dart';
import 'package:ajwad_v4/explore/ajwadi/view/local_ticket_screen.dart';
import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/request/ajwadi/view/new_request_screen.dart';
import 'package:ajwad_v4/request/tourist/view/offers_screen.dart';
import 'package:ajwad_v4/request/widgets/PushNotificationCard.dart';
import 'package:ajwad_v4/services/controller/adventure_controller.dart';
import 'package:ajwad_v4/services/controller/event_controller.dart';
import 'package:ajwad_v4/services/controller/hospitality_controller.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:ajwad_v4/widgets/custom_empty_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:get/get.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';

import '../widgets/custom_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key, this.hasNotifications = true})
      : super(key: key);

  bool hasNotifications;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Booking> _upcomingTicket = [];
  List<Booking> _pastTicket = [];

  List<Booking> _upcomingBookings = [];
  List<Booking> _pastBookings = [];
  bool _isPushNotificationDismissed = false;
  List<String> unreadNotificationIds = [];

  String days = '';

  static List<int> canceledIndices = [];
  static List<int> removeIndices = [];
  Set<int> viewedNotifications = Set<int>();
  List<String> notificationMessages = []; // List to hold notification messages
  final _srvicesController = Get.put(NotificationController());

  void disableNotification(int index) {
    setState(() {
      canceledIndices.add(index);

      //disabledIndices.add(index);
    });
  }

  void _viewAllNotifications() {
    setState(() {
      for (int i = 0; i < _upcomingBookings.length; i++) {
        viewedNotifications.add(i);
      }
    });
  }

  void fetchUnreadNotificationIds(BuildContext context) async {
    try {
      await _srvicesController.getNotifications(context: context);

      log("Entered fetchUnreadNotificationIds");
      log("Notifications empty: ${_srvicesController.notifications.isEmpty}");

      // Step 3: Filter notifications to find ones with "isRead" as false
      unreadNotificationIds.clear();
      for (var notification in _srvicesController.notifications) {
        if (notification.isRead == false) {
          unreadNotificationIds.add(notification.id ?? '');
        }
      }

      log("Unread notifications count: ${unreadNotificationIds.length}");

      if (unreadNotificationIds.isNotEmpty) {
        // Step 4: Send the list of unread notification IDs to the other endpoint
        await _srvicesController.updateNotifications(
          context: context,
          unreadNotificationIds: unreadNotificationIds,
        );
      } else {
        log("No unread notifications to update.");
      }
    } catch (error) {
      log("Error fetching notifications: $error");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUnreadNotificationIds(context);
    });
  }

  void _dismissNotification(int index) {
    disableNotification(index);
  }

  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    final arguments = ModalRoute.of(context)?.settings.arguments;

    RemoteMessage? message;

    if (arguments is RemoteMessage) {
      message = arguments;
    } else {
      message = null; // Handle null or invalid argument case
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        'notifications'.tr,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Obx(
                  () => Skeletonizer(
                    enabled: _srvicesController.isNotificationLoading.value,
                    child:
                        // !widget.hasNotifications &&
                        _srvicesController.notifications.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  // top: height / 3,
                                  left: 16,
                                  right: 16,
                                  // bottom: 50,
                                ),
                                child: Center(
                                  child: CustomEmptyWidget(
                                    title: 'noNotification'.tr,
                                    image: 'MybellMessage',
                                    subtitle: "noNotificationsub".tr,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets
                                    .zero, // Remove padding around the ListView

                                shrinkWrap: true,
                                itemCount:
                                    _srvicesController.notifications.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    //  userRole = getStorage.read('userRole') ?? '';

                                    onTap: () async {
                                      if (_srvicesController
                                              .notifications[index]
                                              .notificationType ==
                                          'EVENT_SUMMARY') {
                                        Get.back();
                                        Get.to(() => LocalTicketScreen(
                                              servicesController:
                                                  Get.put(EventController()),
                                              type: 'event',
                                            ));
                                        //Get.back();

                                        // Get.to(EventSummaryScreen(
                                        //   eventId: _srvicesController
                                        //           .notifications[index]
                                        //           .entityId ??
                                        //       '',
                                        //   date: _srvicesController
                                        //           .notifications[index]
                                        //           .data!["data"] ??
                                        //       '',
                                        // ));
                                      } else if (_srvicesController
                                              .notifications[index]
                                              .notificationType ==
                                          'HOSPITALITY_SUMMARY') {
                                        Get.back();
                                        Get.to(() => LocalTicketScreen(
                                              servicesController: Get.put(
                                                  HospitalityController()),
                                              type: 'hospitality',
                                            ));
                                        // Get.back();
                                        // Get.to(SummaryScreen(
                                        //   hospitalityId: _srvicesController
                                        //           .notifications[index]
                                        //           .entityId ??
                                        //       '',
                                        //   date: _srvicesController
                                        //           .notifications[index]
                                        //           .data!["date"] ??
                                        //       '',
                                        // ));
                                      } else if (_srvicesController
                                              .notifications[index]
                                              .notificationType ==
                                          'ADVENTURE_SUMMARY') {
                                        Get.back();
                                        Get.to(
                                          () => LocalTicketScreen(
                                            servicesController:
                                                Get.put(AdventureController()),
                                            type: 'adventure',
                                          ),
                                        );
                                        // Get.back();
                                        // Get.to(AdventureSummaryScreen(
                                        //   adventureId: _srvicesController
                                        //           .notifications[index]
                                        //           .entityId ??
                                        //       '',
                                        // ));
                                      } else if (_srvicesController
                                              .notifications[index]
                                              .notificationType ==
                                          'TOUR_PROGRESS') {
                                        Get.offAll(
                                            () => const TouristBottomBar());
                                      } else if (_srvicesController
                                              .notifications[index]
                                              .notificationType ==
                                          'NEW_REQUEST') {
                                        // Get.to(() => const AjwadiBottomBar(
                                        //     initialIndex: 1));
                                      } else if (_srvicesController
                                              .notifications[index]
                                              .notificationType ==
                                          'NEW_OFFER') {
                                        Get.back();

                                        final RequestController
                                            _RequestController =
                                            Get.put(RequestController());

                                        Booking? theBooking;

                                        theBooking = await _RequestController
                                            .getBookingById(
                                          context: context,
                                          bookingId: _srvicesController
                                                  .notifications[index]
                                                  .entityId ??
                                              '',
                                        ).then((value) {
                                          if (theBooking != null) {
                                            Get.to(() => OfferScreen(
                                                  booking: theBooking!,
                                                ));
                                          }
                                        });
                                      } else if (_srvicesController
                                              .notifications[index]
                                              .notificationType ==
                                          'REQUEST_ACCEPTED') {
                                        log('hkiy');
                                        Get.back();
                                        Get.to(
                                          () => LocalTicketScreen(
                                            servicesController:
                                                Get.put(TripController()),
                                            type: 'tour',
                                          ),
                                        );
                                      }
                                    },
                                    child: PushNotificationCrd(
                                      isRead: _srvicesController
                                              .notifications[index].isRead ??
                                          false,
                                      message: AppUtil.rtlDirection2(context)
                                          ? (_srvicesController
                                                  .notifications[index]
                                                  .data?["body"] ??
                                              _srvicesController
                                                  .notifications[index]
                                                  .data?["title"] ??
                                              '')
                                          : (_srvicesController
                                                  .notifications[index].body ??
                                              _srvicesController
                                                  .notifications[index].title ??
                                              ''),
                                      isRtl: AppUtil.rtlDirection2(context),
                                      width: width,
                                    ),
                                  );
                                }),
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
