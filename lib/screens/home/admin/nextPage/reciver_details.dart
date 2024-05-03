// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/admin/admin_bottom_nav_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ReciverDetailsPage extends StatefulWidget {
  var reciverData;
  ReciverDetailsPage({required this.reciverData, super.key});

  @override
  State<ReciverDetailsPage> createState() => _ReciverDetailsPageState();
}

class _ReciverDetailsPageState extends State<ReciverDetailsPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController remarksC = TextEditingController();
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
          'Recipient Details',
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
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColor.pagesColor,
                  backgroundImage: widget.reciverData['profileImageLink']
                              .toString() ==
                          '0'
                      ? const NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU",
                        )
                      : NetworkImage(widget.reciverData['profileImageLink']),
                ),
              ),
              const SizedBox(height: 10),
              returnRow("Name ", "${widget.reciverData['userName']}", null),
              returnRow("Email", "${widget.reciverData['userEmail']}", 0,
                  userEmail: "${widget.reciverData['userEmail']}"),
              returnRow("Gender ", "${widget.reciverData['gender']}", null),
              returnRow(
                  "Mobile Number ", "${widget.reciverData['phoneNumber']}", 1),
              returnRow("WhatsApp Number ",
                  "${widget.reciverData['wPhoneNumber']}", 2),
              // returnRow("Type ", "${widget.reciverData['userType']}", null),
              returnRow("Monthly Incom ",
                  "${widget.reciverData['monthlyIncom']}", null),
              returnRow("Source of Incom",
                  "${widget.reciverData['sourceOfIncom']}", null),
              returnRow("Address ", "${widget.reciverData['address']}", null),
              returnRow("LatLong ", "${widget.reciverData['latLong']}", 3),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showAlertDialogReject(context);
                    },
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(TextStyle(
                          color: AppColor.whiteColor,
                        )),
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    child: Text(
                      "Reject",
                      style: TextStyle(color: AppColor.whiteColor),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      showAlertDialogApproved(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 2.0, color: Colors.green),
                    ),
                    child: const Text(
                      "Approved",
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
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
        trailing: iconIndex == 0
            ? IconButton(
                onPressed: () async {
                  final Email email = Email(
                    body: 'Email body',
                    subject: 'Email subject',
                    recipients: ['$userEmail'],
                    cc: [],
                    bcc: [],
                    attachmentPaths: [],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(email);
                },
                icon: const Icon(
                  Icons.email_rounded,
                  color: Colors.black,
                ))
            : iconIndex == 1
                ? IconButton(
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber(value);
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
                    : iconIndex == 3
                        ? IconButton(
                            onPressed: () {
                              List list = value.split(",");
                              MapsLauncher.launchCoordinates(
                                  double.parse(list[0].toString().trim()),
                                  double.parse(list[1].toString().trim()));
                            },
                            icon: const Icon(
                              LineAwesomeIcons.map,
                              color: Colors.black,
                            ))
                        : null);
  }

  showAlertDialogApproved(BuildContext context) {
    Widget cancelButton = TextButton(
        child: const Text("No"),
        onPressed: () async {
          remarksC.clear();
          Navigator.pop(context);
        });
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        try {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          Components.showAlertDialog(context);

          await FirebaseFirestore.instance
              .collection("User")
              .doc(widget.reciverData['userUID'].toString())
              .update({
            'adminApprove': true,
          }).then((value) {
            Components.showSnackBar(context, "Request Approved Successfully");
            remarksC.clear();
            Get.offAll(() => AdminBottomNavBarPage(index: 1));
          }).catchError((e) {
            Navigator.of(context).pop();
            Components.showSnackBar(context, e.toString());
          });
        } catch (e) {
          print(e.toString());
        }
      },
    );

    // show the dialog
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Are You Soure you want to Approved?",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            cancelButton,
            okButton,
          ],
        );
      },
    );
  }

  showAlertDialogReject(BuildContext context) {
    Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () async {
          remarksC.clear();
          Navigator.pop(context);
        });
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Submit"),
      onPressed: () async {
        if (remarksC.text.trim().isNotEmpty) {
          try {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
            Components.showAlertDialog(context);

            await FirebaseFirestore.instance
                .collection("User")
                .doc(widget.reciverData['userUID'].toString())
                .update({
              'adminApprove': false,
              'remarks': remarksC.text.trim().toString()
            }).then((value) {
              Components.showSnackBar(context, "Request Reject Successfully");
              remarksC.clear();
              Navigator.pop(context);
              Navigator.of(context).pop();
            }).catchError((e) {
              Navigator.of(context).pop();
              Components.showSnackBar(context, e.toString());
            });
          } catch (e) {
            print(e.toString());
          }
        } else {
          Components.showSnackBar(context, "please enter some reasons");
        }
      },
    );

    // show the dialog
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Are You Soure you want to reject?",
            style: TextStyle(fontSize: 14),
          ),
          content: Form(
            // key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: remarksC,
                  minLines: 1,
                  maxLines: 5,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter some reasons';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    // filled: true,
                    // fillColor: AppColor.secondary.withOpacity(0.25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      // borderSide: BorderSide.merge(2, b),
                    ),
                    hintText: 'Add Reason',
                    hintStyle: TextStyle(
                      color: AppColor.fonts.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            cancelButton,
            okButton,
          ],
        );
      },
    );
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
