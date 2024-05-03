import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/auth/login_screen.dart';
import 'package:give_hope/screens/home/admin/admin_bottom_nav_bar.dart';
import 'package:give_hope/screens/home/doner/doner_Btm_nav_bar.dart';
import 'package:give_hope/screens/home/reciver/reciver_btm_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Constants.prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  // await FirebaseMessaging.instance.getInitialMessage();

  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  // PushNotification().requestPermission();
  // PushNotification().loadFCM();
  // PushNotification().listenFCM();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Give Hope',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff3cabff)),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser != null &&
              Constants.prefs!.getString("userType") == 'Admin'
          ? AdminBottomNavBarPage(index: 0)
          : FirebaseAuth.instance.currentUser != null &&
                  Constants.prefs!.getString("userType") == 'Doner'
              ? DonerBottomNavBarPage(index: 0)
              : FirebaseAuth.instance.currentUser != null &&
                      Constants.prefs!.getString("userType") == 'Reciver'
                  ? ReciverBtmNavBarPage(index: 0)
                  : const LoginScreen(),
    );
  }
}
