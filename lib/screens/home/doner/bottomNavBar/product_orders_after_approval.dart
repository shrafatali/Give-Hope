import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/doner/bottomNavBar/OrdersAfterApproval/ordersAfterApproval_doner1.dart';

class ProductOrderAfterApprovalScreen extends StatefulWidget {
  const ProductOrderAfterApprovalScreen({Key? key}) : super(key: key);

  @override
  State<ProductOrderAfterApprovalScreen> createState() =>
      _ProductOrderAfterApprovalScreenState();
}

class _ProductOrderAfterApprovalScreenState
    extends State<ProductOrderAfterApprovalScreen> {
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
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Shipped',
              ),
              Tab(
                text: 'Completed',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderAfterApprovalDoner1(
                index: 0, isShipped: false, isDelivered: false),
            OrderAfterApprovalDoner1(
                index: 1, isShipped: true, isDelivered: false),
            OrderAfterApprovalDoner1(
                index: 1, isShipped: true, isDelivered: true),
          ],
        ),
      ),
    );
  }
}
