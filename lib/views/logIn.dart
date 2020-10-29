import 'package:Frizz/helper/helperFunctions.dart';
import 'package:Frizz/main.dart';
import 'package:Frizz/services/auth.dart';
import 'package:Frizz/services/database.dart';
import 'package:Frizz/views/chatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Frizz/widgets/widgets.dart';

class LogIn extends StatefulWidget {
  final Function toggle;
  LogIn(this.toggle);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods database = DatabaseMethods();
  HelperFunctions helperFunctions = HelperFunctions();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  QuerySnapshot snapshotUserInfo;

  signMeIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) async {
        if (value != null) {
          snapshotUserInfo = await database
              .getUserByUserEmail(emailTextEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              snapshotUserInfo.docs[0].data()["name"]);
          HelperFunctions.saveUserEmailSharedPreference(
              snapshotUserInfo.docs[0].data()["email"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBarMain(context),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty || value.length < 4
                                    ? "Please enter a valid Username"
                                    : null;
                              },
                              controller: emailTextEditingController,
                              decoration: textFieldDecoration("Email"),
                              style: whiteTextStyle(),
                            ),
                            TextFormField(
                                validator: (value) {
                                  return value.isEmpty || value.length < 6
                                      ? "Please enter a valid Password"
                                      : null;
                                },
                                obscureText: true,
                                controller: passwordTextEditingController,
                                decoration: textFieldDecoration("Password"),
                                style: whiteTextStyle()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Text(
                            "Forgot Password?",
                            style: mediumWhiteTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(colors: [
                                highlightColor,
                                highlightColorLight
                              ])),
                          child: Text(
                            "Log in",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: primary),
                          child: Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: highlightColor,
                              fontSize: 17,
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: mediumWhiteTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () => widget.toggle(),
                            child: Text(
                              "Register now",
                              style: TextStyle(
                                color: highlightColor,
                                fontSize: 17,
                              ),
                            ),
                          )
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
    );
  }
}
