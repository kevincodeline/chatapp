import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_tutorial/helper/constants.dart';
import 'package:firebase_chat_tutorial/helper/helperfunctions.dart';
import 'package:firebase_chat_tutorial/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class AppNotificationHandler {
  static Future<String?> getFcmToken() async {
    DatabaseMethods databaseMethods = DatabaseMethods();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    try {
      String? token = await firebaseMessaging.getToken();
      // User? user = FirebaseAuth.instance.currentUser;
      HelperFunctions.saveUserFcmTokenSharedPreference(token!);
      // databaseMethods.getFcmToken(token);
      // await FirebaseFirestore.instance.collection('user').doc(user.uid).update('')

      // Map<String, String> userInfoMap = {
      //   "token": token,
      // };
      // databaseMethods.uploadUserInfo(userInfoMap);

      // await PrefManager.setFcmToken(fcmToken: token);
      log("=========fcm-token===$token");
      return token;
    } catch (e) {
      log("=========fcm- Error :$e");
      return null;
    }
  }

  ///SEND NOTIFICATION FROM ONE DEVICE TO ANOTHER DEVICE...
  static Future<bool> sendMessageNotification(
      {String? receiverFcmToken}) async {
    print('send notification fcm id---$receiverFcmToken');
    var serverKey =
        'AAAAXrWA2o0:APA91bE2B9mfkqPwDec6r-aOC5RFhWHvOM00zQrgSllXE6YyHichqbzpU0zJGpoiX_hH8NEa6Mx9RTSwtvOxC2wN8yfxgnSpvpm_9MigNd44b-FnKuBCkuZm_zkWSl7ACnAzJ65af0oK';
    try {
      // for (String token in receiverFcmToken) {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'liked your post',
              // 'title': PrefManager.getStorage.read('name') ?? 'Reyo'
              'title': Constants.myName,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': receiverFcmToken,
          },
        ),
      );
      log("RESPONSE CODE ${response.statusCode}");
      log("RESPONSE BODY ${response.body}");
      return true;
    } catch (e) {
      print("error push notification");
      return false;
    }
  }
}
