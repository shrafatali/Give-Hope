// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:photo_view/photo_view.dart';

class ShowZoomImagePage extends StatefulWidget {
  String title;
  String path;
  ShowZoomImagePage({required this.title, required this.path, super.key});

  @override
  State<ShowZoomImagePage> createState() => _ShowZoomImagePageState();
}

class _ShowZoomImagePageState extends State<ShowZoomImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pagesColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          widget.title,
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
      body: SizedBox(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        child: PhotoView(
          imageProvider: NetworkImage(
            widget.path.toString(),
          ),
        ),
      ),
    );
  }
}
