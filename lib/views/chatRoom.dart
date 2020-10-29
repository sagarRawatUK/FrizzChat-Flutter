import 'package:Frizz/helper/authenttication.dart';
import 'package:Frizz/helper/constants.dart';
import 'package:Frizz/helper/helperFunctions.dart';
import 'package:Frizz/main.dart';
import 'package:Frizz/services/auth.dart';
import 'package:Frizz/services/database.dart';
import 'package:Frizz/views/chat.dart';
import 'package:Frizz/views/search.dart';
import 'package:Frizz/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods database = DatabaseMethods();
  Stream chatRoomStream;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Widget chatRoomBuilder() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatRoomsListTile(
                        snapshot.data.documents[index]
                            .data()['chatRoomId']
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                        snapshot.data.documents[index].data()['chatRoomId']);
                  },
                )
              : Container();
        });
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();

    await database.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
        print("This is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          "Frizz Chat",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authentication()));
              })
        ],
      ),
      body: chatRoomBuilder(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        focusColor: highlightColor,
        foregroundColor: highlightColor,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchChat()));
        },
      ),
    );
  }
}

class ChatRoomsListTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsListTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chat(chatRoomId)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
            color: primary, borderRadius: BorderRadius.circular(12)
            // gradient: LinearGradient(
            //   colors: [Color(0xff4b4b4b), Color(0xff3d3d3d)],
            // ),
            ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: highlightColor,
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
