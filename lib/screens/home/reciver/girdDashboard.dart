// ignore_for_file: avoid_print

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/reciver/reciver_btm_nav_bar.dart';
import 'package:give_hope/screens/home/reciver/show_all_occuption_users.dart';
import 'package:give_hope/utils/helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

final List<String> imgList = [
  "assets/images/7.jpg",
  "assets/images/13.jpg",
  "assets/images/2.jpg",
  "assets/images/15.jpg",
  "assets/images/3.jpg",
  "assets/images/4.jpg",
  "assets/images/8.jpg",
  "assets/images/6.jpg",
  "assets/images/9.jpg",
  "assets/images/12.jpg",
  "assets/images/10.jpg",
  "assets/images/11.jpg",
  "assets/images/14.jpg",
  "assets/images/44.jpg",
  "assets/images/5.jpg",
];

class GridDashboard extends StatefulWidget {
  const GridDashboard({super.key});

  @override
  State<GridDashboard> createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  @override
  void initState() {
    super.initState();

    getUserData();
  }

  bool isLoading = false;
  File? profileimage;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameC = TextEditingController();
  TextEditingController numberC = TextEditingController();
  TextEditingController wNumberC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController cnicC = TextEditingController();

  TextEditingController monthlyIncomC = TextEditingController();
  TextEditingController sourceOfIncomC = TextEditingController();

  TextEditingController addressC = TextEditingController();
  TextEditingController latLongC = TextEditingController();

  String genderC = "Male";
  int genderValue = 0;

