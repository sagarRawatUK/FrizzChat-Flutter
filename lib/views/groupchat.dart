import 'package:Frizz/helper/constants.dart';
import 'package:Frizz/main.dart';
import 'package:Frizz/services/database.dart';
import 'package:Frizz/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupChat extends StatefulWidget {
  String groupId;
  GroupChat(this.groupId);
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  Stream chatStream;
  DatabaseMethods database = DatabaseMethods();
  TextEditingController messageEditingController = TextEditingController();

  @override
  void initState() {
    database.getGroupChatMessages(widget.groupId).then((value) {
      setState(() {
        chatStream = value;
      });
    });
    super.initState();
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return ChatTile(
                        snapshot.data.documents[index].data()['message'],
                        snapshot.data.documents[index].data()['sentBy'],
                        snapshot.data.documents[index].data()['sentTime']);
                  },
                  itemCount: snapshot.data.documents.length,
                )
              : Container();
        });
  }

  sendMessage() {
    Map<String, dynamic> chatMap = {
      "message": messageEditingController.text,
      "sentBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
      "sentTime": DateFormat('kk:mm a').format(DateTime.now())
    };
    database.addGroupChatMessages(widget.groupId, chatMap);
    messageEditingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          widget.groupId,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: highlightColor),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: primary,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: whiteTextStyle(),
                        controller: messageEditingController,
                        decoration: InputDecoration(
                            hintText: "Message ",
                            hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 17),
                            border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () {},
                      color: highlightColor,
                    ),
                    IconButton(
                      iconSize: 25,
                      color: highlightColor,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        sendMessage();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String message;
  final String sentBy;
  final dynamic sentTime;
  ChatTile(this.message, this.sentBy, this.sentTime);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      width: MediaQuery.of(context).size.width,
      alignment: sentBy == Constants.myName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            color: sentBy == Constants.myName ? highlightColor : primary,
            borderRadius: sentBy == Constants.myName
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Column(
                children: [
                  sentBy == Constants.myName
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              sentBy,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                  Text(
                    message,
                    style: TextStyle(
                      color: sentBy == Constants.myName
                          ? Colors.black
                          : Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  Container(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            sentTime.toString(),
                            style: TextStyle(
                                color: sentBy == Constants.myName
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 8),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
