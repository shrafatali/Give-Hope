import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';

class DonerHomeScreen extends StatefulWidget {
  const DonerHomeScreen({super.key});

  @override
  State<DonerHomeScreen> createState() => _DonerHomeScreenState();
}

class _DonerHomeScreenState extends State<DonerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const SizedBox(height: 0, width: 0),
        title: Text(
          'GiveHope',
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
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Orders Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 75,
                          decoration: BoxDecoration(
                            color: AppColor.pagesColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Order')
                                      .where('adminApprove', isEqualTo: false)
                                      .where('adminReject', isEqualTo: false)
                                      .where('isShipped', isEqualTo: false)
                                      .where('isDelivered', isEqualTo: false)
                                      .where('donerUID',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? Text(
                                            '00',
                                            style: TextStyle(
                                              color: AppColor.blackColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : snapshot.hasData
                                            ? Text(
                                                snapshot.data!.size.toString(),
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            : Text(
                                                '00',
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                  },
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Approval Pend',
                                        style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 75,
                          decoration: BoxDecoration(
                            color: AppColor.pagesColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Order')
                                      .where('adminApprove', isEqualTo: true)
                                      .where('adminReject', isEqualTo: false)
                                      .where('isShipped', isEqualTo: false)
                                      .where('isDelivered', isEqualTo: false)
                                      .where('donerUID',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? Text(
                                            '00',
                                            style: TextStyle(
                                              color: AppColor.blackColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : snapshot.hasData
                                            ? Text(
                                                snapshot.data!.size.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            : Text(
                                                '00',
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                  },
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'AdminApproved',
                                        style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 75,
                          decoration: BoxDecoration(
                            color: AppColor.pagesColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Order')
                                      .where('adminApprove', isEqualTo: true)
                                      .where('adminReject', isEqualTo: false)
                                      .where('isShipped', isEqualTo: true)
                                      .where('isDelivered', isEqualTo: false)
                                      .where('donerUID',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? Text(
                                            '00',
                                            style: TextStyle(
                                              color: AppColor.blackColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : snapshot.hasData
                                            ? Text(
                                                snapshot.data!.size.toString(),
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            : Text(
                                                '00',
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                  },
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Shipped',
                                        style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 75,
                          decoration: BoxDecoration(
                            color: AppColor.pagesColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Order')
                                      .where('adminApprove', isEqualTo: true)
                                      .where('adminReject', isEqualTo: false)
                                      .where('isShipped', isEqualTo: true)
                                      .where('isDelivered', isEqualTo: true)
                                      .where('donerUID',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? Text(
                                            '00',
                                            style: TextStyle(
                                              color: AppColor.blackColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : snapshot.hasData
                                            ? Text(
                                                snapshot.data!.size.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            : Text(
                                                '00',
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                  },
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Delivered',
                                        style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 75,
                          decoration: BoxDecoration(
                            color: AppColor.pagesColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Order')
                                      .where('adminApprove', isEqualTo: false)
                                      .where('adminReject', isEqualTo: true)
                                      .where('isShipped', isEqualTo: false)
                                      .where('isDelivered', isEqualTo: false)
                                      .where('donerUID',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? Text(
                                            '00',
                                            style: TextStyle(
                                              color: AppColor.blackColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : snapshot.hasData
                                            ? Text(
                                                snapshot.data!.size.toString(),
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            : Text(
                                                '00',
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                  },
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Admin Rejected',
                                        style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 7.5),
                    child: Center(
                      child: Text(
                        "Product",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 7.5),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       Container(
                  //         alignment: Alignment.center,
                  //         width: MediaQuery.of(context).size.width * 0.4,
                  //         height: 75,
                  //         decoration: BoxDecoration(
                  //           color: AppColor.pagesColor,
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(10),
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             // crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //             children: [
                  //               StreamBuilder(
                  //                 stream: FirebaseFirestore.instance
                  //                     .collection('Order')
                  //                     .where('adminApprove', isEqualTo: false)
                  //                     .where('adminReject', isEqualTo: false)
                  //                     .where('isShipped', isEqualTo: false)
                  //                     .where('isDelivered', isEqualTo: false)
                  //                     .where('donerUID',
                  //                         isEqualTo: FirebaseAuth
                  //                             .instance.currentUser!.uid)
                  //                     .snapshots(),
                  //                 builder: (context, snapshot) {
                  //                   return snapshot.connectionState ==
                  //                           ConnectionState.waiting
                  //                       ? Text(
                  //                           '00',
                  //                           style: TextStyle(
                  //                             color: AppColor.blackColor,
                  //                             fontSize: 20,
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         )
                  //                       : snapshot.hasData
                  //                           ? Text(
                  //                               snapshot.data!.size.toString(),
                  //                               style: TextStyle(
                  //                                 color: AppColor.blackColor,
                  //                                 fontSize: 15,
                  //                                 fontWeight: FontWeight.w600,
                  //                               ),
                  //                             )
                  //                           : Text(
                  //                               '00',
                  //                               style: TextStyle(
                  //                                 color: AppColor.blackColor,
                  //                                 fontSize: 20,
                  //                                 fontWeight: FontWeight.bold,
                  //                               ),
                  //                             );
                  //                 },
                  //               ),
                  //               RichText(
                  //                 textAlign: TextAlign.center,
                  //                 text: TextSpan(
                  //                   children: [
                  //                     TextSpan(
                  //                       text: 'Approval Pend',
                  //                       style: TextStyle(
                  //                         color: AppColor.blackColor,
                  //                         fontSize: 13,
                  //                         fontWeight: FontWeight.bold,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         alignment: Alignment.center,
                  //         width: MediaQuery.of(context).size.width * 0.4,
                  //         height: 75,
                  //         decoration: BoxDecoration(
                  //           color: AppColor.pagesColor,
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(10),
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             // crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //             children: [
                  //               StreamBuilder(
                  //                 stream: FirebaseFirestore.instance
                  //                      .collection('Product')
                  //                     // .where('adminApprove', isEqualTo: false)
                  //                     // .where('adminReject', isEqualTo: false)
                  //                     .where('userUID',
                  //                         isEqualTo: FirebaseAuth
                  //                             .instance.currentUser!.uid)
                  //                     .snapshots(),
                  //                 builder: (context, snapshot) {

                  //                   return snapshot.connectionState ==
                  //                           ConnectionState.waiting
                  //                       ? Text(
                  //                           '00',
                  //                           style: TextStyle(
                  //                             color: AppColor.blackColor,
                  //                             fontSize: 20,
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         )
                  //                       : snapshot.hasData
                  //                           ? Text(
                  //                               snapshot.data!.size.toString(),
                  //                               textAlign: TextAlign.center,
                  //                               style: TextStyle(
                  //                                 color: AppColor.blackColor,
                  //                                 fontSize: 15,
                  //                                 fontWeight: FontWeight.w600,
                  //                               ),
                  //                             )
                  //                           : Text(
                  //                               '00',
                  //                               style: TextStyle(
                  //                                 color: AppColor.blackColor,
                  //                                 fontSize: 20,
                  //                                 fontWeight: FontWeight.bold,
                  //                               ),
                  //                             );
                  //                 },
                  //               ),
                  //               RichText(
                  //                 text: TextSpan(
                  //                   children: [
                  //                     TextSpan(
                  //                       text: 'AdminApproved',
                  //                       style: TextStyle(
                  //                         color: AppColor.blackColor,
                  //                         fontSize: 13,
                  //                         fontWeight: FontWeight.bold,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 75,
                          decoration: BoxDecoration(
                            color: AppColor.pagesColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Product')
                                      // .where('adminApprove', isEqualTo: false)
                                      // .where('adminReject', isEqualTo: false)
                                      .where('userUID',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? Text(
                                            '00',
                                            style: TextStyle(
                                              color: AppColor.blackColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : snapshot.hasData
                                            ? Text(
                                                snapshot.data!.size.toString(),
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            : Text(
                                                '00',
                                                style: TextStyle(
                                                  color: AppColor.blackColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                  },
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Total Product',
                                        style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
