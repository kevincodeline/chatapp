import 'package:firebase_chat_tutorial/helper/helperfunctions.dart';
import 'package:firebase_chat_tutorial/services/auth.dart';
import 'package:firebase_chat_tutorial/services/database.dart';
import 'package:firebase_chat_tutorial/view/chat_room_screen.dart';
import 'package:firebase_chat_tutorial/widgets/widget.dart';
import 'package:flutter/material.dart';

class SingUp extends StatefulWidget {
  final Function toggle;
  SingUp(this.toggle);
  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  bool isLoading = false;
  String? token;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController _userName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  signMeUP() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "email": _email.text,
        "name": _userName.text,
        "usertoken": token.toString(),
      };
      HelperFunctions.saveUserEmailSharedPreference(_email.text);
      HelperFunctions.saveUserNameSharedPreference(_userName.text);

      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(_email.text, _password.text)
          .then((val) {
        // print("${val.uid}");

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(),
            ));
      });
    }
  }

  getToken() async {
    token = await HelperFunctions.getFcmTokenSharedPreference();
    print("========>$token");
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F1F1F),
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 60,
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (value) {
                            return value!.isEmpty || value.length < 2
                                ? "Enter valid name"
                                : null;
                          },
                          controller: _userName,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('Username'),
                        ),
                        TextFormField(
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Enter correct email";
                          },
                          controller: _email,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('email'),
                        ),
                        TextFormField(
                          validator: (value) {
                            return value!.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                          controller: _password,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration('password'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Forgot Password',
                              style: mediumTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            signMeUP();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(colors: [
                                  const Color(0xFF007EF4),
                                  const Color(0xFF2A75BC),
                                ])),
                            child: Text(
                              'Sign Up ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          child: Text(
                            'SIgn Up With Google',
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have account ",
                              style: mediumTextStyle(),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "SignIn  now ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
