// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/auth/login_screen.dart';
import 'package:give_hope/screens/home/admin/about_us.dart';
import 'package:give_hope/screens/home/admin/admin_bottom_nav_bar.dart';
import 'package:give_hope/screens/home/contact_us.dart';
import 'package:give_hope/screens/home/feedbacks.dart';
import 'package:give_hope/screens/home/admin/gallery.dart';
import 'package:give_hope/screens/home/chat_bot.dart';
import 'package:give_hope/screens/home/doner/doner_Btm_nav_bar.dart';
import 'package:give_hope/screens/home/reciver/reciver_btm_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class AdminProfilePage extends StatefulWidget {
  String userType;
  AdminProfilePage({required this.userType, Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  @override
  initState() {
    getData();

    super.initState();
  }

  var userData;
  String? imagePathProfile;

  @override
  Widget build(BuildContext context) {
    return userData != null
        ? Scaffold(
            // backgroundColor: AppColor.fonts,
            appBar: AppBar(
              centerTitle: true,
              leading: const SizedBox(height: 0, width: 0),
              title: Text(
                'Personal Information',
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
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Stack(
                          children: [
                            imagePathProfile != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundColor: AppColor.pagesColor,
                                    backgroundImage: FileImage(
                                      File(imagePathProfile!),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundColor: AppColor.pagesColor,
                                    backgroundImage:
                                        userData['profileImageLink']
                                                    .toString() ==
                                                '0'
                                            ? const NetworkImage(
                                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU",
                                              )
                                            : NetworkImage(
                                                userData['profileImageLink']),
                                  ),
                            Positioned(
                              right: 18,
                              child: _editIcon(),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['userName'],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                userData['userEmail'],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.chat,
                              color: AppColor.blackColor,
                              size: 19,
                            ),
                            title: const Text(
                              "ChatBot",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatBotScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          Divider(
                            color: AppColor.blackColor,
                            height: 2,
                          ),
                          const SizedBox(height: 5),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.feedback_rounded,
                              color: AppColor.blackColor,
                              size: 19,
                            ),
                            title: Text(
                              widget.userType == 'admin'
                                  ? 'View Feedbacks'
                                  : "Feedback",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FeedbackScreen(userType: widget.userType),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          Divider(
                            color: AppColor.blackColor,
                            height: 2,
                          ),
                          const SizedBox(height: 5),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.photo,
                              color: AppColor.blackColor,
                              size: 19,
                            ),
                            title: const Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GalleryScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          Divider(
                            color: AppColor.blackColor,
                            height: 2,
                          ),
                          const SizedBox(height: 5),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.info_outline_rounded,
                              color: AppColor.blackColor,
                              size: 19,
                            ),
                            title: const Text(
                              'About US',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () async {
                              // await FirebaseMessaging.instance
                              //     .getToken()
                              //     .then((value) {
                              //   print("Token : $value");
                              //   PushNotification().sendPushMessage(
                              //     "$value",
                              //     'Value',
                              //     'User Login1',
                              //   );
                              // });
                              //////////////////
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutUS(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          Divider(
                            color: AppColor.blackColor,
                            height: 2,
                          ),
                          const SizedBox(height: 5),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.contact_support,
                              color: AppColor.blackColor,
                              size: 19,
                            ),
                            title: const Text(
                              'Contact US',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ContactUS(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          Divider(
                            color: AppColor.blackColor,
                            height: 2,
                          ),
                          const SizedBox(height: 5),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.share_rounded,
                              color: AppColor.blackColor,
                              size: 19,
                            ),
                            title: const Text(
                              'Share',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () {
                              Share.share(
                                  'check out my application \n https://example.com');
                            },
                          ),
                          const SizedBox(height: 5),
                          Divider(
                            color: AppColor.blackColor,
                            height: 2,
                          ),
                          const SizedBox(height: 5),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(
                              Icons.logout,
                              color: AppColor.blackColor,
                              size: 19,
                            ),
                            title: const Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () {
                              CoolAlert.show(
                                context: context,
                                backgroundColor: AppColor.primaryColor,
                                confirmBtnColor: AppColor.primaryColor,
                                barrierDismissible: false,
                                type: CoolAlertType.confirm,
                                text: 'you want to Logout?',
                                onConfirmBtnTap: () async {
                                  Navigator.pop(context);
                                  Components.showAlertDialog(context);
                                  await FirebaseAuth.instance
                                      .signOut()
                                      .whenComplete(() {
                                    Timer(const Duration(seconds: 3), () {
                                      Constants.prefs!.clear();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(seconds: 1),
                                          transitionsBuilder: (BuildContext
                                                  context,
                                              Animation<double> animation,
                                              Animation<double> secAnimation,
                                              Widget child) {
                                            animation = CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.linear);
                                            return SharedAxisTransition(
                                                animation: animation,
                                                secondaryAnimation:
                                                    secAnimation,
                                                transitionType:
                                                    SharedAxisTransitionType
                                                        .horizontal,
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
                                    });
                                  });
                                },
                                confirmBtnText: 'Logout',
                                showCancelBtn: true,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            floatingActionButton: imagePathProfile != null
                ? FloatingActionButton.extended(
                    backgroundColor: AppColor.pagesColor,
                    onPressed: () async {
                      if (imagePathProfile != null) {
                        Components.showAlertDialog(context);

                        try {
                          String profileLink =
                              await uploadImage(File(imagePathProfile!));

                          await FirebaseFirestore.instance
                              .collection("User")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'profileImageLink': profileLink.toString(),
                          }).then((value) => Components.showSnackBar(
                                  context, "Profile Updated Sucessfully"));

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
                                if (widget.userType == 'admin') {
                                  return AdminBottomNavBarPage(index: 3);
                                } else if (widget.userType == "doner") {
                                  return DonerBottomNavBarPage(index: 3);
                                } else {
                                  return ReciverBtmNavBarPage(
                                      index: 2); // Default to login screen
                                }
                              },
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } catch (e) {
                          Navigator.pop(context);
                          print(e);

                          Components.showSnackBar(
                              context, "Profile Updated Failed");
                        }
                      }
                    },
                    label: Text(
                      "Save Profile",
                      style: TextStyle(
                        color: AppColor.blackColor,
                      ),
                    ),
                  )
                : null,
          )
        : Scaffold(
            // backgroundColor: AppColor.primaryColor,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),
          );
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        userData = value;
      });
      print('Value $userData');
    }).then((value) {
      setState(() {});
    });
  }

  _editIcon() {
    return InkWell(
      onTap: () {
        pickImage();
      },
      child: Icon(
        FontAwesome.edit,
        size: 20,
        color: AppColor.blackColor,
      ),
    );
  }

  Future pickImage() {
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
                          pickMedia(ImageSource.camera);
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
                        pickMedia(ImageSource.gallery);
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

  // XFile? file;
  void pickMedia(ImageSource source) async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: source);

    if (file != null) {
      setState(() {
        imagePathProfile = file.path;
      });
    }
  }

  Future uploadImage(File imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    String postId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = storage.ref().child("Profileimages/$postId");

    await reference.putFile(imagePath);
    String downloadsUrlImage = await reference.getDownloadURL();
    print(downloadsUrlImage);
    return downloadsUrlImage;
  }
}
