import 'package:Frizz/helper/helperFunctions.dart';
import 'package:Frizz/main.dart';
import 'package:Frizz/views/chatRoom.dart';
import 'package:flutter/material.dart';
import 'package:Frizz/widgets/widgets.dart';
import 'package:Frizz/services/auth.dart';
import 'package:Frizz/services/database.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods database = DatabaseMethods();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  signMeUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        Map<String, String> userInfoMap = {
          "name": userNameTextEditingController.text,
          "email": emailTextEditingController.text,
        };
        database.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserNameSharedPreference(
            userNameTextEditingController.text);
        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
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
                              controller: userNameTextEditingController,
                              decoration: textFieldDecoration("Name"),
                              style: whiteTextStyle(),
                            ),
                            TextFormField(
                                validator: (value) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                          .hasMatch(value)
                                      ? null
                                      : "Please enter a valid Email";
                                },
                                controller: emailTextEditingController,
                                decoration: textFieldDecoration("Email"),
                                style: whiteTextStyle()),
                            TextFormField(
                                obscureText: true,
                                validator: (value) {
                                  return value.isEmpty || value.length < 6
                                      ? "Please enter a valid Password"
                                      : null;
                                },
                                controller: passwordTextEditingController,
                                decoration: textFieldDecoration("Password"),
                                style: whiteTextStyle()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
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
                            "Sign Up",
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
                            "Sign up with Google",
                            style: TextStyle(
                              color: Colors.blue,
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
                            "Already have an account? ",
                            style: mediumWhiteTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () => widget.toggle(),
                            child: Text(
                              "Login now",
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
