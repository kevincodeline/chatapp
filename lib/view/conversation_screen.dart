import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_tutorial/helper/constants.dart';
import 'package:firebase_chat_tutorial/helper/helperfunctions.dart';
import 'package:firebase_chat_tutorial/services/database.dart';
import 'package:firebase_chat_tutorial/widgets/widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'notification.dart';

class ConverSationScreen extends StatefulWidget {
  String chatRoomId;
  String userName;
  ConverSationScreen(
    this.chatRoomId,
    this.userName,
  );

  @override
  _ConverSationScreenState createState() => _ConverSationScreenState();
}

class _ConverSationScreenState extends State<ConverSationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  AppNotificationHandler appNotificationHandler = AppNotificationHandler();

  TextEditingController messageController = TextEditingController();
  Stream? chatMessageStream;
  String? getToken;
  QuerySnapshot? snapshotUserInfo;
  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]["message"],
                    isSendByMe:
                        Constants.myName == snapshot.data.docs[index]["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      DatabaseMethods().addConversationMessage(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = "";
      });

      AppNotificationHandler.sendMessageNotification(
          receiverFcmToken: getToken);
    }
  }
  // sendnofication(){
  //   AppNotificationHandler().s
  // }

  @override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    databaseMethods.getFcmToken(widget.userName).then((value) {
      setState(() {
        snapshotUserInfo = value;
        getToken = snapshotUserInfo!.docs[0]['usertoken'];
        print('========>$getToken');
      });
    });
    print("===name===${widget.userName}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F1F1F),
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ChatMessageList()),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Message.....",
                        hintStyle: TextStyle(color: Colors.black),
                        suffix: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.photo),
                        ),
                        border: InputBorder.none,
                      ),
                    )),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       print("hello");
                    //     },
                    //     child: Text('hello')),
                    GestureDetector(
                      onTap: () {
                        // print("========>${searchTextEditingController.text}");
                        // initiateSearch();

                        sendMessage();

                        // AppNotificationHandler();
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.photo,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // print("========>${searchTextEditingController.text}");
                        // initiateSearch();

                        sendMessage();

                        // AppNotificationHandler();
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.send,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({required this.message, required this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
