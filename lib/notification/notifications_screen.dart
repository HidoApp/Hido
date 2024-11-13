import 'package:ajwad_v4/notification/controller/notification_controller.dart';
import 'package:ajwad_v4/request/widgets/PushNotificationCard.dart';
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
    _srvicesController.getNotifications(context: context);

    // Step 3: Filter notifications to find ones with "isRead" as false
    for (var notification in _srvicesController.notifications) {
      if (notification.isRead == false) {
        unreadNotificationIds.add(notification.notificationId ??
            ''); // Assuming `id` is the notification ID field
      }
    }

    // Step 4: Send the list of unread notification IDs to the other endpoint
    await _srvicesController.updateNotifications(
        context: context, unreadNotificationIds: unreadNotificationIds);
  }

  @override
  void initState() {
    super.initState();
    fetchUnreadNotificationIds(context);
  }

  void _dismissNotification(int index) {
    disableNotification(index);
  }

  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
                                padding: EdgeInsets.only(
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
                                shrinkWrap: true,
                                itemCount:
                                    _srvicesController.notifications.length,
                                itemBuilder: (context, index) {
                                  return PushNotificationCrd(
                                    isRead: _srvicesController
                                            .notifications[index].isRead ??
                                        false,
                                    message: AppUtil.rtlDirection2(context)
                                        ? _srvicesController
                                                .notifications[index]
                                                .data!["body"] ??
                                            ''
                                        : _srvicesController
                                                .notifications[index].body ??
                                            '',
                                    isRtl: AppUtil.rtlDirection2(context),
                                    width: width,
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
