// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/admin/productApproval1.dart';

class ProductForApprovalScreen extends StatefulWidget {
  const ProductForApprovalScreen({Key? key}) : super(key: key);

  @override
  State<ProductForApprovalScreen> createState() =>
      _ProductForApprovalScreenState();
}

class _ProductForApprovalScreenState extends State<ProductForApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const SizedBox(height: 0, width: 0),
          title: Text(
            'Order Requests',
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
          bottom: const TabBar(
            dividerColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorPadding: EdgeInsets.all(5),
            tabs: <Widget>[
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Approved',
              ),
              Tab(
                text: 'Rejected',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProductApproval1(index: 0, adminApprove: false, adminReject: false),
            ProductApproval1(index: 1, adminApprove: true, adminReject: false),
            ProductApproval1(index: 1, adminApprove: false, adminReject: true),
          ],
        ),
      ),
    );
  }
}
