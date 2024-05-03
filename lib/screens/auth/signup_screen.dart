// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/auth/login_screen.dart';
import 'package:give_hope/utils/helper.dart';

enum SampleItem { doner, reciver }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController fNameC = TextEditingController();
  TextEditingController lNameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController otpC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  bool isPasswordVisible = true;

  SampleItem? selectedMenu = SampleItem.doner;
  String? selectMenuuu = "Doner";
  String? errorMessage;

  String genderC = "Male";
  int genderValue = 0;

  late EmailOTP emailAuth;

  bool reciveOTP = false;
  bool isLoading = false;
  bool showPasswordField = false;

  @override
  void initState() {
    super.initState();
    emailAuth = EmailOTP();
  }

  void sendOTP1() async {
    try {
      print(emailC.text.trim().toLowerCase().toString());
      // Components.showAlertDialog(context);
      setState(() {
        isLoading = true;
      });

      await emailAuth.setConfig(
          appEmail: "me@givehope.com",
          appName: "GiveHope",
          userEmail: emailC.text.toLowerCase().toString().trim(),
          otpLength: 6,
          otpType: OTPType.digitsOnly);
      var result = await emailAuth.sendOTP();

      // bool result = await emailAuth.sendOtp(
      //   recipientMail: emailC.text.toLowerCase().toString().trim(),
      //   otpLength: 6,
      // );

      print(result);

      if (result == true) {
        // Components.showSnackBar(context, 'OTP has been sent');
        setState(() {
          reciveOTP = true;
          isLoading = false;
        });
      } else {
        setState(() {
          reciveOTP = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    } finally {
      // Navigator.pop(context);
    }
  }

  void verify(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      bool result = await emailAuth.verifyOTP(
        otp: otpC.value.text.trim(),
      );

      // bool result = emailAuth.validateOtp(
      //   recipientMail: emailC.text.toLowerCase().toString().trim(),
      //   userOtp: otpC.value.text.trim(),
      // );

      print(result);

      if (result == true) {
        setState(() {
          isLoading = false;
          showPasswordField = true;
        });
        Components.showSnackBar(context, 'Email verification Successfully');
      } else {
        setState(() {
          isLoading = false;
        });
        Components.showSnackBar(context, 'Email verification Failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        bottomOpacity: 0,
        elevation: 0,
        actions: [
          PopupMenuButton<SampleItem>(
            initialValue: selectedMenu,
            onSelected: (SampleItem item) {
              setState(() {
                selectedMenu = item;
                print("Selected : $selectedMenu");
              });

              if (selectedMenu == SampleItem.doner) {
                selectMenuuu = 'Doner';
              } else if (selectedMenu == SampleItem.reciver) {
                selectMenuuu = 'Reciver';
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
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
      body: Container(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                  child: Components.showAppLogo(context),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          selectMenuuu == 'Reciver'
                              ? "Create Account As a  "
                              : "Register Yourself As a  ",
                          style: const TextStyle(
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
                controller: fNameC,
                style: const TextStyle(
                    color: Colors.black, fontFamily: "CentraleSansRegular"),
                validator: (value) => Helper.validateName(value!),
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
                    labelText: "First Name",
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "CentraleSansRegular")),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: lNameC,
                style: const TextStyle(
                    color: Colors.black, fontFamily: "CentraleSansRegular"),
                validator: (value) => Helper.validateName(value!),
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
                    labelText: "Last Name",
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "CentraleSansRegular")),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailC,
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
              Visibility(
                visible: reciveOTP == true && showPasswordField == false
                    ? true
                    : false,
                child: TextFormField(
                  controller: otpC,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Helper.validateOTP(value!),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Colors.black, fontFamily: "CentraleSansRegular"),
                  onChanged: (value) {
                    if (value.toString().trim().length == 6) {
                      verify(context);
                    }
                  },
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
                      labelText: "OTP",
                      labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "CentraleSansRegular")),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: true,
                // showPasswordField,
                child: TextFormField(
                  controller: passwordC,
                  obscureText: isPasswordVisible,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      Helper.validatePassword1(value!, passwordC.text),
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
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (selectMenuuu != null) {
                      FocusScope.of(context).unfocus();

                      // if (reciveOTP == false) {
                      //   sendOTP1();
                      // } else if (reciveOTP == true &&
                      //     showPasswordField == true) {
                      Components.showAlertDialog(context);
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailC.text.trim().toLowerCase(),
                                password: passwordC.text);

                        if (selectMenuuu == 'Doner') {
                          await FirebaseFirestore.instance
                              .collection("User")
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .set({
                            'userType': selectMenuuu,
                            'userUID': FirebaseAuth.instance.currentUser!.uid,
                            'userName':
                                "${fNameC.text.trim()} ${lNameC.text.trim()}",
                            'userEmail': emailC.text.toLowerCase().trim(),
                            'CnicNo': "",
                            'userPassword': passwordC.text.trim(),
                            'userConfirmPassword': passwordC.text.trim(),
                            'phoneNumber': '',
                            'wPhoneNumber': '',
                            'location': "",
                            'profileImageLink': "0",
                            'available': true,
                            'donerFormFild': false,
                            'adminApprove': false,
                            'bio': '',
                            'time': FieldValue.serverTimestamp(),
                            "fcm_token": "",
                            'gender': '',
                            'remarks': "",
                            "address": "",
                            "occupation": "",
                            'latLong': "",
                          }).then((value) => Components.showSnackBar(
                                  context, "Account Created Sucessfully"));
                        } else if (selectMenuuu == 'Reciver') {
                          await FirebaseFirestore.instance
                              .collection("User")
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .set({
                            'userType': selectMenuuu,
                            'userUID': FirebaseAuth.instance.currentUser!.uid,
                            'userName':
                                "${fNameC.text.trim()} ${lNameC.text.trim()}",
                            'userEmail': emailC.text.toLowerCase().trim(),
                            'userPassword': passwordC.text.trim(),
                            'userConfirmPassword': passwordC.text.trim(),
                            'phoneNumber': '',
                            'wPhoneNumber': '',
                            'profileImageLink': "0",
                            "monthlyIncom": "",
                            "sourceOfIncom": "",
                            'available': true,
                            'reciverFormFild': false,
                            'adminApprove': false,
                            "fcm_token": "",
                            'gender': '',
                            'latLong': "",
                            'CnicNo': "",
                            'bio': '',
                            'time': FieldValue.serverTimestamp(),
                            "address": "",
                            'remarks': "",
                          }).then((value) => Components.showSnackBar(
                                  context, "Account Created Sucessfully"));
                        }
                        Navigator.pop(context);

                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            transitionDuration: const Duration(seconds: 1),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              animation = CurvedAnimation(
                                  parent: animation, curve: Curves.linear);
                              return SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.horizontal,
                                  child: child);
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation) {
                              return const LoginScreen();
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        print(e);

                        switch (e.toString()) {
                          case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
                            errorMessage =
                                "The email address is already in use by another account";
                            break;
                          case "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.":
                            errorMessage = "Please Check Internet Connection";
                            break;
                          case "[firebase_auth/invalid-email] The email address is badly formatted.":
                            "Please Enter Valid Email";
                            break;
                          default:
                            errorMessage = "Sign Up failed, Please try again.";
                            break;
                        }
                        Components.showSnackBar(
                            context, errorMessage.toString());
                      }
                    }
                  } else {
                    Components.showSnackBar(context, "Please Select Your Role");
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
                      // reciveOTP == false ? "Send OTP" :
                      "Sign Up",
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
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontFamily: 'CentraleSansRegular',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
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
