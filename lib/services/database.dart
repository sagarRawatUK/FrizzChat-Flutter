import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo(Map usermap) {
    FirebaseFirestore.instance.collection("users").add(usermap);
  }

  createChatRoom(String chatRoomId, Map chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .set(chatRoomMap);
  }

  addChatMessages(String chatRoomId, Map chatMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChatMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
