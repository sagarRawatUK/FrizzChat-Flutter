import 'package:Frizz/helper/helperFunctions.dart';
import 'package:Frizz/views/chatRoom.dart';
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
  bool isUserLoggedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
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
            ? isUserLoggedIn ? ChatRoom() : Authentication()
            : Container(
                child: Center(
                  child: Authentication(),
                ),
              ));
  }
}

class Blank extends StatefulWidget {
  @override
  _BlankState createState() => _BlankState();
}

class _BlankState extends State<Blank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
