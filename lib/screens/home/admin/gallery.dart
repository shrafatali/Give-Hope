import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/reciver/ordersAfterApproval_reciver1.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
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
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          'Gallery',
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
      body: OrderAfterApprovalReciver1(
          index: 5,
          adminApprove: true,
          adminReject: false,
          isShipped: true,
          isDelivered: true),
    );
  }
}
