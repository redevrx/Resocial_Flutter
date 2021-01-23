import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class ChatRepository {
  //make mwthod save chat info user
  // keep freind info of current  in list chat
  Future<bool> onSavefriendInfoChatList(
      String senderId, FrindsModel friendModel) async {
    //path keep chat list info
    final mChatRef = FirebaseFirestore.instance.collection("ChatsList");
    final mMessageRef = FirebaseFirestore.instance.collection("Messages");

    var lastMessage = "";
    var timeOfLastMessage = "";

    await mMessageRef
        .doc("${senderId}")
        .collection("${friendModel.uid}")
        .get()
        .then((message) {
      lastMessage = message.docs[0]["message"].toString();
      timeOfLastMessage = message.docs[0]["time"].toString();
    }).catchError((e) {
      //
      lastMessage = "";
      timeOfLastMessage = "";
    });

    Map friendChatInfo = HashMap<String, String>();
    //there is data structor maybe FrindsModel
    friendChatInfo["uid"] = friendModel.uid;
    friendChatInfo["name"] = friendModel.userName;
    friendChatInfo["lastMessage"] = lastMessage;
    friendChatInfo["time"] = timeOfLastMessage;
    friendChatInfo["profile"] = friendModel.imageProfile;

    //save data
    await mChatRef.doc("${senderId}").set(friendChatInfo).then((value) {
      print("save chat sender info list successfully");
    }).catchError((e) {
      print("save chat sender error :${e}");
    });
  }
  //
}
