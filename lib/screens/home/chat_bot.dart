// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:give_hope/components/constants.dart';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  ChatUser mySelf =
      ChatUser(id: '1', firstName: 'Charles', lastName: 'Leclerc');
  ChatUser bot = ChatUser(
      id: '2',
      firstName: 'GiveHope',
      profileImage: "assets/icons/donation.png");
  // "https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg"

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];

  String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDUvlQ5lRWBwB6aofyhNE4QWW5W2Q4Y8i0";

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
          'GiveHope ChatBot',
          style: TextStyle(
            fontSize: 16,
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
      body: DashChat(
        inputOptions: const InputOptions(),
        typingUsers: typing,
        currentUser: mySelf,
        onSend: (ChatMessage m) async {
          try {
            typing.add(bot);
            setState(() {
              allMessages.insert(0, m);
            });

            await http
                .post(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                "contents": [
                  {
                    "parts": [
                      {"text": m.text.trim().toString()}
                    ]
                  }
                ]
              }),
            )
                .then((value) {
              if (value.statusCode == 200) {
                var result = jsonDecode(value.body);
                print("result : $result");

                print(
                    "result  : ${result["candidates"][0]["content"]["parts"][0]["text"]}");
                ChatMessage m1 = ChatMessage(
                  text:
                      "${result["candidates"][0]["content"]["parts"][0]["text"]}",
                  user: bot,
                  createdAt: DateTime.now(),
                );

                allMessages.insert(0, m1);
              } else {
                print("Error occured");
              }
            }).catchError((e) {
              print("ERRRROR : ${e.toString()}");
            });
          } catch (e) {
            print(e.toString());
          } finally {
            typing.remove(bot);
            setState(() {});
          }
        },
        messages: allMessages,
      ),
    );
  }
}
