import 'package:Frizz/helper/helperFunctions.dart';
import 'package:Frizz/views/chatRoom.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helper/authenttication.dart';

final Color primary = Color(0xff181818);
final Color highlightColor = Color(0xff28e6b4);
final Color highlightColorLight = Color(0xffc2f7e8);
final Color bgColor = Colors.black;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message = "Message";
  String token = "token";
  final firebaseMessage = FirebaseMessaging();
  bool isUserLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
    firebaseMessage.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    firebaseMessage.getToken().then((value) {
      setState(() {
        print(value);
      });
    });
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        isUserLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: bgColor,
          primaryColor: primary,
          accentColor: highlightColor),
      home: isUserLoggedIn != null
          ? isUserLoggedIn
              ? ChatRoom()
              : Authentication()
          : Container(
              child: Center(
                child: Authentication(),
              ),
            ),
    );
  }
}
