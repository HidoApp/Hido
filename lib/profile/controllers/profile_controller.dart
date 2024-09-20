import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/explore/tourist/model/activity_progress.dart';
import 'package:ajwad_v4/explore/tourist/model/booking.dart';
import 'package:ajwad_v4/profile/models/bookmark.dart';
import 'package:ajwad_v4/profile/models/profile.dart';
import 'package:ajwad_v4/profile/services/profile_service.dart';
import 'package:ajwad_v4/request/chat/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ProfileController extends GetxController {
  var isProfileLoading = false.obs;
  var isImagesLoading = false.obs;
  var isEditProfileLoading = false.obs;
  var isPastTicketLoading = false.obs;
  var isUpcommingTicketLoading = false.obs;
  var isChatLoading = false.obs;
  var isMobileOtpLoading = false.obs;
  var isUpdatingMobileLoading = false.obs;
  var isActionsListLoading = false.obs;
  var isUpdatingActionLoading = false.obs;
  var isUserOpenTheApp = false.obs;
  var isUserSendFeedBack = false.obs;
  var upcommingTicket = <Booking>[].obs;
  var pastTicket = <Booking>[].obs;
  var chatList = <ChatModel>[].obs;
  var actionsList = <ActivityProgress>[].obs;
  var profile = Profile();
  var isEmailOtp = false.obs;
  var isEditing = false.obs;
  var isEmailNotValid = false.obs;
  var isNumberNotValid = false.obs;
  var isOTPMode = false.obs;
  var enableSignOut = true.obs;
  //bokmark
  var isbookMarked = true.obs;
  var isAdventureBookmarked = false.obs;
  var isEventBookmarked = false.obs;
  var isHospitaltyBookmarked = false.obs;
  var isTourBookmarked = false.obs;
  var bookmarkList = <Bookmark>[].obs;

  //update var
  var updatedMobile = '';
  var pdfName = ''.obs;
  var isPdfValidSize = true.obs;
  var isPdfValidNotEmpty = true.obs;

  var localBar = 0.obs;
  var touriestBar = 0.obs;

  var isInternetConnected = true.obs;

  //------
  Future<Profile?> getProfile(
      {required BuildContext context, String profileId = ""}) async {
    try {
      isProfileLoading(true);

      profile = (await ProfileService.getProfile(
          context: context, profileId: profileId))!;
      //! cache

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
    String? nationality,
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
        nationality: nationality,
        spokenLanguage: spokenLanguage,
        context: context,
      );
      if (profile != null) {
        return profile;
      } else {
        return null;
      }
    } catch (e) {
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
      log('upComing controller');
      final data = await ProfileService.getUserTicket(
        bookingType: 'UPCOMING',
        context: context,
      );
      if (data != null) {
        upcommingTicket(data);
        //
        //
        //
        return upcommingTicket;
      } else {
        return null;
      }
    } catch (e) {
      isUpcommingTicketLoading(false);

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

      if (data != null) {
        pastTicket(data);
        return pastTicket;
      } else {
        return null;
      }
    } catch (e) {
      isPastTicketLoading(false);

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

        return chatList;
      } else {
        return null;
      }
    } catch (e) {
      isChatLoading(false);

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

  Future<Profile?> updateMobile({
    required BuildContext context,
    required String otp,
    required String mobile,
  }) async {
    try {
      isUpdatingMobileLoading(true);
      final data = await ProfileService.updateMobile(
          context: context, otp: otp, mobile: mobile);
      return data;
    } catch (e) {
      isUpdatingMobileLoading(false);
      log(e.toString());
      return null;
    } finally {
      isUpdatingMobileLoading(false);
    }
  }

  Future<List<ActivityProgress>?> getAllActions(
      {required BuildContext context}) async {
    try {
      log('Here Actions');
      isActionsListLoading(true);
      final data = await ProfileService.getAllActions(context: context);
      if (data != null) {
        actionsList(data);
      }
      return actionsList;
    } catch (e) {
      isActionsListLoading(false);
      return null;
    } finally {
      isActionsListLoading(false);
    }
  }

  Future<bool> updateUserAction(
      {required BuildContext context, required String id}) async {
    try {
      isUpdatingActionLoading(true);
      final isSucces =
          await ProfileService.updateUserAction(context: context, id: id);
      return isSucces;
    } catch (e) {
      isUpdatingActionLoading(false);
      return false;
    } finally {
      isUpdatingActionLoading(false);
    }
  }

  Future<void> sendUserFeedBack({required String description}) async {
    log("HEre1");
    try {
      isUserSendFeedBack(true);
      SentryId sentryId = await Sentry.captureMessage("My message");
      log(sentryId.toString());
      final userFeedback = SentryUserFeedback(
        eventId: sentryId,
        comments: description,
        email: profile.email!.isEmpty ? "unknown@hido.app" : profile.email,
        name: profile.name!.isEmpty ? "unknown" : profile.name,
      );

      await Sentry.captureUserFeedback(userFeedback);
      log("HEre2");
    } catch (e) {
      isUserSendFeedBack(false);
    } finally {
      isUserSendFeedBack(false);
    }
  }
}
