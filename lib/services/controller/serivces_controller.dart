import 'package:ajwad_v4/payment/model/payment_result.dart';
import 'package:ajwad_v4/services/model/hospitality.dart';
import 'package:ajwad_v4/services/model/payment.dart';
import 'package:ajwad_v4/services/service/serivces_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SrvicesController extends GetxController {
  var isHospitalityLoading = false.obs;
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;
  var selectedDateIndex =(-1).obs;
  var selectedDateId ="".obs;
  var isHospitalityByIdLoading = false.obs;

  var isCheckAndBookLoading = false.obs;
  var isCheckHospitalitPaymentLoading = false.obs;
  var isHospitalitPaymentLoading = false.obs;

  var hospitalityList = <Hospitality>[].obs;
  var isHospatilityDateSelcted = false.obs;

  Future<List<Hospitality>?> getAllHospitality({
    required BuildContext context,
  }) async {
    try {
      isHospitalityLoading(true);
      final data = await ServicesService.getAllHospitality(context: context);
      if (data != null) {
        hospitalityList(data);
      }
      return hospitalityList;
    } catch (e) {
      print(e);
      isHospitalityLoading(false);
      return null;
    } finally {
      isHospitalityLoading(false);
    }
  }


    Future<Hospitality?> getHospitalityById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      print("TRUE");
      isHospitalityByIdLoading(true);
      final data = await ServicesService.getHospitalityById(context: context,id: id);
      return data;
    } catch (e) {
      isHospitalityByIdLoading(false);
      return null;
    } finally {
      isHospitalityByIdLoading(false);
    }
  }


      Future<bool> checkAndBookHospitality({
       required BuildContext context,
    required bool check,
    String? paymentId,
    required String hospitalityId,
    required String date,
    required String time,
    required String dayId,
    required int numOfMale,
    required int numOfFemale,
    required int cost,
  }) async {
    try {
      print("TRUE");
      isCheckAndBookLoading(true);
      print('  \ncheck: $check, \n hospitalityId:$hospitalityId, paymentId: $paymentId,\n ,date: $date, time: $time,dayId: $dayId, numOfFemale: $numOfFemale, numOfMale: $numOfMale, cost: $cost');

      final data = await ServicesService.checkAndBookHospitality(
        context: context,
        check: check, 
        hospitalityId: hospitalityId,
        paymentId: paymentId,
        date: date,
        time: time,
        dayId: dayId,
        numOfFemale: numOfFemale,
        numOfMale: numOfMale,
        cost: cost
        );

      return data;
    } catch (e) {
      print(e);
      isCheckAndBookLoading(false);
      return false;
    } finally {
      isCheckAndBookLoading(false);
    }
  }




        Future<Payment?> hospitalityPayment({
      required BuildContext context,
   required String hospitalityId,
  }) async {
    try {
      print("TRUE");
      isCheckAndBookLoading(true);
      final data = await ServicesService.hospitalityPayment(
        context: context,
        hospitalityId: hospitalityId,
       
        );
      return data;
    } catch (e) {
      print(e);
      isCheckAndBookLoading(false);
      return null;
    } finally {
      isCheckAndBookLoading(false);
    }
  }


  var isCreditCardPaymentLoading = false.obs;
 // var PaymentResult = false.obs;


  Future<PaymentResult?> payWithCreditCard({
    required BuildContext context,

    required int amount,
    required String name,
    required String number,
    required String cvc,
    required String month,
    required String year,

  }) async {{

    try {
      isCreditCardPaymentLoading(true);
      final data = ServicesService.payWithCreditCard(context: context, amount: amount, name: name, number: number, cvc: cvc, month: month, year: year,);
      return data;
    } catch(e) {
      print(e);
      return null ;
    } finally {
       isCreditCardPaymentLoading(false);
    }
  }}

}
