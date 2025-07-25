import 'dart:developer';
import 'dart:io';

import 'package:ajwad_v4/amplitude_service.dart';
import 'package:ajwad_v4/auth/models/ajwadi_info.dart';
import 'package:ajwad_v4/auth/models/app_version.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/provided_services.dart';
import 'package:ajwad_v4/auth/view/ajwadi_register/tour_stepper.dart';
import 'package:ajwad_v4/bottom_bar/local/view/local_bottom_bar.dart';
import 'package:ajwad_v4/request/widgets/app_version_dialog.dart';
import 'package:ajwad_v4/share/services/dynamic_link_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthController extends GetxController {
  var isRegisterLoading = false.obs;
  var isLoginLoading = false.obs;
  var isOTPLoading = false.obs;
  var isResetPasswordLoading = false.obs;
  var isNatSelected = false.obs;
  var isCountryLoading = false.obs;
  var isPersonInfoLoading = false.obs;
  var isLienceseOTPLoading = false.obs;
  var isVicheleOTPLoading = false.obs;
  var isLienceseLoading = false.obs;
  var isVicheleLoading = false.obs;
  var isSigininwithRowad = false.obs;
  var countries = <String>[].obs;
  var isEmailUpadting = false.obs;
  var nationalId = ''.obs;
  var birthDate = ''.obs;
  var birthDateDay = ''.obs;
  var agreeForTerms = false.obs;
  var isAgreeForTerms = true.obs;
  var tourSelected = false.obs;
  var experiencesSelected = false.obs;
  var isSendVehicleDetails = false.obs;
  var isSignUpRowad = false.obs;
  var isCreateAccountLoading = false.obs;
  var isCreateOtpLoading = false.obs;
  var isSignInWithOtpLoading = false.obs;
  var isCheckLocalLoading = false.obs;
  var isResendOtp = true.obs;
  var isResetPasswordOtpLoading = false.obs;
  var isGetAppVersionLoading = false.obs;
  // var isNotCompleteLocalInfo = false.obs;
  //valditon vars
  var hidePassword = true.obs;
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  // sign in & sign up fields
  var activeBar = 1.obs;
  final contactKey = GlobalKey<FormState>();
  final vehicleKey = GlobalKey<FormState>();
  var localID = ''.obs;
  // var drivingDate = ''.obs;
  // var drivingDateDay = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var iban = ''.obs;
  var vehicleLicense = ''.obs;
  var validBirthDay = true.obs;
  var validDriving = true.obs;
  //edit license
  var updatedDriving = ''.obs;
  var updatedDrivingWithoutHijri = ''.obs;
  var updatedVehicle = ''.obs;
  var validUpdatedDriving = true.obs;
  var passwordOtp = ''.obs;
  var resetPasswordEmail = ''.obs;
  var transactionIdInfo = ''.obs;
  var transactionIdDriving = ''.obs;
  var transactionIdVehicle = ''.obs;
  var showResetPassword = false.obs;
  var showResetConfirmedPassword = false.obs;
  var isInternetConnected = true.obs;
  var localInfo = AjwadiInfo();

  // var plateNumber1 = ''.obs;
  // var plateNumber2 = ''.obs;
  // var plateNumber3 = ''.obs;
  // var plateNumber4 = ''.obs;
  // var plateletter1 = ''.obs;
  // var plateletter2 = ''.obs;
  // var plateletter3 = ''.obs;
  // var selectedRide = ''.obs;
  var isVehicleInfSucess = true.obs;
  var isLinceseInfSucess = true.obs;
  var appVersion = ''.obs;

  // 1 GET COUNTRIES ..
  Future<List<String>?> getListOfCountries(BuildContext context) async {
    try {
      isCountryLoading(true);
      final data = await AuthService.getListOfCountries(context);
      if (data != null) {
        countries(data);
        log(countries.value.first);
        return countries;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isCountryLoading(false);
    }
  }

  // 2 TOURIST REGISTER WITH EMAIL ..
  Future<bool> touristRegister({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String nationality,
    required bool rememberMe,
    required BuildContext context,
  }) async {
    try {
      isRegisterLoading(true);
      final isSuccess = await AuthService.touristRegister(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        nationality: nationality,
        rememberMe: rememberMe,
        context: context,
      );

      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isRegisterLoading(false);
    }
  }

  // 3 GET OTP by id and birth date ..
  Future<Map<dynamic, dynamic>?> personInfoOTP({
    required String nationalID,
    required String birthDate,
    required BuildContext context,
  }) async {
    try {
      isPersonInfoLoading(true);
      final responseBody = await AuthService.personInfoOTP(
        nationalID: nationalID,
        birthDate: birthDate,
        context: context,
      );
      if (responseBody != null) {
        transactionIdInfo.value = responseBody['transactionId'];
      }
      return responseBody;
      //return isSuccess;
    } catch (e) {
      return null;
    } finally {
      isPersonInfoLoading(false);
    }
  }

  Future<bool> createAccountInfo({
    required BuildContext context,
    required String email,
    required String iban,
    required String type,
  }) async {
    try {
      isCreateAccountLoading(true);
      final data = await AuthService.createAccountInfo(
          context: context, email: email, iban: iban, type: type);
      return data;
    } catch (e) {
      isCreateAccountLoading(false);
      return false;
    } finally {
      isCreateAccountLoading(false);
    }
  }

//to send otp sign up
  Future<bool> signUpWithRowad(
      {required BuildContext context,
      required String nationalId,
      required String otp,
      required String number,
      required String transactionId,
      required String birthDate}) async {
    try {
      isSignUpRowad(true);
      final data = await AuthService.signUpWithRowad(
          context: context,
          nationalId: nationalId,
          transactionId: transactionId,
          otp: otp,
          number: number,
          birthDate: birthDate);
      log('signUp Roawad');
      log(data.toString());
      return data;
    } catch (e) {
      isSignUpRowad(false);
      return false;
    } finally {
      isSignUpRowad(false);
    }
  }

  // 4 Registeration with Rowad
  Future<bool> registerWithRowad({
    required String otp,
    required String nationalID,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String nationality,
    required String userRole,
    required BuildContext context,
  }) async {
    try {
      isSigininwithRowad(true);
      final isSuccess = await AuthService.registerWithRowad(
        otp: otp,
        nationalID: nationalID,
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        nationality: nationality,
        userRole: userRole,
        context: context,
      );

      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isSigininwithRowad(false);
    }
  }

// 5 Login
  Future<User?> login({
    required String email,
    required String password,
    required bool rememberMe,
    required BuildContext context,
  }) async {
    try {
      isLoginLoading(true);
      final user = await AuthService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
        context: context,
      );

      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isLoginLoading(false);
    }
  }

  Future<AjwadiInfo?> checkLicenceAndVehicle(String accessToken) async {
    try {
      final result = await AuthService.checkLicenceAndVehicle(accessToken);
      return result;
    } catch (e) {
      return null;
    } finally {}
  }

