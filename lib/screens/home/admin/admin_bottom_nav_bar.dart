// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/admin/AdminShowAllUsersPage.dart';
import 'package:give_hope/screens/home/admin/adminHomePage.dart';
import 'package:give_hope/screens/home/admin_profile.dart';
import 'package:give_hope/screens/home/admin/product_for_approval.dart';
import 'package:give_hope/screens/home/show_all_doners.dart';

class AdminBottomNavBarPage extends StatefulWidget {
  int index;
  AdminBottomNavBarPage({required this.index, super.key});

  @override
  State<AdminBottomNavBarPage> createState() => _AdminBottomNavBarPageState();
}

class _AdminBottomNavBarPageState extends State<AdminBottomNavBarPage> {
  int pageIndex = 0;

  final pages = [
    const AdminHomePage(),
    const AdminShowAllUsersPage(),
    const ProductForApprovalScreen(),
    const ShowAllDonersOnMapScreen(),
    AdminProfilePage(userType: "admin"),
  ];

  @override
  void initState() {
    pageIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.primaryColor,
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColor.pagesColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? Icon(
                      FontAwesome.home,
                      color: AppColor.primaryColor,
                      size: 30,
                    )
                  : Icon(
                      FontAwesome.home,
                      color: AppColor.blackColor,
                      size: 25,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? Icon(
                      FontAwesome.user_times,
                      color: AppColor.primaryColor,
                      size: 30,
                    )
                  : Icon(
                      FontAwesome.user_times,
                      color: AppColor.blackColor,
                      size: 25,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? Icon(
                      FontAwesome.list_alt,
                      color: AppColor.primaryColor,
                      size: 30,
                    )
                  : Icon(
                      FontAwesome.list_alt,
                      color: AppColor.blackColor,
                      size: 25,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? Icon(
                      FontAwesome.map_marker,
                      color: AppColor.primaryColor,
                      size: 30,
                    )
                  : Icon(
                      FontAwesome.map_marker,
                      color: AppColor.blackColor,
                      size: 25,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 4;
                });
              },
              icon: pageIndex == 4
                  ? Icon(
                      FontAwesome.user,
                      color: AppColor.primaryColor,
                      size: 30,
                    )
                  : Icon(
                      FontAwesome.user,
                      color: AppColor.blackColor,
                      size: 25,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ////////////////////////////////////

// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});

//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }

// class _MenuScreenState extends State<MenuScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.blackColor,
//       // appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 30),
//         child: SettingsList(
//           sections: [
//             SettingsSection(
//               title: const Text('Common'),
//               tiles: <SettingsTile>[
//                 SettingsTile.navigation(
//                   leading: const Icon(Icons.home),
//                   title: const Text('Home'),
//                   // value: const Text('English'),
//                 ),
//                 SettingsTile.switchTile(
//                   onToggle: (value) {},
//                   initialValue: true,
//                   leading: const Icon(Icons.format_paint),
//                   title: const Text('Enable custom theme'),
//                 ),
//               ],
//             ),
//             SettingsSection(
//               title: const Text('Action'),
//               tiles: <SettingsTile>[
//                 SettingsTile.navigation(
//                   leading: const Icon(Icons.share),
//                   title: const Text('Share'),
//                   // value: const Text('English'),
//                   onPressed: (context) {
//                     //
//                   },
//                 ),
//                 SettingsTile.navigation(
//                   leading: const Icon(Icons.contact_support_rounded),
//                   title: const Text('Support & Help'),
//                   onPressed: (context) {
//                     //
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


