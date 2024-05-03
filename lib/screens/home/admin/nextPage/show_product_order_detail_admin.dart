// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/components/show_zoom_image.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowProductOrderDetailsAdmin extends StatefulWidget {
  int userType;
  int index;
  var productData;
  var orderData;
  var donerData;
  var userData;
  ShowProductOrderDetailsAdmin(
      {required this.userType,
      required this.index,
      required this.productData,
      required this.orderData,
      required this.donerData,
      required this.userData,
      super.key});

  @override
  State<ShowProductOrderDetailsAdmin> createState() =>
      _ShowProductOrderDetailsAdminState();
}

class _ShowProductOrderDetailsAdminState
    extends State<ShowProductOrderDetailsAdmin> {
  final formKey = GlobalKey<FormState>();
  TextEditingController orderItemsC = TextEditingController();
  TextEditingController deliveredAddressC = TextEditingController();
  TextEditingController parcelTrackingIDC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return widget.userType == 0
        ? Scaffold(
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
                'Order Details',
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
                    Center(
                      child: Text(
                        "----- Reciver Details -----",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    returnRow(
                        "UserName ", "${widget.userData['userName']}", null),
                    returnRow("Mobile Number ",
                        "${widget.userData['phoneNumber']}", 1),
                    returnRow("WhatsApp Number ",
                        "${widget.userData['wPhoneNumber']}", 2),
                    widget.userData['latLong'] != ''
                        ? returnRow(
                            "LatLong ", "${widget.userData['latLong']}", 3)
                        : Container(height: 0),
                    returnRow("Monthly Incom ",
                        "${widget.userData['monthlyIncom']}", null),
                    returnRow("Source of Incom ",
                        "${widget.userData['sourceOfIncom']}", null),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "----- Doner Details -----",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    returnRow(
                        "UserName ", "${widget.donerData['userName']}", null),
                    returnRow("Mobile Number ",
                        "${widget.donerData['phoneNumber']}", 1),
                    returnRow("WhatsApp Number ",
                        "${widget.donerData['wPhoneNumber']}", 2),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "----- Product Details -----",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    returnRow("Product Name ",
                        "${widget.productData['productName']}", null),
                    returnRow("Product Des ",
                        "${widget.productData['productDes']}", null),
                    returnRow("Category ",
                        "${widget.productData['categoryType']}", null),
                    returnRow("Order Items ",
                        "${widget.orderData['orderItems']}", null),
                    returnRow("Delivered Address ",
                        "${widget.orderData['deliveredAddress']}", null),
                    const SizedBox(height: 30),
                    widget.index == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  Components.showAlertDialog(context);
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection("Order")
                                        .doc(widget.orderData["orderID"])
                                        .update({
                                      'adminApprove': false,
                                      'adminReject': true,
                                    }).whenComplete(
                                      () async {
                                        await FirebaseFirestore.instance
                                            .collection("Product")
                                            .doc(widget.productData["productID"]
                                                .toString())
                                            .update({
                                          "availableItems": int.parse(widget
                                                  .productData["availableItems"]
                                                  .toString()) +
                                              int.parse(widget
                                                  .orderData["orderItems"]
                                                  .toString()
                                                  .trim()),
                                        }).whenComplete(() {
                                          Components.showSnackBar(context,
                                              'Order Reject Successfully');
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                    ).catchError((e) {
                                      Navigator.of(context).pop();
                                      Components.showSnackBar(
                                          context, e.toString());
                                    });
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                                style: ButtonStyle(
                                    textStyle:
                                        MaterialStateProperty.all(TextStyle(
                                      color: AppColor.whiteColor,
                                    )),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                child: Text(
                                  "Reject",
                                  style: TextStyle(color: AppColor.whiteColor),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () async {
                                  Components.showAlertDialog(context);
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection("Order")
                                        .doc(widget.orderData["orderID"])
                                        .update({
                                      'adminApprove': true,
                                      'adminReject': false,
                                    }).whenComplete(
                                      () async {
                                        Components.showSnackBar(context,
                                            'Order Approved Successfully');
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ).catchError((e) {
                                      Navigator.of(context).pop();
                                      Components.showSnackBar(
                                          context, e.toString());
                                    });
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2.0, color: Colors.green),
                                ),
                                child: const Text(
                                  "Approved",
                                  style: TextStyle(color: Colors.green),
                                ),
                              )
                            ],
                          )
                        : Container(height: 0),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
        : widget.userType == 1
            ? Scaffold(
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
                    'Order Details',
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
                        Center(
                          child: Text(
                            "----- Reciver Details -----",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        returnRow("UserName ", "${widget.userData['userName']}",
                            null),
                        returnRow("Mobile Number ",
                            "${widget.userData['phoneNumber']}", 1),
                        returnRow("WhatsApp Number ",
                            "${widget.userData['wPhoneNumber']}", 2),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            "----- Product Details -----",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                        returnRow("Product Name ",
                            "${widget.productData['productName']}", null),
                        returnRow("Product Des ",
                            "${widget.productData['productDes']}", null),
                        returnRow("Category ",
                            "${widget.productData['categoryType']}", null),
                        returnRow("Order Items ",
                            "${widget.orderData['orderItems']}", null),
                        returnRow("Delivered Address ",
                            "${widget.orderData['deliveredAddress']}", null),
                        widget.index != 0
                            ? returnRow("TrackingID",
                                "${widget.orderData['parcelTrackingID']}", null)
                            : Container(height: 0),
                        const SizedBox(height: 30),
                        widget.index == 0
                            ? Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: parcelTrackingIDC,
                                      validator: (String? value) {
                                        if (value!.trim().isEmpty) {
                                          return 'TrackingID is Empty';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "CentraleSansRegular"),
                                      readOnly: false,
                                      minLines: 1,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffd3dde4),
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffd3dde4),
                                                  width: 2)),
                                          labelText: "Tracking ID*",
                                          labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily:
                                                  "CentraleSansRegular")),
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        if (formKey.currentState!.validate()) {
                                          Components.showAlertDialog(context);

                                          await FirebaseFirestore.instance
                                              .collection("Order")
                                              .doc(widget.orderData['orderID'])
                                              .update({
                                            "isShipped": true,
                                            "isDelivered": false,
                                            "parcelTrackingID":
                                                parcelTrackingIDC.text
                                                    .toString()
                                                    .trim(),
                                            "time":
                                                FieldValue.serverTimestamp(),
                                          }).whenComplete(
                                            () async {
                                              Components.showSnackBar(context,
                                                  'Order convert Pending to Shipped Successfully');
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ).catchError((e) {
                                            Navigator.of(context).pop();
                                            Components.showSnackBar(
                                                context, e.toString());
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 330,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff471a91),
                                              Color(0xff3cabff)
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Order In Shipped",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                    "CentraleSansRegular",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(height: 0),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              )
            : widget.userType == 2
                ? Scaffold(
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
                        'Order Details',
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
                            Center(
                              child: Text(
                                "----- Doner Details -----",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            returnRow("UserName ",
                                "${widget.donerData['userName']}", null),
                            returnRow("Mobile Number ",
                                "${widget.donerData['phoneNumber']}", 1),
                            returnRow("WhatsApp Number ",
                                "${widget.donerData['wPhoneNumber']}", 2),
                            const SizedBox(height: 20),
                            widget.index == 5
                                ? Column(
                                    children: [
                                      // const SizedBox(height: 20),
                                      Center(
                                        child: Text(
                                          "----- Reciver Details -----",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColor.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      returnRow(
                                          "UserName ",
                                          "${widget.userData['userName']}",
                                          null),
                                      returnRow(
                                          "Mobile Number ",
                                          "${widget.userData['phoneNumber']}",
                                          1),
                                      returnRow(
                                          "WhatsApp Number ",
                                          "${widget.userData['wPhoneNumber']}",
                                          2),

                                      const SizedBox(height: 20),
                                    ],
                                  )
                                : Container(height: 0),
                            Center(
                              child: Text(
                                "----- Product Details -----",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowZoomImagePage(
                                        title: "Product Image",
                                        path:
                                            widget.productData['productImage']),
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
                            returnRow("Product Name ",
                                "${widget.productData['productName']}", null),
                            returnRow("Product Des ",
                                "${widget.productData['productDes']}", null),
                            returnRow("Category ",
                                "${widget.productData['categoryType']}", null),
                            returnRow("Order Items ",
                                "${widget.orderData['orderItems']}", null),
                            returnRow(
                                "Delivered Address ",
                                "${widget.orderData['deliveredAddress']}",
                                null),
                            widget.index == 3 || widget.index == 4
                                ? returnRow(
                                    "TrackingID",
                                    "${widget.orderData['parcelTrackingID']}",
                                    4)
                                : Container(height: 0),
                            const SizedBox(height: 30),
                            widget.index == 3
                                ? GestureDetector(
                                    onTap: () async {
                                      // if (formKey.currentState!.validate()) {
                                      Components.showAlertDialog(context);

                                      await FirebaseFirestore.instance
                                          .collection("Order")
                                          .doc(widget.orderData['orderID'])
                                          .update({
                                        "isDelivered": true,
                                        "parcelTrackingID": parcelTrackingIDC
                                            .text
                                            .toString()
                                            .trim(),
                                        "time": FieldValue.serverTimestamp(),
                                      }).whenComplete(
                                        () async {
                                          Components.showSnackBar(context,
                                              'Order Status Completed Successfully');
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      ).catchError((e) {
                                        Navigator.of(context).pop();
                                        Components.showSnackBar(
                                            context, e.toString());
                                      });
                                      // }
                                    },
                                    child: Container(
                                      width: 330,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff471a91),
                                            Color(0xff3cabff)
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Recived Order",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "CentraleSansRegular",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(height: 0),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 100,
                    width: 100,
                    color: AppColor.primaryColor,
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
                      String number = value; //set the number here
                      await FlutterPhoneDirectCaller.callNumber(number);
                    },
                    icon: const Icon(
                      Icons.call,
                      color: Colors.black,
                    ))
                : iconIndex == 2
                    ? IconButton(
                        onPressed: () {
                          whatsapp(value);
                        },
                        icon: const Icon(
                          LineAwesomeIcons.what_s_app,
                          color: Colors.black,
                        ))
                    : iconIndex == 4
                        ? IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: value))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Copied to your clipboard !')));
                              });
                            },
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.black,
                            ))
                        : null);

    // Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [

    //       Expanded(child: Text(value))
    //     ],
    //   ),
    // );
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
