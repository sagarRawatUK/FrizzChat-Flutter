import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getGroupByName(String groupName) async {
    return await FirebaseFirestore.instance
        .collection("groupChat")
        .where("chatRoomId", isEqualTo: groupName)
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

  createGroupChatRoom(String groupChatName, Map groupChatMap) {
    FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupChatName)
        .set(groupChatMap);
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

  addGroupChatMessages(String groupChatName, Map groupChatMap) {
    FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupChatName)
        .collection("chats")
        .add(groupChatMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getMap(String groupChatName) async {
    return await FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupChatName)
        .get();
  }

  setMap(String groupChatName, Map groupChatMap) async {
    return await FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupChatName)
        .set(groupChatMap);
  }

  updateMap(String groupChatName, Map groupChatMap) async {
    return await FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupChatName)
        .update(groupChatMap);
  }

  getChatMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getGroupChatMessages(String groupChatName) async {
    return await FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupChatName)
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

  getGroupChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("groupChat")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
