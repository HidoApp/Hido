import 'dart:developer';

import 'package:ajwad_v4/auth/models/ajwadi_info.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
import 'package:ajwad_v4/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  var isSignUpRowad = false.obs;
  var isCreateAccountLoading = false.obs;
  var isCreateOtpLoading = false.obs;
  var isSignInWithOtpLoading = false.obs;
  var isCheckLocalLoading = false.obs;
  var isResendOtp = true.obs;
  //valditon vars
  var hidePassword = true.obs;
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  // sign in & sign up fields
  var activeBar = 1.obs;
  final contactKey = GlobalKey<FormState>();
  final vehicleKey = GlobalKey<FormState>();
  var localID = ''.obs;
  var drivingDate = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var iban = ''.obs;
  var vehicleLicense = ''.obs;
  var validBirthDay = true.obs;
  var validDriving = true.obs;
  //edit license
  var updatedDriving = ''.obs;
  var updatedVehicle = ''.obs;
  var validUpdatedDriving = true.obs;

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
      print(e);

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
      print(isSuccess);
      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isRegisterLoading(false);
    }
  }

  // 3 GET OTP by id and birth date ..
  Future<bool> personInfoOTP({
    required String nationalID,
    required String birthDate,
    required BuildContext context,
  }) async {
    try {
      isPersonInfoLoading(true);
      final isSuccess = await AuthService.personInfoOTP(
        nationalID: nationalID,
        birthDate: birthDate,
        context: context,
      );
      print("isSuccess CONTROLLER $isSuccess");
      return isSuccess;
    } catch (e) {
      print("isSuccess CONTROLLER FALSE");
      print(e);
      return false;
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
      required String birthDate}) async {
    try {
      isSignUpRowad(true);
      final data = await AuthService.signUpWithRowad(
          context: context,
          nationalId: nationalId,
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
      print("isSuccess CONTROLLER $isSuccess");
      return isSuccess;
    } catch (e) {
      print("isSuccess CONTROLLER FALSE");
      print(e);
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
      print(user);
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
  Future<bool> drivingLinceseOTP({
    required BuildContext context,
  }) async {
    try {
      isLienceseOTPLoading(true);
      final isSuccess = await AuthService.drivingLinceseOTP(
        context: context,
      );
      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isLienceseOTPLoading(false);
    }
  }

// 9 Send OTP to phone for Vichele
  Future<bool> vehicleOTP({
    required String vehicleSerialNumber,
    required BuildContext context,
  }) async {
    try {
      isVicheleOTPLoading(true);
      final isSuccess = await AuthService.vehicleOTP(
        vehicleSerialNumber: vehicleSerialNumber,
        context: context,
      );
      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isVicheleOTPLoading(false);
    }
  }

  // 10 get lincese info for ajwadi
  Future<bool> getAjwadiLinceseInfo({
    required String expiryDate,
    required String otp,
    required BuildContext context,
  }) async {
    try {
      isLienceseLoading(true);
      print('expiryDate Controller : $expiryDate');
      final isSuccess = await AuthService.getAjwadiLinceseInfo(
        expiryDate: expiryDate,
        otp: otp,
        context: context,
      );
      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isLienceseLoading(false);
    }
  }

  // 11 get lincese info for ajwadi
  Future<bool> getAjwadiVehicleInf({
    required String otp,
    required BuildContext context,
  }) async {
    try {
      isVicheleLoading(true);
      final isSuccess = await AuthService.getAjwadiVehicleInfo(
        otp: otp,
        context: context,
      );
      return isSuccess;
    } catch (e) {
      return false;
    } finally {
      isVicheleLoading(false);
    }
  }

  bool logOut() {
    try {
      final isSuccess = AuthService.logOut();

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
      isCheckLocalLoading(true);
      final data = await AuthService.checkLocalInfo(context: context);
      return data;
    } catch (e) {
      isCheckLocalLoading(false);
      return null;
    } finally {
      isCheckLocalLoading(false);
    }
  }
}
