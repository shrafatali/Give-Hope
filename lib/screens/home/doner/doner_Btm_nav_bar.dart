// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/admin/admin_profile.dart';
import 'package:give_hope/screens/home/doner/bottomNavBar/OrdersAfterApproval/doner_home_page.dart';
import 'package:give_hope/screens/home/doner/bottomNavBar/product_orders_after_approval.dart';
import 'package:give_hope/screens/home/doner/bottomNavBar/upload_product_screen.dart';

class DonerBottomNavBarPage extends StatefulWidget {
  int index;
  DonerBottomNavBarPage({required this.index, super.key});

  @override
  State<DonerBottomNavBarPage> createState() => _DonerBottomNavBarPageState();
}

class _DonerBottomNavBarPageState extends State<DonerBottomNavBarPage> {
  int pageIndex = 0;

  final pages = [
    const DonerHomeScreen(),
    const UploadProductScreen(),
    const ProductOrderAfterApprovalScreen(),
    AdminProfilePage(
      userType: "doner",
    ),
  ];

  @override
  void initState() {
    pageIndex = widget.index;
    pageIndex = 0;
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
                      FontAwesome.upload,
                      color: AppColor.primaryColor,
                      size: 30,
                    )
                  : Icon(
                      FontAwesome.upload,
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
                      Icons.format_list_bulleted_rounded,
                      color: AppColor.primaryColor,
                      size: 30,
                    )
                  : Icon(
                      Icons.format_list_bulleted_rounded,
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
