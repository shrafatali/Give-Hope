// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/components/show_zoom_image.dart';
import 'package:give_hope/screens/home/admin/admin_bottom_nav_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class DonerDetailsPage extends StatefulWidget {
  var donerData;
  DonerDetailsPage({required this.donerData, super.key});

  @override
  State<DonerDetailsPage> createState() => _DonerDetailsPageState();
}

class _DonerDetailsPageState extends State<DonerDetailsPage> {
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
          'Doner Details',
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
                  backgroundImage:
                      widget.donerData['profileImageLink'].toString() == '0'
                          ? const NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU",
                            )
                          : NetworkImage(widget.donerData['profileImageLink']),
                ),
              ),
              const SizedBox(height: 10),
              returnRow("Name ", "${widget.donerData['userName']}", null),
              returnRow("Email", "${widget.donerData['userEmail']}", 0,
                  userEmail: "${widget.donerData['userEmail']}"),
              returnRow(
                  "Mobile Number ", "${widget.donerData['phoneNumber']}", 1),
              returnRow(
                  "WhatsApp Number ", "${widget.donerData['wPhoneNumber']}", 2),
              returnRow("Type ", "${widget.donerData['userType']}", null),
              returnRow(
                  "Occupation ", "${widget.donerData['occupation']}", null),
              returnRow("Address ", "${widget.donerData['address']}", null),
              returnRow("LatLong ", "${widget.donerData['latLong']}", 3),
              returnRow("Gender ", "${widget.donerData['gender']}", null),
              returnRow("Description ", "${widget.donerData['bio']}", null),
              returnRow("CNIC No. ", "${widget.donerData['CnicNo']}", null),
              Text(
                "CNIC Front",
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              showImage(widget.donerData['cnicFront'], "CNIC Front"),
              const SizedBox(height: 20),
              Text(
                "CNIC Back",
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              showImage(widget.donerData['cnicBack'], "CNIC Back"),
              const SizedBox(height: 20),
              Text(
                "Work Image",
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              showImage(widget.donerData['workImage'], "Work Image"),
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

  showImage(String url, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowZoomImagePage(title: title, path: url),
          ),
        );
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: url,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                color: AppColor.primaryColor,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
              .doc(widget.donerData['userUID'].toString())
              .update({
            'adminApprove': true,
          }).then((value) {
            Components.showSnackBar(context, "Request Approved Successfully");
            remarksC.clear();
            // Navigator.pop(context);
            // Navigator.of(context).pop();
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
                .doc(widget.donerData['userUID'].toString())
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
