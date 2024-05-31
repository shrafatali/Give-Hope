// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/doner/doner_Btm_nav_bar.dart';
import 'package:give_hope/utils/helper.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getUserData();
  }

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
        print(value['adminApprove'].toString());

        nameC.text = data!['userName'].toString();
        emailC.text = data!['userEmail'].toString();
        if (value['adminApprove'] == true) {
          Constants.prefs!.setBool("adminApprove", true);
          getLocation();
        } else if (value['donerFormFild'] == false) {
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

  final formKey = GlobalKey<FormState>();
  TextEditingController pNameC = TextEditingController();
  TextEditingController pDesC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController latLongC = TextEditingController();
  TextEditingController totalItemsC = TextEditingController();

  File? workImage;

  String productType = "Books";

  // String city = "Islamabad";

  /////////////////////////////////////////////

  TextEditingController nameC = TextEditingController();
  TextEditingController numberC = TextEditingController();
  TextEditingController wNumberC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController cnicC = TextEditingController();
  // TextEditingController cityC = TextEditingController();
  // TextEditingController addressC = TextEditingController();
  TextEditingController bioC = TextEditingController();

  File? profileimage;
  File? cnicFrontImage;
  File? cnicBackImage;
  // File? workImage;

  // SampleItem? selectedMenu;
  // String? selectMenuuu;
  String? errorMessage;

  String genderC = "Male";
  int genderValue = 0;

  String occupationsName = "Doctor";

  String city = "Islamabad";

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
        : Constants.prefs!.getBool("adminApprove") == true
            ? Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  leading: const SizedBox(height: 0, width: 0),
                  title: Text(
                    'Upload Product',
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
                        colors: [
                          Color(0xff471a91),
                          Color(0xff3cabff),
                        ],
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
                        const SizedBox(width: 15, height: 20),
                        TextFormField(
                          controller: pNameC,
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Product Name is Empty';
                            }
                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
                          readOnly: false,
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
                              labelText: "Product Name",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: pDesC,
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Product Description is Empty';
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
                              labelText: "Product Description*",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(height: 5),
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
                          maxLines: 5,
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
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: const Text(
                            "What you want to donate*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: "CentraleSansRegular"),
                          ),
                          subtitle: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.black12),
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton(
                              value: productType,
                              underline: Container(),
                              iconSize: 25,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: donationCategoryList1.map((items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        // fontWeight: FontWeight.bold,
                                        fontFamily: "CentraleSansRegular"),
                                  ),
                                  onTap: () {
                                    // if (productType == "Blood") {
                                    // totalItemsC.text = " ";
                                    // } else {
                                    //   totalItemsC.clear();
                                    // }
                                    setState(() {
                                      productType = items.toString();
                                    });
                                  },
                                );
                              }).toList(),
                              onChanged: (value) {
                                //
                              },
                              // onChanged: (newValue) {
                              //   setState(() {
                              //     productType = newValue["name"].toString();
                              //   });
                              // },
                            ),
                          ),
                        ),
                        // productType != "Blood"
                        //     ?
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: totalItemsC,
                              validator: (String? value) {
                                if (value!.trim().isEmpty) {
                                  return 'Total Items is Empty';
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
                                  labelText: "Total Items*",
                                  labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: "CentraleSansRegular")),
                            ),
                          ],
                        ),
                        // : const SizedBox(height: 0, width: 0),
                        const SizedBox(height: 10),
                        showImageListTile("Product Image*", workImage, 4),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            if (city.trim().toString().isNotEmpty) {
                              if (formKey.currentState!.validate()) {
                                if (workImage != null) {
                                  Components.showAlertDialog(context);
                                  String workI =
                                      await uploadImage(workImage!, "Product");
                                  String productID = DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString();

                                  await FirebaseFirestore.instance
                                      .collection("Product")
                                      .doc(productID.toString())
                                      .set({
                                    "productID": productID.toString(),
                                    "userUID": FirebaseAuth
                                        .instance.currentUser!.uid
                                        .toString(),
                                    'productName':
                                        pNameC.text.toString().trim(),
                                    'productDes': pDesC.text.toString().trim(),
                                    "address":
                                        "${city.toString()}, ${addressC.text.trim().toString()}",
                                    'latLong': latLongC.text.trim().toString(),
                                    "categoryType": productType,
                                    "totalItems":
                                        int.parse(totalItemsC.text.trim()),
                                    "availableItems":
                                        int.parse(totalItemsC.text.trim()),
                                    'productImage': workI
                                  }).whenComplete(
                                    () {
                                      Components.showSnackBar(context,
                                          'Product Saved Successfully');
                                      Navigator.pop(context);

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DonerBottomNavBarPage(
                                                    index: 1)),
                                      );
                                    },
                                  ).catchError((e) {
                                    Navigator.of(context).pop();
                                    Components.showSnackBar(
                                        context, e.toString());
                                  });
                                } else {
                                  Components.showSnackBar(
                                      context, "Please Pick Work Photo.");
                                }
                              } else {
                                Components.showSnackBar(
                                    context, "Please Fill Form Correctly");
                              }
                            } else {
                              Components.showSnackBar(context, "City is Empty");
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
            : Constants.prefs!.getBool("adminApprove") == false &&
                    data!["donerFormFild"] == false
                ? Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      leading: const SizedBox(height: 0, width: 0),
                      title: Text(
                        'Doner Form',
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                        onChanged: (newValue) => setState(
                                            () => genderValue = newValue!),
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
                                        onChanged: (newValue) => setState(
                                            () => genderValue = newValue!),
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
                                        onChanged: (newValue) => setState(
                                            () => genderValue = newValue!),
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
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              title: const Text(
                                "Select Occupation*",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "CentraleSansRegular"),
                              ),
                              subtitle: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.black12),
                                    borderRadius: BorderRadius.circular(5)),
                                child: DropdownButton(
                                  value: occupationsName,
                                  underline: Container(),
                                  iconSize: 25,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: occupationsList.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: "CentraleSansRegular"),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      occupationsName = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: bioC,
                              validator: (String? value) {
                                if (value!.trim().isEmpty) {
                                  return 'Bio is Empty';
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
                                  labelText: "Bio*",
                                  labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: "CentraleSansRegular")),
                            ),
                            const SizedBox(height: 10),
                            showImageListTile(
                                "CNIC Front Image*", cnicFrontImage, 2),
                            const SizedBox(height: 10),
                            showImageListTile(
                                "CNIC Back Image*", cnicBackImage, 3),
                            const SizedBox(height: 10),
                            showImageListTile("Work Image*", workImage, 4),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  if (numberC.text.isNotEmpty &&
                                      wNumberC.text
                                          .toString()
                                          .trim()
                                          .isNotEmpty &&
                                      cnicC.text
                                          .trim()
                                          .toString()
                                          .trim()
                                          .isNotEmpty) {
                                    if (city.trim().toString().isNotEmpty) {
                                      if (formKey.currentState!.validate()) {
                                        if (profileimage != null) {
                                          if (cnicFrontImage != null &&
                                              cnicBackImage != null) {
                                            if (workImage != null) {
                                              CoolAlert.show(
                                                context: context,
                                                backgroundColor:
                                                    AppColor.primaryColor,
                                                confirmBtnColor:
                                                    AppColor.primaryColor,
                                                barrierDismissible: false,
                                                type: CoolAlertType.confirm,
                                                text: 'Submit Data...',
                                                onConfirmBtnTap: () async {
                                                  Navigator.of(context).pop();
                                                  FocusScope.of(context)
                                                      .unfocus();

                                                  Components.showAlertDialog(
                                                      context);
                                                  String profileI =
                                                      await uploadImage(
                                                          profileimage!,
                                                          "Doner");
                                                  String cnicf =
                                                      await uploadImage(
                                                          cnicFrontImage!,
                                                          "Doner");
                                                  String cnicb =
                                                      await uploadImage(
                                                          cnicBackImage!,
                                                          "Doner");
                                                  String workI =
                                                      await uploadImage(
                                                          workImage!, "Doner");

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("User")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid
                                                          .toString())
                                                      .update({
                                                    'phoneNumber': numberC.text
                                                        .toString()
                                                        .trim(),
                                                    'wPhoneNumber': wNumberC
                                                        .text
                                                        .toString()
                                                        .trim(),
                                                    "CnicNo": cnicC.text
                                                        .toString()
                                                        .trim(),
                                                    'profileImageLink':
                                                        profileI,
                                                    'donerFormFild': true,
                                                    'adminApprove': false,
                                                    "fcm_token": "",
                                                    'gender': genderC,
                                                    "address":
                                                        "${city.toString()}, ${addressC.text.trim().toString()}",
                                                    "occupation":
                                                        occupationsName
                                                            .toString()
                                                            .trim(),
                                                    'cnicFront': cnicf,
                                                    'cnicBack': cnicb,
                                                    'workImage': workI,
                                                    'bio': bioC.text
                                                        .trim()
                                                        .toString(),
                                                    'latLong': latLongC.text
                                                        .trim()
                                                        .toString(),
                                                  }).whenComplete(
                                                    () {
                                                      Constants.prefs!.setBool(
                                                          "donerFormFild",
                                                          true);
                                                      Constants.prefs!.setBool(
                                                          "adminApprove",
                                                          false);
                                                      Components.showSnackBar(
                                                          context,
                                                          'Your Data Saved Successfully');
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DonerBottomNavBarPage(
                                                                      index:
                                                                          2)),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                    },
                                                  ).catchError((e) {
                                                    Navigator.of(context).pop();
                                                    Components.showSnackBar(
                                                        context, e.toString());
                                                  });
                                                },
                                                confirmBtnText: 'OK',
                                                showCancelBtn: true,
                                              );
                                            } else {
                                              Components.showSnackBar(context,
                                                  "Please Pick Work Photo.");
                                            }
                                          } else {
                                            Components.showSnackBar(context,
                                                "Please Pick CNIC Front and Back Photos");
                                          }
                                        } else {
                                          Components.showSnackBar(context,
                                              "Please add profile Photo");
                                        }
                                      } else {
                                        Components.showSnackBar(context,
                                            "Please Fill Form Correctly");
                                      }
                                    } else {
                                      Components.showSnackBar(
                                          context, "City is Empty");
                                    }
                                  } else {
                                    Components.showSnackBar(
                                        context, "Please Fill Form Correctly");
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
                                    colors: [
                                      Color(0xff471a91),
                                      Color(0xff3cabff)
                                    ],
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
                : Constants.prefs!.getBool("adminApprove") == false &&
                        data!["donerFormFild"] == true
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
                                            // Components.showSnackBar(context,
                                            //     'Your Data Saved Successfully');
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DonerBottomNavBarPage(
                                                            index: 2)),
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                        ).catchError((e) {
                                          Navigator.of(context).pop();
                                          //   Components.showSnackBar(context, e.toString());
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
      } else if (imgIndex == 2) {
        cnicFrontImage = File(file.path.toString());
      } else if (imgIndex == 3) {
        cnicBackImage = File(file.path.toString());
      } else if (imgIndex == 4) {
        workImage = File(file.path.toString());
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
