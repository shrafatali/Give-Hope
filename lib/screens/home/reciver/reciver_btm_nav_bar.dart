// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/admin/admin_profile.dart';
import 'package:give_hope/screens/home/reciver/girdDashboard.dart';
import 'package:give_hope/screens/home/reciver/ordersAfterApproval_reciver.dart';

class ReciverBtmNavBarPage extends StatefulWidget {
  int index;
  ReciverBtmNavBarPage({required this.index, super.key});

  @override
  State<ReciverBtmNavBarPage> createState() => _ReciverBtmNavBarPageState();
}

class _ReciverBtmNavBarPageState extends State<ReciverBtmNavBarPage> {
  int pageIndex = 0;

  final pages = [
    const GridDashboard(),
    const OrderAfterApprovalReciver(),
    AdminProfilePage(userType: "user"),
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
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
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