// 6 Send OTP to email Reset Password
  Future<Map<dynamic, dynamic>?> sendEmailOTP({
    required String email,
    required BuildContext context,
  }) async {
    try {
      isOTPLoading(true);
      final code = await AuthService.sendEmailOTP(
        email: email,
        context: context,
      );
      return code;
    } catch (e) {
      return null;
    } finally {
      isOTPLoading(false);
    }
  }

  Future<Map<dynamic, dynamic>?> sendPasswordOTP({
    required String email,
    required BuildContext context,
  }) async {
    try {
      isResetPasswordOtpLoading(true);
      final data =
          await AuthService.sendPasswordOTP(email: email, context: context);
      return data;
    } catch (e) {
      isResetPasswordOtpLoading(false);
      return null;
    } finally {
      isResetPasswordOtpLoading(false);
    }
  }

// 7 Reset Password
  Future<bool> resetPassword({
    required String newPassword,
    required String email,
    required BuildContext context,
  }) async {
    try {
      isResetPasswordLoading(true);
      final isSuccess = await AuthService.resetPassword(
        newPassword: newPassword,
        email: email,
        context: context,
      );
      return isSuccess;
    } catch (e) {
      isResetPasswordLoading(false);

      return false;
    } finally {
      isResetPasswordLoading(false);
    }
  }

  Future<bool> resetEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      isEmailUpadting(true);
      final isSuccess = await AuthService.resetEmail(
        email: email,
        context: context,
      );
      return isSuccess;
    } catch (e) {
      isEmailUpadting(false);
      return false;
    } finally {
      isEmailUpadting(false);
    }
  }

  // 8 Send OTP to phone for driving linces
  Future<Map<dynamic, dynamic>?> drivingLinceseOTP(
      {required BuildContext context, required String expiryDate}) async {
    try {
      isLienceseOTPLoading(true);
      final isSuccess = await AuthService.drivingLinceseOTP(
        expiryDate: expiryDate,
        context: context,
      );
      if (isSuccess != null) {
        transactionIdDriving(isSuccess['transactionId']);
      }
      return isSuccess;
    } catch (e) {
      log('i am here');
      log(e.toString());

      return null;
    } finally {
      isLienceseOTPLoading(false);
    }
  }

