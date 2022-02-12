import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_tutorial/helper/constants.dart';
import 'package:firebase_chat_tutorial/helper/helperfunctions.dart';
import 'package:firebase_chat_tutorial/services/database.dart';
import 'package:firebase_chat_tutorial/view/conversation_screen.dart';
import 'package:firebase_chat_tutorial/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

String? _myName;

class _SearchState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;
  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot!.docs[index]["name"],
                userEmail: searchSnapshot!.docs[index]["email"],
              );
            })
        : Container();
  }

  initiateSearch() async {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  ///create chatroom send user to conversation screen,pushreplacement
  creatChatroomAndStartConversation({
    String? userName,
  }) {
    print("Constants.myName=======> ${Constants.myName}");

    if (userName != Constants.myName) {
      print("print=======> ${Constants.myName}");

      String chatRoomId = getChatRoomId(Constants.myName, userName!);
      List<String> users = [Constants.myName, userName];
      Map<String, dynamic> charRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, charRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConverSationScreen(chatRoomId,userName),
          ));
    } else {
      print("you cannot send message");
    }
  }

  Widget SearchTile({String? userName, String? userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName!,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail!,
                style: mediumTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              creatChatroomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Message',
                style: mediumTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
    print("my=====>$_myName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F1F1F),
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search Username",
                        hintStyle: TextStyle(color: Colors.white54),
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
                        print(
                            "controller ========>${searchTextEditingController.text}");
                        initiateSearch();
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
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              searchList(),
            ],
          ),
        ),
      ),
    );
  }
}

// class SearchTile extends StatelessWidget {
//   final String? userNAme;
//   final String? userEmail;
//   SearchTile({this.userNAme, this.userEmail});
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