  getLocation() {
    try {
      Helper.getUserCurrentLocation().then((value) {
        latLongC.text = "${value![0]}, ${value[1]}";
        addressC.text = "${value[2]}";
        setState(() {});
        print("LOCATION : $value");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? data;

  getUserData() async {
    try {
      isLoading = true;
      await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .get()
          .then((value) {
        data = value;
        print(value.toString());
        // print(value['adminApprove'].toString());

        nameC.text = data!['userName'].toString();
        emailC.text = data!['userEmail'].toString();
        if (value['adminApprove'] == true) {
          Constants.prefs!.setBool("adminApprove", true);
          getLocation();
        } else if (value['reciverFormFild'] == false) {
          Constants.prefs!.setBool("adminApprove", false);
          getLocation();
        } else {
          Constants.prefs!.setBool("adminApprove", false);
        }
      });
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),
          )
        : Constants.prefs!.getBool("adminApprove") == false &&
                data!["reciverFormFild"] == false
            ? Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  leading: const SizedBox(height: 0, width: 0),
                  title: Text(
                    'Recipient Form',
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
                body: Container(
                  child: Form(
                    key: formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: <Widget>[
                        Center(
                          child: Stack(
                            // alignment: AlignmentDirectional.centerStart,
                            children: [
                              profileimage != null
                                  ? CircleAvatar(
                                      radius: 60,
                                      backgroundColor: AppColor.pagesColor,
                                      backgroundImage: FileImage(
                                        profileimage!,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundColor: AppColor.pagesColor,
                                      backgroundImage: const NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU",
                                      ),
                                    ),
                              Positioned(
                                right: 18,
                                child: _editIcon(1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15, height: 20),
                        TextFormField(
                          controller: nameC,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
                          readOnly: true,
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
                              labelText: "Name",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emailC,
                          readOnly: true,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
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
                              labelText: "Email",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: numberC,
                          validator: (value) {
                            if (value!.toString().trim().isEmpty) {
                              return 'Please Enter Phone Number';
                            } else if (value.trim().length < 10) {
                              return 'Please Valid Phone Number';
                            } else {
                              return null;
                            }
                          },
                          inputFormatters: [phoneNumberFormatter],
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
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
                              labelText: "Phone Number*",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: wNumberC,
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Please Enter Phone Number';
                            } else if (value.trim().length < 10) {
                              return 'Please Valid Phone Number';
                            } else {
                              return null;
                            }
                          },
                          inputFormatters: [phoneNumberFormatter],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
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
                              labelText: "WhatsApp Number*",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: cnicC,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please Enter CNUC Number';
                            } else if (value.trim().length < 13) {
                              return 'Please Valid CNIC Number';
                            } else {
                              return null;
                            }
                          },
                          inputFormatters: [cnicNumberFormatter],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
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
                              labelText: "CNIC Number*",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Gender*",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "CentraleSansRegular"),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    value: 0,
                                    groupValue: genderValue,
                                    title: const Text("Male"),
                                    onChanged: (newValue) =>
                                        setState(() => genderValue = newValue!),
                                    activeColor: AppColor.primaryColor,
                                    selected: false,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    value: 1,
                                    groupValue: genderValue,
                                    title: const Text("Female"),
                                    onChanged: (newValue) =>
                                        setState(() => genderValue = newValue!),
                                    activeColor: AppColor.primaryColor,
                                    selected: false,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    value: 2,
                                    groupValue: genderValue,
                                    title: const Text("Other"),
                                    onChanged: (newValue) =>
                                        setState(() => genderValue = newValue!),
                                    activeColor: AppColor.primaryColor,
                                    selected: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: addressC,
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Address is Empty';
                            }
                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
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
                              labelText: "Address*",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: latLongC,
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'LatLong is Empty';
                            }
                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
                          readOnly: true,
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
                              labelText: "Current Lat Long*",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: monthlyIncomC,
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'monthly incom is Empty';
                            }
                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
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
                              labelText: "Monthly Incom*",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: sourceOfIncomC,
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'incom source is Empty';
                            }
                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
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
                              labelText: "Source of Incoum*",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 50),
                        GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              if (profileimage != null) {
                                FocusScope.of(context).unfocus();

                                Components.showAlertDialog(context);
                                String profileI =
                                    await uploadImage(profileimage!, "Profile");

                                await FirebaseFirestore.instance
                                    .collection("User")
                                    .doc(FirebaseAuth.instance.currentUser!.uid
                                        .toString())
                                    .update({
                                  'phoneNumber': numberC.text.toString().trim(),
                                  'wPhoneNumber':
                                      wNumberC.text.toString().trim(),
                                  "CnicNo": cnicC.text.toString().trim(),
                                  'profileImageLink': profileI,
                                  'reciverFormFild': true,
                                  'adminApprove': false,
                                  'gender': genderC,
                                  "address": addressC.text.trim().toString(),
                                  "latLong": latLongC.text.toString().trim(),
                                  "monthlyIncom":
                                      monthlyIncomC.text.toString().trim(),
                                  "sourceOfIncom":
                                      sourceOfIncomC.text.toString().trim(),
                                }).whenComplete(
                                  () {
                                    Constants.prefs!
                                        .setBool("donerFormFild", true);
                                    Constants.prefs!
                                        .setBool("adminApprove", false);
                                    Components.showSnackBar(
                                        context, 'Data Saved Successfully');
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReciverBtmNavBarPage(index: 0)),
                                        (Route<dynamic> route) => false);
                                  },
                                ).catchError((e) {
                                  Navigator.of(context).pop();
                                  Components.showSnackBar(
                                      context, e.toString());
                                });
                              } else {
                                Components.showSnackBar(
                                    context, "Please add profile Photo");
                              }
                            } else {
                              Components.showSnackBar(
                                  context, "Please Fill Form Correctly");
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
                                "Submit",
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
              )
            : Constants.prefs!.getBool("adminApprove") == true
                ? Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          Container(
                              child: CarouselSlider(
                            options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 4),
                                scrollPhysics: const ScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                pageSnapping: true,
                                disableCenter: true),
                            items: imgList
                                .map((item) => Container(
                                      child: Center(
                                          child: Image.asset(item,
                                              fit: BoxFit.cover, width: 1000)),
                                    ))
                                .toList(),
                          )),
                          const SizedBox(height: 20),
                          Expanded(
                              child: GridView.count(
                            childAspectRatio: 1.0,
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            children: donationCategoryList
                                .map((Map<String, dynamic> data) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowAllOccuptionUser(
                                                  donationType: data["name"])));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.primaryColor
                                            .withOpacity(.5),
                                        blurRadius: 4,
                                        offset: const Offset(
                                            4, 8), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset("${data["image"]}",
                                          width: 42),
                                      const SizedBox(height: 14),
                                      Text(
                                        data["name"],
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                        ],
                      ),
                    ),
                  )
                : Constants.prefs!.getBool("adminApprove") == false &&
                        data!["reciverFormFild"] == true
                    ? Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              data!["remarks"] == ""
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Please  wait...",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  "CentraleSansRegular"),
                                        ),
                                        Text(
                                          "Your Request Is Pending. Please Wait For Approval.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily:
                                                  "CentraleSansRegular"),
                                        ),
                                      ],
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Remarks",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  "CentraleSansRegular"),
                                        ),
                                      ],
                                    ),
                              Visibility(
                                visible: data!["remarks"] != "" ? true : false,
                                child: Column(
                                  children: [
                                    Text('${data!["remarks"]}'),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () async {
                                        Components.showAlertDialog(context);

                                        await FirebaseFirestore.instance
                                            .collection("User")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString())
                                            .update({
                                          'donerFormFild': false,
                                          'adminApprove': false,
                                          'remarks': ""
                                        }).whenComplete(
                                          () {
                                            Constants.prefs!.setBool(
                                                "donerFormFild", false);
                                            Constants.prefs!
                                                .setBool("adminApprove", false);
                                          },
                                        ).catchError((e) {
                                          Navigator.of(context).pop();
                                        });
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
                                            "OK",
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
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Scaffold(backgroundColor: AppColor.primaryColor);
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No. ${imgList.indexOf(item)} image',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  Future pickImage(int imgIndex) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Center(child: Text("Where want you pick")),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: (() {
                          pickMedia(ImageSource.camera, imgIndex);
                          Navigator.pop(context);
                        }),
                        child: const Icon(Icons.camera_alt)),
                    const SizedBox(height: 5),
                    const Text("Camera")
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: (() {
                        pickMedia(ImageSource.gallery, imgIndex);
                        Navigator.pop(context);
                      }),
                      child: const Icon(Icons.photo),
                    ),
                    const SizedBox(height: 5),
                    const Text("Gallery")
                  ],
                ),
              ],
            ));
      },
    );
  }

  _editIcon(int imgIndex) {
    return InkWell(
      onTap: () {
        pickImage(imgIndex);
      },
      child: Icon(
        FontAwesome.edit,
        size: 20,
        color: AppColor.blackColor,
      ),
    );
  }

  // XFile? file;
  void pickMedia(ImageSource source, int imgIndex) async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: source);

    if (file != null) {
      if (imgIndex == 1) {
        profileimage = File(file.path.toString());
      }

      print("ImagePath $imgIndex : ${file.path.toString()}");
      setState(() {});
    }
  }

  Future uploadImage(File imagePath, String uploadPath) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    String postId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = storage.ref().child("$uploadPath/$postId");

    await reference.putFile(imagePath);
    String downloadsUrlImage = await reference.getDownloadURL();
    print(downloadsUrlImage);
    return downloadsUrlImage;
  }

  showImageListTile(String title, File? newImagePath, int imgIndex) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        title.toString(),
        style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: "CentraleSansRegular"),
      ),
      subtitle: GestureDetector(
        onTap: () async {
          pickImage(imgIndex);
        },
        child: newImagePath == null
            ? Container(
                height: 150,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.pagesColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 35,
                  color: AppColor.fonts.withOpacity(0.5),
                ),
              )
            : Container(
                height: 150,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.pagesColor,
                  image: DecorationImage(
                    image: FileImage(File(newImagePath.path.toString())),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
      ),
    );
  }
}
