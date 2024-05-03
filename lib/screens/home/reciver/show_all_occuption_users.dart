// ignore_for_file: avoid_print, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/reciver/show_product_detail.dart';

class ShowAllOccuptionUser extends StatefulWidget {
  String donationType;
  ShowAllOccuptionUser({required this.donationType, super.key});

  @override
  State<ShowAllOccuptionUser> createState() => _ShowAllOccuptionUserState();
}

class _ShowAllOccuptionUserState extends State<ShowAllOccuptionUser> {
  Future<DocumentSnapshot> getdata(String userUID) async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("User")
        .where("userUID", isEqualTo: userUID)
        .get();

    return qn.docs.first;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.donationType);
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
          widget.donationType,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Product")
                .where("categoryType", isEqualTo: widget.donationType)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> documentData =
                            snapshot.data!.docs[index].data();
                        // var data = getdata(documentData["userUID"].toString());
                        if (documentData.isNotEmpty) {
                          // print(data?["userName"]);

                          if (int.parse(
                                  documentData["availableItems"].toString()) >
                              0) {
                            return FutureBuilder(
                                future:
                                    getdata(documentData["userUID"].toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return GestureDetector(
                                      onTap: () {
                                        print(snapshot.data.toString());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowProductDetails(
                                                        productData:
                                                            documentData,
                                                        userData:
                                                            snapshot.data)));
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10)),
                                              child: SizedBox(
                                                height: 140,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: documentData[
                                                          'productImage']
                                                      .toString(),
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                    height: 140,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: AppColor
                                                                  .primaryColor),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error,
                                                          color: Colors.red),
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              horizontalTitleGap: 7,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              title: Text(
                                                  documentData['productName']),
                                              subtitle: Text(
                                                documentData["productDes"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: Icon(
                                                Icons.arrow_right_rounded,
                                                size: 20,
                                                color: AppColor.blackColor,
                                              ),
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                          color: AppColor.primaryColor),
                                    );
                                  }
                                  return Container(height: 0);
                                });
                          }
                        } else {
                          // return const SizedBox(height: 0, width: 0);
                          return Center(
                            child: Text(
                              "Data Not Found",
                              style: TextStyle(color: AppColor.blackColor),
                            ),
                          );
                        }
                        return null;
                      },
                      separatorBuilder: (BuildContext context, int v) {
                        return const Divider();
                      },
                      itemCount: snapshot.data!.docs.length);
                } else {
                  return Center(
                    child: Text(
                      "Data Not Found",
                      style: TextStyle(color: AppColor.blackColor),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                );
              }
            }),
      ),
    );
  }
}
