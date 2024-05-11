// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

String alertUserUID = '';

String userlat = '33.68440';
String userLong = '73.04790';
String userInfoWundow = '';

bool cameraMove = true;

class ShowAllDonersOnMapScreen extends StatefulWidget {
  // BuildContext context1;
  const ShowAllDonersOnMapScreen({Key? key}) : super(key: key);

  @override
  State<ShowAllDonersOnMapScreen> createState() =>
      _ShowAllDonersOnMapScreenState();
}

class _ShowAllDonersOnMapScreenState extends State<ShowAllDonersOnMapScreen> {
  List<Marker> markers = [];

  final Completer<GoogleMapController> googleMapcontroller = Completer();

  Timer? _timer;
  @override
  void initState() {
    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    loadData();
    getLatLongAllUsers(context);
    // });

    super.initState();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
      //
    }).onError((error, stackTrace) {
      // Components.showSnackBar(context, error.toString());
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool canPop = true;
    return WillPopScope(
      onWillPop: () async {
        if (canPop) {
          setState(() {});
          return false;
        }
      },
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          markers: Set<Marker>.of(markers),
          initialCameraPosition: CameraPosition(
            target:
                LatLng(double.tryParse(userlat)!, double.tryParse(userLong)!),
            zoom: 14.4746,
          ),
          onMapCreated: (mapController) {
            googleMapcontroller.complete(mapController);
          },
          zoomGesturesEnabled: true,
          tiltGesturesEnabled: false,
        ),
      ),
    );
  }

  loadData() async {
    getUserCurrentLocation().then((value) async {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(value.latitude, value.longitude);

        userlat = '${value.latitude}';
        userLong = '${value.longitude}';
        userInfoWundow =
            'My Current : ${placemarks.reversed.last.country}, ${placemarks.reversed.last.locality}, ${placemarks.reversed.last.street}';

        await FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'latLong': "$userlat, $userLong",
          'address':
              '${placemarks.reversed.last.country}, ${placemarks.reversed.last.locality}, ${placemarks.reversed.last.street}'
        });

        // new
        if (cameraMove == true) {
          GoogleMapController controller = await googleMapcontroller.future;

          setState(() {
            controller.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  zoom: 17,
                  target:
                      LatLng(double.parse(userlat), double.parse(userLong)))),
            );
          });
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void getLatLongAllUsers(BuildContext context) async {
    print('ABC');
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('User')
        .where("userType", isEqualTo: "Doner")
        .get();

    List<Marker> list = [];
    for (var document in snap.docs) {
      // if (document['userUID'] != FirebaseAuth.instance.currentUser!.uid) {
      if (document["latLong"] != "") {
        List<String> latlong = document['latLong'].toString().split(",");
        print("latlong : $latlong");
        list.add(
          Marker(
            infoWindow: InfoWindow(title: document['address'].toString()),
            markerId: MarkerId(document['userUID'].toString()),
            position: LatLng(
              double.parse(latlong[0].toString().trim()),
              double.parse(latlong[1].toString().trim()),
            ),
          ),
        );
        // }
      }
    }
    markers.clear();
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icons/currentLocationIcon.png', 100);
    markers.add(
      Marker(
        infoWindow: InfoWindow(title: userInfoWundow.toString()),
        markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid.toString()),
        position: LatLng(double.parse(userlat.toString()),
            double.parse(userLong.toString())),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    );
    setState(() {
      markers.addAll(list);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
