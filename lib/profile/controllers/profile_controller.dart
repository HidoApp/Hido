import 'dart:io';

import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/profile/services/profile_service.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isProfileLoading = false.obs;
  var isImagesLoading = false.obs;
  var isEditProfileLoading = false.obs;
  var isPastTicketLoading = false.obs;
  var isUpcommingTicketLoading = false.obs;
  var isChatLoading = false.obs;
  var isMobileOtpLoading = false.obs;
  var upcommingTicket = <Booking>[].obs;
  var pastTicket = <Booking>[].obs;
  var chatList = <ChatModel>[].obs;

  var profile = Profile();
  var isEmailOtp = false.obs;
  var isEditing = false.obs;
  var isEmailNotValid = false.obs;
  var isNumberNotValid = false.obs;
  var isOTPMode = false.obs;
  Future<Profile?> getProfile(
      {required BuildContext context, String profileId = ""}) async {
    try {
      isProfileLoading(true);
      print('YES');
      profile = (await ProfileService.getProfile(
          context: context, profileId: profileId))!;
      //! cache
      print('YES');

      return profile;
    } catch (e) {
      return null;
    } finally {
      isProfileLoading(false);
    }
  }

  Future<UploadImage?> uploadProfileImages(
      {required File file,
      required String uploadOrUpdate,
      required BuildContext context}) async {
    try {
      isImagesLoading(true);
      final isSucces = await ProfileService.uploadProfileImages(
          file: file, uploadOrUpdate: uploadOrUpdate, context: context);

      return isSucces;
    } catch (e) {
      print('error');
      print(e);
      return null;
    } finally {
      isImagesLoading(false);
    }
  }

  Future<Profile?> editProfile({
    String? name,
    String? profileImage,
    String? descripttion,
    String? iban,
    List<String>? spokenLanguage,
    required BuildContext context,
  }) async {
    try {
      isEditProfileLoading(true);

      final profile = await ProfileService.editProfile(
        name: name,
        profileImage: profileImage,
        descripttion: descripttion,
        iban: iban,
        spokenLanguage: spokenLanguage,
        context: context,
      );
      if (profile != null) {
        return profile;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    } finally {
      isEditProfileLoading(false);
    }
  }

  Future<List<Booking>?> getUpcommingTicket({
    required BuildContext context,
  }) async {
    try {
      isUpcommingTicketLoading(true);

      final data = await ProfileService.getUserTicket(
        bookingType: 'UPCOMING',
        context: context,
      );
      if (data != null) {
        upcommingTicket(data);
        // print("object");
        // print(data.length);
        // print(upcommingTicket.first.place?.nameAr);
        return upcommingTicket;
      } else {
        return null;
      }
    } catch (e) {
      isUpcommingTicketLoading(false);
      print(e);
      return null;
    } finally {
      isUpcommingTicketLoading(false);
    }
  }

  Future<List<Booking>?> getUpcommingTicket2({
    required BuildContext context,
  }) async {
    try {
      isUpcommingTicketLoading(true);

      final data = await ProfileService.getUserTicket(
        bookingType: 'UPCOMING',
        context: context,
      );
      if (data != null) {
        upcommingTicket(data);

        return upcommingTicket.value; // Return the value of upcommingTicket
      } else {
        return null;
      }
    } catch (e) {
      isUpcommingTicketLoading(false);
      print(e);
      return null;
    } finally {
      isUpcommingTicketLoading(false);
    }
  }

  Future<List<Booking>?> getPastTicket({
    required BuildContext context,
  }) async {
    try {
      isPastTicketLoading(true);

      final data = await ProfileService.getUserTicket(
        bookingType: 'PAST',
        context: context,
      );
      print("this pas 1ticket");

      if (data != null) {
        print("this pas ticket");
        pastTicket(data);
        return pastTicket;
      } else {
        return null;
      }
    } catch (e) {
      isPastTicketLoading(false);
      print(e);
      return null;
    } finally {
      isPastTicketLoading(false);
    }
  }

  Future<List<ChatModel>?> getUserChats({
    required BuildContext context,
  }) async {
    try {
      isChatLoading(true);

      final data = await ProfileService.getUserChats(
        context: context,
      );
      if (data != null) {
        chatList(data);
        print('chat ist');
        print(chatList.first.messages?.first.message);
        return chatList;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      isChatLoading(false);
      print(e);
      return null;
    } finally {
      isChatLoading(false);
    }
  }

  Future<bool> otpForMobile({
    required BuildContext context,
    required String mobile,
  }) async {
    try {
      isMobileOtpLoading(true);
      final isSccues =
          await ProfileService.otpForMobile(context: context, mobile: mobile);
      return isSccues;
    } catch (e) {
      isMobileOtpLoading(false);
      return false;
    } finally {
      isMobileOtpLoading(false);
    }
  }
}
