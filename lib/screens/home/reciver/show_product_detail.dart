// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/components/show_zoom_image.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowProductDetails extends StatefulWidget {
  var productData;
  var userData;
  ShowProductDetails(
      {required this.productData, required this.userData, super.key});

  @override
  State<ShowProductDetails> createState() => _ShowProductDetailsState();
}

class _ShowProductDetailsState extends State<ShowProductDetails> {
  final formKey = GlobalKey<FormState>();
  TextEditingController orderItemsC = TextEditingController();
  TextEditingController deliveredAddressC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            color: AppColor.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [Color(0xff471a91), Color(0xff3cabff)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowZoomImagePage(
                          title: "Product Image",
                          path: widget.productData['productImage']),
                    ),
                  );
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.productData['productImage'],
                        ),
                      )),
                ),
              ),
              returnRow("Product Name ", "${widget.productData['productName']}",
                  null),
              returnRow(
                  "Product Des ", "${widget.productData['productDes']}", null),
              returnRow(
                  "Category ", "${widget.productData['categoryType']}", null),
              returnRow("Address ", "${widget.productData['address']}", null),
              returnRow("LatLong ", "${widget.productData['latLong']}", 3),
              widget.productData['totalItems'] != ""
                  ? Column(
                      children: [
                        returnRow("TotalItems ",
                            "${widget.productData['totalItems']}", null),
                        returnRow("Availables Items ",
                            "${widget.productData['availableItems']}", null)
                      ],
                    )
                  : Container(height: 0),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: orderItemsC,
                  validator: (String? value) {
                    if (value!.trim().isEmpty) {
                      return 'Order Items is Empty';
                    }
                    return null;
                  },
                  style: const TextStyle(
                      color: Colors.black, fontFamily: "CentraleSansRegular"),
                  readOnly: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xffd3dde4), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xffd3dde4), width: 2)),
                      labelText: "Order Items*",
                      labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "CentraleSansRegular")),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: deliveredAddressC,
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Delivered Address is Empty';
                  }
                  return null;
                },
                style: const TextStyle(
                    color: Colors.black, fontFamily: "CentraleSansRegular"),
                readOnly: false,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xffd3dde4), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xffd3dde4), width: 2)),
                    labelText: "Delivered Address*",
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "CentraleSansRegular")),
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (deliveredAddressC.text.trim().isNotEmpty) {
                      if (int.parse(widget.productData["availableItems"]
                              .toString()) >=
                          int.parse(orderItemsC.text.toString().trim())) {
                        Components.showAlertDialog(context);

                        String orderID =
                            DateTime.now().microsecondsSinceEpoch.toString();

                        await FirebaseFirestore.instance
                            .collection("Order")
                            .doc(orderID.toString())
                            .set({
                          "orderID": orderID.toString(),
                          "userUID":
                              FirebaseAuth.instance.currentUser!.uid.toString(),
                          "donerUID": widget.productData["userUID"].toString(),
                          "productID":
                              widget.productData["productID"].toString(),
                          'adminApprove': false,
                          'adminReject': false,
                          "orderItems": orderItemsC.text.toString().trim(),
                          "deliveredAddress":
                              deliveredAddressC.text.toString().trim(),
                          "isShipped": false,
                          "isDelivered": false,
                          "parcelTrackingID": "",
                          "time": FieldValue.serverTimestamp(),
                        }).whenComplete(
                          () async {
                            await FirebaseFirestore.instance
                                .collection("Product")
                                .doc(widget.productData["productID"].toString())
                                .update({
                              "availableItems": int.parse(widget
                                      .productData["availableItems"]
                                      .toString()) -
                                  int.parse(orderItemsC.text.toString().trim()),
                            }).whenComplete(() {
                              Components.showSnackBar(
                                  context, 'Order Saved Successfully');
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                        ).catchError((e) {
                          Navigator.of(context).pop();
                          Components.showSnackBar(context, e.toString());
                        });
                      } else {
                        Components.showSnackBar(context,
                            "Please enter order items Less then or equal to availables items");
                      }
                    } else {
                      Components.showSnackBar(
                          context, "Please enter Delivery Address");
                    }
                  } else {
                    Components.showSnackBar(context, "Please enter items");
                  }
                },
                child: Container(
                  width: 330,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xff471a91), Color(0xff3cabff)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Order",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "CentraleSansRegular",
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  returnRow(String title, String value, int? iconIndex, {String? userEmail}) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        title: Text(
          title.toString(),
          style: TextStyle(
            color: AppColor.blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(value),
        trailing: iconIndex == 3
            ? IconButton(
                onPressed: () async {
                  List list = value.split(",");
                  MapsLauncher.launchCoordinates(
                      double.parse(list[0].toString().trim()),
                      double.parse(list[1].toString().trim()));
                },
                icon: const Icon(
                  Icons.map_sharp,
                  color: Colors.black,
                ))
            : iconIndex == 1
                ? IconButton(
                    onPressed: () async {
                      String number =
                          "${widget.userData['phoneNumber']}"; //set the number here

                      await FlutterPhoneDirectCaller.callNumber(number);
                    },
                    icon: const Icon(
                      Icons.call,
                      color: Colors.black,
                    ))
                : iconIndex == 2
                    ? IconButton(
                        onPressed: () {
                          whatsapp("${widget.userData['wPhoneNumber']}");
                        },
                        icon: const Icon(
                          LineAwesomeIcons.what_s_app,
                          color: Colors.black,
                        ))
                    : null);
  }

  whatsapp(String number) async {
    var contact = number;
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      //EasyLoading.showError('WhatsApp is not installed.');
    }
  }
}
