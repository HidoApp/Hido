import 'dart:async';

import 'package:ajwad_v4/explore/ajwadi/model/userLocation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  late UserLocation userLocation;
  late Position _currentLocation;
  Geolocator geolocator = Geolocator();

  Future<UserLocation?> getUserLocation() async {
    try {
      // _currentLocation = await Geolocator.getCurrentPosition();
      var isServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isServiceEnabled) {
        isServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isServiceEnabled) {
          throw Exception("The Location service is disabled!");
        }
      }

      var isPermission = await Geolocator.checkPermission();
      if (isPermission == LocationPermission.denied ||
          isPermission == LocationPermission.deniedForever) {
        isPermission = await Geolocator.requestPermission();
      }
      if (isPermission == LocationPermission.denied ||
          isPermission == LocationPermission.deniedForever) {
        throw Exception("Location Permission requests has been denied!");
      }

      if (isServiceEnabled &&
          (isPermission == LocationPermission.always ||
              isPermission == LocationPermission.whileInUse)) {
        _currentLocation = await Geolocator.getCurrentPosition().timeout(
          Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException(
                "Location information could not be obtained within the requested time.");
          },
        );
      }
      userLocation =
          UserLocation(_currentLocation.latitude, _currentLocation.longitude);
      return userLocation;
    } catch (e) {
      print(e);
      return null;
    } finally {}
  }
}
