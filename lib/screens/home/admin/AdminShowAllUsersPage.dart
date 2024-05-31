import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:give_hope/screens/home/admin/nextPage/doner_details.dart';
import 'package:give_hope/screens/home/admin/nextPage/reciver_details.dart';

class AdminShowAllUsersPage extends StatefulWidget {
  const AdminShowAllUsersPage({Key? key}) : super(key: key);

  @override
  State<AdminShowAllUsersPage> createState() => _AdminShowAllUsersPageState();
}

class _AdminShowAllUsersPageState extends State<AdminShowAllUsersPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        // backgroundColor: AppColor.primaryColor,
        appBar: AppBar(
          centerTitle: true,
          leading: const SizedBox(height: 0, width: 0),
          title: Text(
            'All Users',
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
                text: 'Doners',
              ),
              Tab(
                text: 'Recipients',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User")
                      .where("userType", isEqualTo: 'Doner')
                      .where('donerFormFild', isEqualTo: true)
                      .where('adminApprove', isEqualTo: false)
                      .where('remarks', isEqualTo: "")
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> documentData =
                                  snapshot.data!.docs[index].data();

                              if (documentData.isNotEmpty) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    horizontalTitleGap: 7,
                                    leading: CircleAvatar(
                                      backgroundColor: AppColor.primaryColor,
                                      backgroundImage: documentData[
                                                  'profileImageLink'] !=
                                              "0"
                                          ? NetworkImage(
                                              documentData['profileImageLink'])
                                          : const NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU"),
                                    ),
                                    title: Text(documentData['userName']),
                                    subtitle: Text(documentData["userEmail"]),
                                    trailing: Icon(
                                      Icons.arrow_right_rounded,
                                      size: 20,
                                      color: AppColor.blackColor,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DonerDetailsPage(
                                                  donerData: documentData),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox(height: 0, width: 0);
                              }
                            },
                            separatorBuilder: (BuildContext context, int) {
                              return const Divider();
                            },
                            itemCount: snapshot.data!.docs.length);
                      } else {
                        return Center(
                          child: Text(
                            "No Doner Is Registered",
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User")
                      .where("userType", isEqualTo: 'Reciver')
                      .where('reciverFormFild', isEqualTo: true)
                      .where('adminApprove', isEqualTo: false)
                      .where('remarks', isEqualTo: "")
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> documentData =
                                  snapshot.data!.docs[index].data();

                              if (documentData.isNotEmpty) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    horizontalTitleGap: 7,
                                    leading: CircleAvatar(
                                      backgroundColor: AppColor.primaryColor,
                                      backgroundImage: documentData[
                                                  'profileImageLink'] !=
                                              "0"
                                          ? NetworkImage(
                                              documentData['profileImageLink'])
                                          : const NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU"),
                                    ),
                                    title: Text(documentData['userName']),
                                    subtitle: Text(documentData["userEmail"]),
                                    trailing: Icon(
                                      Icons.arrow_right_rounded,
                                      size: 20,
                                      color: AppColor.blackColor,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReciverDetailsPage(
                                                  reciverData: documentData),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox(height: 0, width: 0);
                              }
                            },
                            separatorBuilder: (BuildContext context, int) {
                              return const Divider();
                            },
                            itemCount: snapshot.data!.docs.length);
                      } else {
                        return Center(
                          child: Text(
                            "No Recipient Is Registered",
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
          ],
        ),
      ),
    );
  }
}
