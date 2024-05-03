// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/auth/signup_screen.dart';
import 'package:give_hope/screens/home/admin/admin_bottom_nav_bar.dart';
import 'package:give_hope/screens/home/doner/doner_Btm_nav_bar.dart';
import 'package:give_hope/screens/home/reciver/reciver_btm_nav_bar.dart';
import 'package:give_hope/utils/helper.dart';

enum SampleItem { admin, doner, reciver }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage;
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  SampleItem? selectedMenu = SampleItem.doner;
  String? selectMenuuu = 'Doner';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<SampleItem>(
            initialValue: selectedMenu,
            onSelected: (SampleItem item) {
              setState(() {
                selectedMenu = item;
                print("Selected : $selectedMenu");
              });
              if (selectedMenu == SampleItem.admin) {
                selectMenuuu = 'Admin';
              } else if (selectedMenu == SampleItem.doner) {
                selectMenuuu = 'Doner';
              } else if (selectedMenu == SampleItem.reciver) {
                selectMenuuu = 'Reciver';
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
              const PopupMenuItem<SampleItem>(
                value: SampleItem.admin,
                child: Text('Admin'),
              ),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.doner,
                child: Text('Doner'),
              ),
              const PopupMenuItem<SampleItem>(
                value: SampleItem.reciver,
                child: Text('Reciver'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Center(
                  child: Components.showAppLogo(context),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          "Welcome ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "CentraleSansRegular"),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          '$selectMenuuu!',
                          style: TextStyle(
                              fontSize: 20,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "CentraleSansRegular"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailC,
                validator: (value) => Helper.validateEmail(value),
                style: const TextStyle(
                    color: Colors.black, fontFamily: "CentraleSansRegular"),
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
                controller: passwordC,
                obscureText: isPasswordVisible,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: (value) =>
                //     Helper.validatePassword1(value!, passwordC.text),
                style: const TextStyle(
                    color: Colors.black, fontFamily: "CentraleSansRegular"),
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColor.blackColor.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
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
                    labelText: "Password",
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "CentraleSansRegular")),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  print("CLICK");
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    try {
                      selectMenuuu = selectMenuuu ?? 'Admin';
                      Components.showAlertDialog(context);
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: emailC.text.trim().toLowerCase(),
                        password: passwordC.text.trim(),
                      )
                          .then((result) async {
                        print('Main :  $selectMenuuu');
                        print(FirebaseAuth.instance.currentUser);
                        await FirebaseFirestore.instance
                            .collection('User')
                            .doc(result.user!.uid)
                            .get()
                            .then((value) async {
                          print("USER TYPE : ${value['userType']}");
                          if (value['userType'] == 'Reciver' &&
                              selectMenuuu == 'Reciver') {
                            print('userType P :  $selectMenuuu');

                            await FirebaseMessaging.instance
                                .getToken()
                                .then((value) async {
                              await FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(result.user!.uid)
                                  .update({
                                'fcm_token': value,
                              });
                            });

                            Constants.prefs!
                                .setString('Username', value['userName']);
                            Constants.prefs!.setString("userUID",
                                FirebaseAuth.instance.currentUser!.uid);
                            Constants.prefs!
                                .setString("userType", value['userType']);
                            print(FirebaseAuth.instance.currentUser);

                            Components.showSnackBar(
                                context, "Login Sucessfully");
                            Get.offAll(() => ReciverBtmNavBarPage(index: 0));
                          } else if (value['userType'] == 'Doner' &&
                              selectMenuuu == 'Doner') {
                            print('userType D :  $selectMenuuu');

                            await FirebaseMessaging.instance
                                .getToken()
                                .then((value) async {
                              await FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(result.user!.uid)
                                  .update({
                                'fcm_token': value,
                              });
                            });

                            Constants.prefs!
                                .setString('Username', value['userName']);

                            Constants.prefs!
                                .setString('Email', value['userEmail']);
                            Constants.prefs!
                                .setString('PhoneNo', value['phoneNumber']);
                            Constants.prefs!.setString(
                                'ProfilePicture', value['profileImageLink']);
                            Constants.prefs!
                                .setString("userType", value['userType']);

                            print(FirebaseAuth.instance.currentUser);

                            Components.showSnackBar(
                                context, "Login Sucessfully");
                            Get.offAll(() => DonerBottomNavBarPage(index: 0));
                          } else if (value['userType'] == 'Admin' &&
                              selectMenuuu == 'Admin') {
                            print('userType P 1 :  $selectMenuuu');

                            Constants.prefs!
                                .setString('Username', value['userName']);
                            Constants.prefs!.setString("userUID",
                                FirebaseAuth.instance.currentUser!.uid);
                            Constants.prefs!
                                .setString("userType", value['userType']);
                            print(FirebaseAuth.instance.currentUser);

                            Components.showSnackBar(
                                context, "Login Sucessfully");
                            Get.offAll(() => AdminBottomNavBarPage(index: 0));
                          } else {
                            Navigator.of(context).pop();
                            Components.showSnackBar(context,
                                'You are not allowed to login from this panel');
                          }
                        }).catchError((e) async {
                          await FirebaseAuth.instance.signOut();
                          print("ERROR : ${e.toString()}");
                          Navigator.of(context).pop();
                          Components.showSnackBar(context,
                              'You are not allowed to login from this panel');
                        });
                      });
                    } catch (e) {
                      Navigator.pop(context);
                      print(e);
                      switch (e.toString()) {
                        case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
                          errorMessage = "User with this email doesn't exist.";
                          break;
                        case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
                          errorMessage = "Please Enter Correct Password.";
                          break;
                        case "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.":
                          errorMessage = "Please Check Internet Connection";
                          break;
                        case "[firebase_auth/invalid-email] The email address is badly formatted.":
                          errorMessage = "Please Enter Valid Email";
                          break;
                        default:
                          errorMessage = "An undefined Error happened.";
                          break;
                      }
                      Components.showSnackBar(context, errorMessage.toString());
                    }
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
                      "Login",
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
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'CentraleSansRegular',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                              fontFamily: 'CentraleSansRegular',
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
