// ignore_for_file: avoid_print, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/admin/nextPage/show_product_order_detail_admin.dart';

class ProductApproval1 extends StatefulWidget {
  int index;
  bool adminApprove;
  bool adminReject;

  ProductApproval1(
      {required this.index,
      required this.adminApprove,
      required this.adminReject,
      super.key});

  @override
  State<ProductApproval1> createState() => _ProductApproval1State();
}

class _ProductApproval1State extends State<ProductApproval1> {
  @override
  Widget build(BuildContext context) {
    return
        // Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child:
        StreamBuilder(
      stream: getAdminOrders(context, widget.adminApprove, widget.adminReject),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              )
            : snapshot.hasData
                ? snapshot.data!
                : Center(
                    child: Text(
                      'No Record Found',
                      style: TextStyle(
                        color: AppColor.blackColor,
                      ),
                    ),
                  );
      },
    );
    // )
  }

  Stream<Widget> getAdminOrders(
      context, bool adminApprove, bool adminReject) async* {
    List<Widget> x = [];
    await FirebaseFirestore.instance
        .collection('Order')
        .where('adminApprove', isEqualTo: adminApprove)
        .where('adminReject', isEqualTo: adminReject)
        .get()
        .then(
      (order) async {
        for (var orderData in order.docs) {
          //   print('productID ${orderData.data()['productID'].toString()}');

          await FirebaseFirestore.instance
              .collection('Product')
              .doc(orderData.data()['productID'])
              .get()
              .then((productData) async {
            // print('productData ${productData['productName'].toString()}');

            await FirebaseFirestore.instance
                .collection('User')
                .doc(orderData.data()['userUID'])
                .get()
                .then((userData) async {
              // print('userName ${userData['userName'].toString()}');

              await FirebaseFirestore.instance
                  .collection('User')
                  .doc(orderData.data()['donerUID'])
                  .get()
                  .then((donerData) async {
                // print('donerName ${donerData['userName'].toString()}');
                x.add(
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowProductOrderDetailsAdmin(
                                      userType: 0,
                                      index: widget.index,
                                      productData: productData,
                                      orderData: orderData,
                                      donerData: donerData,
                                      userData: userData)));
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: SizedBox(
                              height: 140,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl:
                                    productData['productImage'].toString(),
                                placeholder: (context, url) => SizedBox(
                                  height: 140,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: AppColor.primaryColor),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          ),
                          ListTile(
                            horizontalTitleGap: 7,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            title: Text(productData['productName']),
                            subtitle: Text(
                              productData["productDes"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(
                              Icons.arrow_right_rounded,
                              size: 20,
                              color: AppColor.blackColor,
                            ),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         DonerDetailsPage(donerData: documentData),
                              //   ),
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            });
          });
        }
      },
    );
    yield x.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: x.length,
            itemBuilder: (context, index) {
              return x[index];
            },
          )
        : Center(
            child: Text(
              'No Record Found',
              style: TextStyle(
                color: AppColor.blackColor,
              ),
            ),
          );
  }
}
