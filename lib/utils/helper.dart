// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class Helper {
  static String? validateName(String value) {
    if (value.isEmpty) {
      return "Name is not Empty";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a Valid Email Address';
    } else {
      return null;
    }
  }

  static String? validatePassword(
      String value, String passwordC, String confirmPasswordC) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please Enter Your Password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must contain atleast:\n1) 8 character\n2) atleast 1 lower case\n3) atleast 1 upper case\n4) atleast 1 numaric value\n5) atleast on special character';
      } else if (passwordC != confirmPasswordC) {
        return "Please Enter Same Password";
      } else {
        return null;
      }
    }
  }

  static String? validatePassword1(String value, String passwordC) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please Enter Your Password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must contain atleast:\n- 8 character\n- atleast 1 lower case\n- atleast 1 upper case\n- atleast 1 numaric value\n- atleast on special character';
      } else {
        return null;
      }
    }
  }

  static String? validateOTP(String value) {
    if (value.toString().trim().length < 6) {
      return 'Please Enter 6-Digits OTP';
    }
    return null;
  }

  // ? //////////////////////////////////////////////////////////////

  static Future<String> getImage() async {
    String returnImagePathC = '';
    final imagePicker = ImagePicker();

    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1000,
      maxWidth: 1000,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      print('First Image Size : ${File(pickedFile.path).lengthSync()}');
      XFile? result;
      result = await FlutterImageCompress.compressAndGetFile(
        File(pickedFile.path).absolute.path,
        '${pickedFile.path}compressed.jpg',
        minHeight: 1000,
        minWidth: 1000,
        quality: 30,
      );

      if (kDebugMode) {
        print('After Image Size :  ${result!.readAsBytes()}');
      }

      returnImagePathC = result!.path.toString();
    }
    return returnImagePathC.toString();
  }

  static Future<List<dynamic>?> getUserCurrentLocation() async {
    String userCurrentLocation;

    List<dynamic>? latLongList;
    try {
      await getUserCurrentLatLong().then((value) async {
        print(
            'Current LatLong : ${value.latitude.toString()} : ${value.longitude.toString()}');

        List<Placemark> placemarks =
            await placemarkFromCoordinates(value.latitude, value.longitude);
        userCurrentLocation =
            '${placemarks.reversed.last.locality!}, ${placemarks.reversed.last.subLocality!}, ${placemarks.reversed.last.street!}';

        print(userCurrentLocation.toString());

        latLongList = [value.latitude, value.longitude, userCurrentLocation];
      });
    } catch (e) {
      print(e.toString());
    }

    return latLongList;
  }

  static Future getUserCurrentLatLong() async {
    try {
      LocationPermission permission;
      bool isLocationServiceEnabled;
      permission = await Geolocator.checkPermission();
      permission = await Geolocator.requestPermission();

      isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (isLocationServiceEnabled == false) {
        print("isLocationServiceEnabled1 $isLocationServiceEnabled");

        await Geolocator.openLocationSettings();
      } else if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("permission1 $permission");

        await Geolocator.openAppSettings();
      } else {
        return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      }
      return null;
    } catch (e) {
      print(e.toString());
    }
  }

  static double calculateDistanceWithGeo(double lat1, lon1, lat2, lon2) {
    var R = 6372.8;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));

    var returnValue = R * c;
    print("returnValue : $returnValue");
    return (returnValue * 1000);
  }
}

double _toRadians(double degree) {
  return degree * pi / 180;
  // }
}
