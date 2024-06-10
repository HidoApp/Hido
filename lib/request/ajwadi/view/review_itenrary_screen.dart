import 'package:ajwad_v4/request/ajwadi/controllers/request_controller.dart';
import 'package:ajwad_v4/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewIenraryScreen extends StatefulWidget {
  const ReviewIenraryScreen(
      {super.key, required this.requestController, required this.requestId});
  final RequestController requestController;
  final String requestId;
  @override
  State<ReviewIenraryScreen> createState() => _ReviewIenraryScreenState();
}

class _ReviewIenraryScreenState extends State<ReviewIenraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('reviewOffer'.tr,),
    );
  }
}
