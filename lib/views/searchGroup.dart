import 'package:Frizz/helper/constants.dart';
import 'package:Frizz/helper/helperFunctions.dart';
import 'package:Frizz/main.dart';
import 'package:Frizz/services/database.dart';
import 'package:Frizz/views/groupchat.dart';
import 'package:Frizz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchGroup extends StatefulWidget {
  @override
  _SearchGroupState createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();
  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
  }

  initiateSearch() {
    databaseMethods
        .getGroupByName(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  sendToChatroom({String chatRoomId}) {
    List<dynamic> users = [];

    databaseMethods.getMap(chatRoomId).then((value) async {
      users = await value.data()['users'];
      print(users);
    });
    if (!users.contains(Constants.myName)) {
      users.add(Constants.myName);
      print(users);
    }

    Map<String, dynamic> chatRoomMap = {
      "users": FieldValue.arrayUnion(users),
      "chatRoomId": chatRoomId
    };
    databaseMethods.updateMap(chatRoomId, chatRoomMap);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => GroupChat(chatRoomId)));
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemBuilder: (context, index) {
              return SearchTile(
                groupName: searchSnapshot.docs[index].get("chatRoomId"),
              );
            },
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
          )
        : Container();
  }

  Widget SearchTile({String groupName}) {
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
                groupName,
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
                sendToChatroom(chatRoomId: groupName);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          "Search Groups",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: highlightColor),
        ),
      ),
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
