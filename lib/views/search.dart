import 'package:Frizz/helper/helperFunctions.dart';
import 'package:Frizz/services/database.dart';
import 'package:Frizz/views/chat.dart';
import 'package:Frizz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Frizz/main.dart';

String _myName;

class SearchChat extends StatefulWidget {
  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot searchSnapshot;
  sendToChatroom({String userName}) {
    if (userName != _myName) {
      String chatRoomId = getChatRoomId(userName, _myName);
      List<String> users = [userName, _myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Chat(chatRoomId)));
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].get("name"),
                userEmail: searchSnapshot.docs[index].get("email"),
              );
            },
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
          )
        : Container();
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
          color: primary, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: mediumWhiteTextStyle(),
              ),
              Text(
                userEmail,
                style: mediumWhiteTextStyle(),
              ),
            ],
          ),
          Spacer(),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black,
            child: IconButton(
              onPressed: () {
                sendToChatroom(userName: userName);
              },
              icon: Icon(Icons.send),
              color: highlightColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
  }

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: primary,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: whiteTextStyle(),
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                          hintText: "Search ",
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 17),
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    iconSize: 25,
                    color: highlightColor,
                    icon: Icon(Icons.search),
                    onPressed: () {
                      initiateSearch();
                    },
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else
    return "$a\_$b";
}
