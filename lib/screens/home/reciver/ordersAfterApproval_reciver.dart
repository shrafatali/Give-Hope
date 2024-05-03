import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/reciver/ordersAfterApproval_reciver1.dart';

class OrderAfterApprovalReciver extends StatefulWidget {
  const OrderAfterApprovalReciver({Key? key}) : super(key: key);

  @override
  State<OrderAfterApprovalReciver> createState() =>
      _OrderAfterApprovalReciverState();
}

class _OrderAfterApprovalReciverState extends State<OrderAfterApprovalReciver> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const SizedBox(height: 0, width: 0),
          title: Text(
            'Orders',
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
              Tab(text: 'Pend'),
              Tab(text: 'Appr'),
              Tab(text: 'Rej'),
              Tab(text: 'Ship'),
              Tab(text: 'Comp'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderAfterApprovalReciver1(
                index: 0,
                adminApprove: false,
                adminReject: false,
                isShipped: false,
                isDelivered: false),
            OrderAfterApprovalReciver1(
                index: 1,
                adminApprove: true,
                adminReject: false,
                isShipped: false,
                isDelivered: false),
            OrderAfterApprovalReciver1(
                index: 2,
                adminApprove: false,
                adminReject: true,
                isShipped: false,
                isDelivered: false),
            OrderAfterApprovalReciver1(
                index: 3,
                adminApprove: true,
                adminReject: false,
                isShipped: true,
                isDelivered: false),
            OrderAfterApprovalReciver1(
                index: 4,
                adminApprove: true,
                adminReject: false,
                isShipped: true,
                isDelivered: true),
          ],
        ),
      ),
    );
  }
}
