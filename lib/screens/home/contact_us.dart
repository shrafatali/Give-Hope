import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:give_hope/components/constants.dart';

class ContactUS extends StatelessWidget {
  const ContactUS({super.key});

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
          'Contact Us',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Thank you for your interest in Give Hope! If you have any questions, feedback, or inquiries, please don't hesitate to reach out to us. Our dedicated team is here to assist you.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Saad Habib',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: const Text("+92 3481050180"),
                trailing: IconButton(
                  onPressed: () async {
                    await FlutterPhoneDirectCaller.callNumber("+923481050180");
                  },
                  icon: Icon(
                    Icons.call,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              ListTile(
                title: const Text("sh882296@gmail.com"),
                trailing: IconButton(
                  onPressed: () async {
                    final Email email = Email(
                      body: 'Email body',
                      subject: 'Email subject',
                      recipients: ['sh882296@gmail.com'],
                      cc: [],
                      bcc: [],
                      attachmentPaths: [],
                      isHTML: false,
                    );

                    await FlutterEmailSender.send(email);
                  },
                  icon: Icon(
                    Icons.email_rounded,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Danish Malik',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: const Text("+92 3185279794"),
                trailing: IconButton(
                  onPressed: () async {
                    await FlutterPhoneDirectCaller.callNumber("+923185279794");
                  },
                  icon: Icon(
                    Icons.call,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              ListTile(
                title: const Text("awansmalik999@gmail.com"),
                trailing: IconButton(
                  onPressed: () async {
                    final Email email = Email(
                      body: 'Email body',
                      subject: 'Email subject',
                      recipients: ['awansmalik999@gmail.com'],
                      cc: [],
                      bcc: [],
                      attachmentPaths: [],
                      isHTML: false,
                    );

                    await FlutterEmailSender.send(email);
                  },
                  icon: Icon(
                    Icons.email_rounded,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Feel free to contact us via phone or email, and we'll respond to your queries promptly. Your support and engagement are crucial to our mission of helping those in need. Let's work together to make a positive impact in our community.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
