import 'package:ajwad_v4/auth/models/ajwadi_info.dart';
import 'package:ajwad_v4/auth/models/user.dart';
import 'package:ajwad_v4/auth/services/auth_service.dart';
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

  var nationalId = ''.obs;
  var birthDate = ''.obs;

  //valditon vars
  var hidePassword = true.obs;
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;

  // 1 GET COUNTRIES ..
  Future<List<String>?> getListOfCountries(BuildContext context) async {
    try {
      isCountryLoading(true);
      final data = await AuthService.getListOfCountries(context);
      if (data != null) {
        countries(data);
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
    print(rememberMe);
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
      return false;
    } finally {
      isResetPasswordLoading(false);
    }
  }

  // 8 Send OTP to phone for driving linces
  Future<bool> drivingLinceseOTP({
    required String nationalID,
    required String birthDate,
    required BuildContext context,
  }) async {
    try {
      isLienceseOTPLoading(true);
      final isSuccess = await AuthService.drivingLinceseOTP(
        nationalID: nationalID,
        birthDate: birthDate,
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
    required String nationalID,
    required String vehicleSerialNumber,
    required BuildContext context,
  }) async {
    try {
      isVicheleOTPLoading(true);
      final isSuccess = await AuthService.vehicleOTP(
        nationalID: nationalID,
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
    required String nationalID,
    required String expiryDate,
    required String otp,
    required String accessToken,
    required BuildContext context,
  }) async {
    try {
      isLienceseLoading(true);
      print('expiryDate Controller : $expiryDate');
      final isSuccess = await AuthService.getAjwadiLinceseInfo(
        nationalID: nationalID,
        expiryDate: expiryDate,
        otp: otp,
        accessToken: accessToken,
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
    required String nationalID,
    required String otp,
    required String accessToken,
    required BuildContext context,
  }) async {
    try {
      isVicheleLoading(true);
      final isSuccess = await AuthService.getAjwadiVehicleInfo(
          nationalID: nationalID,
          otp: otp,
          context: context,
          accessToken: accessToken);
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
}
