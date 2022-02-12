import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .where("email", isEqualTo: userEmail)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getFcmToken(String username) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .where("name", isEqualTo: username)
        .where("usertoken")
        .get()
        .catchError((e) {});
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("user").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chaRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chaRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessage(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  // static Future<String> getToken(userId) async {
  //   final FirebaseFirestore _db = FirebaseFirestore.instance;
  //
  //   var token;
  //   await _db
  //       .collection('user')
  //       .doc(userId)
  //       .collection('tokens')
  //       .get()
  //       .then((snapshot) {
  //     snapshot.docs.forEach((doc) {
  //       token = doc.documentID;
  //     });
  //   });
  //
  //   return token;
  // }
}
