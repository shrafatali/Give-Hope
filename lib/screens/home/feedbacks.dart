// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:give_hope/components/components.dart';
import 'package:give_hope/components/constants.dart';

class FeedbackScreen extends StatefulWidget {
  String userType;
  FeedbackScreen({required this.userType, super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController feedbackC = TextEditingController();
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
            widget.userType == 'admin' ? 'Feedbacks' : "Feedback",
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
        body: widget.userType == 'admin'
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: getAdminFeedbacks(context),
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
                ))
            : SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        TextFormField(
                          controller: feedbackC,
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 100,
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "CentraleSansRegular"),
                          validator: (value) {
                            if (value!.toString().trim().isEmpty) {
                              return 'Please Enter feedback';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xffd3dde4), width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xffd3dde4), width: 2)),
                              labelText: "Feedback",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "CentraleSansRegular")),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              Components.showAlertDialog(context);
                              try {
                                String feedbackID = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                await FirebaseFirestore.instance
                                    .collection("Feedbacks")
                                    .doc(feedbackID)
                                    .set({
                                  'feedbackID': feedbackID,
                                  'feedback': feedbackC.text.trim().toString(),
                                  'userUID':
                                      FirebaseAuth.instance.currentUser!.uid,
                                }).then((value) => Components.showSnackBar(
                                        context,
                                        "Feedback Saveed Sucessfully"));
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } catch (e) {
                                Navigator.pop(context);

                                Components.showSnackBar(context, e.toString());
                              }
                            } else {
                              Components.showSnackBar(
                                  context, "Please Enter feedback then save");
                            }
                          },
                          child: Container(
                            width: 330,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Color(0xff471a91), Color(0xff3cabff)],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "CentraleSansRegular",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ));
  }

  Stream<Widget> getAdminFeedbacks(context) async* {
    List<Widget> x = [];
    await FirebaseFirestore.instance.collection('Feedbacks').get().then(
      (feedback) async {
        for (var feedbackData in feedback.docs) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(feedbackData.data()['userUID'])
              .get()
              .then((userData) async {
            x.add(
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  horizontalTitleGap: 7,
                  leading: CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    backgroundImage: userData['profileImageLink'] != "0"
                        ? NetworkImage(userData['profileImageLink'])
                        : const NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU"),
                  ),
                  title: Text(userData['userName']),
                  subtitle: Text(feedbackData.data()['feedback']),
                  trailing: IconButton(
                    onPressed: () async {
                      Components.showAlertDialog(context);
                      try {
                        await FirebaseFirestore.instance
                            .collection("Feedbacks")
                            .doc(feedbackData.data()['feedbackID'])
                            .delete()
                            .then((value) => Components.showSnackBar(
                                context, "Feedback Delete Sucessfully"));
                        Navigator.pop(context);
                        setState(() {});
                      } catch (e) {
                        Navigator.pop(context);

                        Components.showSnackBar(context, e.toString());
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         ReciverDetailsPage(
                    //             reciverData: documentData),
                    //   ),
                    // );
                  },
                ),
              ),

              //   GestureDetector(
              //     onTap: () {
              //       //
              //     },
              //     child: Card(
              //       margin:
              //           const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              //       elevation: 5,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Column(
              //         children: [
              //           ClipRRect(
              //             borderRadius: const BorderRadius.only(
              //                 topLeft: Radius.circular(10),
              //                 topRight: Radius.circular(10)),
              //             child: SizedBox(
              //               height: 140,
              //               width: double.infinity,
              //               child: CachedNetworkImage(
              //                 fit: BoxFit.fill,
              //                 imageUrl: productData['productImage'].toString(),
              //                 placeholder: (context, url) => SizedBox(
              //                   height: 140,
              //                   child: Center(
              //                     child: CircularProgressIndicator(
              //                         color: AppColor.primaryColor),
              //                   ),
              //                 ),
              //                 errorWidget: (context, url, error) =>
              //                     const Icon(Icons.error, color: Colors.red),
              //               ),
              //             ),
              //           ),
              //           ListTile(
              //             horizontalTitleGap: 7,
              //             contentPadding:
              //                 const EdgeInsets.symmetric(horizontal: 8),
              //             title: Text(productData['productName']),
              //             subtitle: Text(
              //               productData["productDes"],
              //               maxLines: 1,
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //             trailing: Icon(
              //               Icons.arrow_right_rounded,
              //               size: 20,
              //               color: AppColor.blackColor,
              //             ),
              //             onTap: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) =>
              //               //         DonerDetailsPage(donerData: documentData),
              //               //   ),
              //               // );
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              // ),
            );
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
