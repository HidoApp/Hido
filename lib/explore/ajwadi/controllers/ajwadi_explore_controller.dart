import 'dart:io';

import 'package:ajwad_v4/auth/models/image.dart';
import 'package:ajwad_v4/explore/ajwadi/model/trip.dart';
import 'package:ajwad_v4/explore/ajwadi/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjwadiExploreController extends GetxController {
  var isAddingTripLoading = false.obs;
  var isImagesLoading = false.obs;
  var isAllTripsLoading = false.obs;
  var isTripLoading = false.obs;
  var isLatLangEmpty = false.obs;
  var isPriceEmpty = false.obs;
  var isDateEmpty = false.obs;
  var isImageEmpty = false.obs;
  var selectedAdvDate = ''.obs;
  var selectedEventDate = ''.obs;

    var numOfImages = 0.obs;


  Future<UploadImage?> uploadImages({ required File file , required String fileType ,required BuildContext context}) async {
    try {
      isImagesLoading(true);
    final isSucces =  await TripService.uploadImages( file: file,fileType: fileType,context: context);
  
    return isSucces;
       } catch (e) {
        print('error');
    return UploadImage(filePath: '',id: '',publicId: '');
    } finally {
      isImagesLoading(false);
    }
  }

  Future<Trip?> addTrip({
    required String tripOption,
      
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String price,
    required String date,
    required String lat,
    required String lang,
   required List< UploadImage > imag,
    required BuildContext context,
  }) async {
    try {
      isAddingTripLoading(true);
      final data = await TripService.addTrip(
        tripOption: tripOption,
        nameAr:nameAr,
        nameEn:nameEn,
        descriptionAr:descriptionAr,
        descriptionEn:descriptionEn,
        price:price,
        date:date,
        lat:lat,
        lang:lang,
        imag: imag,
        
        context: context,
      );

           print(true);
      if (data != null) {
     
        return data; 
      } else {
       //  print('Hi');
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isAddingTripLoading(false);
    }
  }

  Future<dynamic> getAllTrips({
    required BuildContext context,
  }) async {
    try {
      isAllTripsLoading(true);
      final data = await TripService.getAllTrips(
        context: context,
      );
      if (data != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    } finally {
      isAllTripsLoading(false);
    }
  }

  Future<Trip?> getTripById({
    required String tripId,
    required BuildContext context,
  }) async {
    try {
      isTripLoading(true);
      final data = await TripService.getTripById(
        tripId: tripId,
        context: context,
      );
      if (data != null) {
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isTripLoading(false);
    }
  }
}
