import 'package:Frizz/helper/constants.dart';
import 'package:Frizz/services/database.dart';
import 'package:Frizz/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:Frizz/main.dart';
import 'package:intl/intl.dart';

final Color myColor = primary;

class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat(this.chatRoomId);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream chatStream;
  DatabaseMethods database = DatabaseMethods();
  TextEditingController messageEditingController = TextEditingController();

  @override
  void initState() {
    database.getChatMessages(widget.chatRoomId).then((value) {
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
                        snapshot.data.documents[index].data()['sentBy'] ==
                            Constants.myName,
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
      "sentTime": DateFormat.jm().format(DateTime.now())
    };
    database.addChatMessages(widget.chatRoomId, chatMap);
    messageEditingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBarMain(context),
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
  final bool isSentByMe;
  final dynamic sentTime;
  ChatTile(this.message, this.isSentByMe, this.sentTime);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            color: isSentByMe ? highlightColor : primary,
            // gradient: LinearGradient(
            //   colors: isSentByMe
            //       ? [myColor, myColorDark]
            //       : [Color(0xff4b4b4b), Color(0xff3d3d3d)],
            // ),
            borderRadius: isSentByMe
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
        child: Container(
          child: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: isSentByMe ? Colors.black : Colors.white,
                  fontSize: 16,
                ),
              ),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      sentTime.toString(),
                      style: TextStyle(
                          color: isSentByMe ? Colors.black : Colors.white,
                          fontSize: 8),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