// 9 Send OTP to phone for Vichele
  Future<Map<dynamic, dynamic>?> vehicleOTP({
    required String vehicleSerialNumber,
    required BuildContext context,
  }) async {
    try {
      isVicheleOTPLoading(true);
      final isSuccess = await AuthService.vehicleOTP(
        vehicleSerialNumber: vehicleSerialNumber,
        context: context,
      );
      if (isSuccess != null) {
        transactionIdVehicle(isSuccess['transactionId']);
      }
      return isSuccess;
    } catch (e) {
      return null;
    } finally {
      isVicheleOTPLoading(false);
    }
  }

  // 10 get lincese info for ajwadi
  Future<bool> getAjwadiLinceseInfo({
    required String expiryDate,
    required String otp,
    required String transactionId,
    required BuildContext context,
  }) async {
    try {
      isLienceseLoading(true);

      final isSuccess = await AuthService.getAjwadiLinceseInfo(
        expiryDate: expiryDate,
        transactionId: transactionId,
        otp: otp,
        context: context,
      );
      if (isSuccess) {
        isLinceseInfSucess(true);
      } else {
        isLinceseInfSucess(false);
      }
      return isSuccess;
    } catch (e) {
      isLinceseInfSucess(false);

      return false;
    } finally {
      isLienceseLoading(false);
    }
  }

  // 11 get lincese info for ajwadi
  Future<bool> getAjwadiVehicleInf({
    required String otp,
    required String transactionId,
    required BuildContext context,
  }) async {
    try {
      isVicheleLoading(true);
      final isSuccess = await AuthService.getAjwadiVehicleInfo(
        otp: otp,
        transactionId: transactionId,
        context: context,
      );
      if (isSuccess) {
        isVehicleInfSucess(true);
      } else {
        isVehicleInfSucess(false);
      }
      return isSuccess;
    } catch (e) {
      isVehicleInfSucess(false);

      return false;
    } finally {
      isVicheleLoading(false);
    }
  }

  Future<bool> logOut() async {
    try {
      final isSuccess = await AuthService.logOut();

      if (isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<User?> refreshToken({
    required String refreshToken,
    required BuildContext context,
  }) async {
    try {
      final user = await AuthService.refreshToken(
        refreshToken: refreshToken,
        context: context,
      );

      return user;
    } catch (e) {
      return null;
    } finally {}
  }

  Future<bool> deleteAccount({
    required BuildContext context,
  }) async {
    try {
      final isSuccess = await AuthService.deleteAccount(context: context);

      if (isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> createOtp(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      isCreateOtpLoading(true);
      final isSuccess = await AuthService.createOtp(
          context: context, phoneNumber: phoneNumber);
      return isSuccess;
    } catch (e) {
      isCreateOtpLoading(false);
      AppUtil.errorToast(context, e.toString());
      return false;
    } finally {
      isCreateOtpLoading(false);
    }
  }

  Future<bool> localSignInWithOtp(
      {required BuildContext context,
      required String phoneNumber,
      required String otp}) async {
    try {
      isSignInWithOtpLoading(true);
      final isSuccess = await AuthService.localSignInWithOtp(
          context: context, phoneNumber: phoneNumber, otp: otp);
      return isSuccess;
    } catch (e) {
      AppUtil.errorToast(context, e.toString());

      isSignInWithOtpLoading(false);
      return false;
    } finally {
      isSignInWithOtpLoading(false);
    }
  }

  Future<AjwadiInfo?> checkLocalInfo({required BuildContext context}) async {
    try {
      // isCheckLocalLoading(true);
      final data = await AuthService.checkLocalInfo(context: context);
      localInfo = data!;

      // if ((localInfo.transportationMethod ?? []).isEmpty) {
      //   isNotCompleteLocalInfo(true);
      // } else {
      //   isNotCompleteLocalInfo(false);
      // }
      return localInfo;
    } catch (e) {
      log(e.toString());

      isCheckLocalLoading(false);
      return null;
    } finally {
      isCheckLocalLoading(false);
    }
  }

  Future<bool> sendVehcileDetails({
    required BuildContext context,
    required String plateletter1,
    required String plateletter2,
    required String plateLetter3,
    required String plateNumber,
    required String vehicleType,
    required String vehicleSerialNumber,
  }) async {
    try {
      isSendVehicleDetails(true);
      final isSuccess = await AuthService.sendVehcileDetails(
          context: context,
          plateletter1: plateletter1,
          plateletter2: plateletter2,
          plateLetter3: plateLetter3,
          plateNumber: plateNumber,
          vehicleType: vehicleType,
          vehicleSerialNumber: vehicleSerialNumber);
      return isSuccess;
    } catch (e) {
      isSendVehicleDetails(false);
      return false;
    } finally {
      isSendVehicleDetails(false);
    }
  }

  void checkLocalWhenSignIn(BuildContext context) async {
    final local = await checkLocalInfo(context: context);
    if (local != null) {
      // if (local.accountType == 'TOUR_GUID' &&
      //     local.vehicle &&
      //     local.drivingLicense) {
      //   AmplitudeService.amplitude
      //       .track(BaseEvent('Local Signed in as tour guide '));
      //   Get.offAll(() => const AjwadiBottomBar());
      // }
      if (local.accountType == 'TOUR_GUID') {
        AmplitudeService.amplitude
            .track(BaseEvent('Local Signed in as tour guide '));
        Get.offAll(() => const LocalBottomBar());
      }
      //  else if (local.accountType == 'TOUR_GUID' &&
      //     local.drivingLicense == false) {
      //   AmplitudeService.amplitude.track(BaseEvent(
      //       "Local Signed is tour guide but doesn't have driving license info  "));
      //   activeBar(2);
      //   Get.off(() => const TourStepper());
      // }

      //  else if (local.accountType == 'TOUR_GUID' && local.vehicle == false) {
      //   AmplitudeService.amplitude.track(BaseEvent(
      //       "Local Signed is tour guide but doesn't have vehicle  info  "));
      //   activeBar(3);
      //   Get.off(() => const TourStepper());
      // }
      else if (local.accountType == 'EXPERIENCES') {
        AmplitudeService.amplitude
            .track(BaseEvent('Local Signed in as experience '));
        Get.offAll(() => const LocalBottomBar());
      } else if (local.accountType == null || local.accountType!.isEmpty) {
        AmplitudeService.amplitude.track(BaseEvent(
            "Local Signed is tour guide but doesn't have accountType "));
        Get.offAll(() => const ProvidedServices());
        // activeBar(1);
      } else {
        // activeBar(1);
        Get.off(() => const ProvidedServices());
      }
    } else {
      AppUtil.errorToast(context, "somthingWentWrong".tr);
    }
  }

  Future<AppVersion?> getAppVersion({required BuildContext context}) async {
    try {
      isGetAppVersionLoading(true);
      final data = await AuthService.getAppVersion(context: context);
      if (data != null) {
        appVersion.value = data.versionNumber ?? "";
        return data;
      }
      return null;
    } catch (e) {
      isGetAppVersionLoading(false);
      return null;
    } finally {
      isGetAppVersionLoading(false);
    }
  }

  void checkAppVersion({required BuildContext context}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final build = packageInfo.buildNumber;

    final appVersion = await getAppVersion(context: context);

    if (appVersion == null || appVersion.versionNumber == null) {
      return;
    }

    log(appVersion.versionNumber ?? "NO Ver");
    log(version);
    log(build);

    if (appVersion.versionNumber == version) {
      log('Same Version');
      // log(appVersion.isMandatory.toString());
    } else if (appVersion.isMandatory ?? true) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          // ignore: deprecated_member_use
          builder: (ctx) => WillPopScope(
            onWillPop: () async => false,
            child: const AppVersionDialog(),
          ),
        );
      }
    } else {
      // log('not Same Version but not mandatory');
    }
  }
}
