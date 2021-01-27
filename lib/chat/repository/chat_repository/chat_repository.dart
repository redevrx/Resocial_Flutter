import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialapp/chat/models/chat/chat_list_info.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class ChatRepository {
  //make mwthod save chat info user
  // keep freind info of current  in list chat
  Future<bool> onSavefriendInfoChatList(
      String senderId, FrindsModel friendModel) async {
    //path keep chat list info
    final mChatSenderRef = FirebaseFirestore.instance.collection("ChatsList");
    final mChatReceiveRef = FirebaseFirestore.instance.collection("ChatsList");
    final mSenderInfo = FirebaseFirestore.instance.collection("user info");

    // var lastMessage = "";
    // var timeOfLastMessage = "";
    var senderName = "";
    var senderImage = "";
    var senderStatus = "";

    // await mMessageRef
    //     .doc("${senderId}")
    //     .collection("${friendModel.uid}")
    //     .get()
    //     .then((message) {
    //   lastMessage = message.docs[0]["message"].toString();
    //   timeOfLastMessage = message.docs[0]["time"].toString();
    // }).catchError((e) {
    //   //
    //   lastMessage = "";
    //   timeOfLastMessage = "";
    // });

    /*
    read sender info 
    sender is current user
    and receive is freind that will chat
    read data 
      - user name
      - image profile
     */
    await mSenderInfo.doc(senderId).get().then((info) {
      senderName = info["user"].toString();
      senderImage = info["imageProfile"].toString();
      senderStatus = info["userStatus"].toString();
    }).catchError((e) {
      senderName = "";
      senderImage = "";
      senderStatus = "";
    });

    //map data of sender
    Map friendChatInfoSender = HashMap<String, dynamic>();
    //there is data structor maybe FrindsModel
    friendChatInfoSender["uid"] = friendModel.uid;
    friendChatInfoSender["name"] = friendModel.userName;
    friendChatInfoSender["lastMessage"] = "";
    friendChatInfoSender["time"] = "";
    friendChatInfoSender["profile"] = friendModel.imageProfile;
    friendChatInfoSender['alert'] = "0";
    friendChatInfoSender["type"] = "person";
    friendChatInfoSender["groupId"] = "";
    friendChatInfoSender["createBy"] = "";
    friendChatInfoSender["participant"] = [];
    friendChatInfoSender['status'] = friendModel.status;

    //map data of receive
    Map friendChatInfoReceive = HashMap<String, dynamic>();
    //there is data structor maybe FrindsModel
    friendChatInfoReceive["uid"] = senderId;
    friendChatInfoReceive["name"] = senderName;
    friendChatInfoReceive["lastMessage"] = "";
    friendChatInfoReceive["time"] = "";
    friendChatInfoReceive["profile"] = senderImage;
    friendChatInfoReceive['alert'] = "0";
    friendChatInfoReceive["type"] = "person";
    friendChatInfoReceive["groupId"] = "";
    friendChatInfoReceive["createBy"] = "";
    friendChatInfoReceive["participant"] = [];
    friendChatInfoReceive['status'] = senderStatus;

    //save data sender
    await mChatSenderRef
        .doc("${senderId}")
        .collection("list")
        .doc("${friendModel.uid}")
        .set(friendChatInfoSender)
        .then((value) {
      print("save chat sender info list successfully");
    }).catchError((e) {
      print("save chat sender error :${e}");
    });

    //save data receive
    await mChatReceiveRef
        .doc("${friendModel.uid}")
        .collection("list")
        .doc("${senderId}")
        .set(friendChatInfoReceive)
        .then((value) {
      print("save chat receive info list successfully");
    }).catchError((e) {
      print("save chat sender error :${e}");
    });
  }
  //

  //this method will read list chat show in chat home screeb
  //list chat is friend that chat with current user
  @override
  Stream<List<ChatListInfo>> getListChatInfo(String uid) {
    var _uid = uid;
    if (_uid == null) {
      final mAuth = FirebaseAuth.instance;
      _uid = mAuth.currentUser.uid.toString();
    }

    final mChatSenderRef = FirebaseFirestore.instance
        .collection('ChatsList')
        .doc("${_uid}")
        .collection("list");

    //read data type real-time
    return mChatSenderRef.snapshots().map((it) {
      return it.docs.map((e) => ChatListInfo.fromJson(e)).toList();
    });
  }
  //

  /**
   this method will make update chat room or group chat room
   update name status and image for chat room
   *** uid is id of user that will update name status, image
   such as a is current user b is friend
   a send want to send message to b and b update new profile
   and a call this method then update follow data that change of b

   *** type is type of update such as update chat room or group chat room
   */
  Future<void> onUpdateChatListInfo(
      String senderId, String uid, String type) async {
    //database path
    final mInfoRef = FirebaseFirestore.instance.collection("user info");
    final mChatRef = FirebaseFirestore.instance.collection("ChatsList");

    //case person chat
    var name = "";
    var image = "";
    var status = "";

    await mInfoRef.doc("${uid}").get().then((info) {
      name = info["user"].toString();
      image = info["imageProfile"].toString();
      status = info["userStatus"].toString();
    }).catchError((e) {
      name = "";
      image = "";
      status = "";
    });

    //update info
    await mChatRef.doc("${senderId}").collection("list").doc("${uid}").update({
      'name': '${name}',
      'profile': '${image}',
      'status': "${status}",
      'alert': '0'
    }).then((_) {
      print("update chat room success");
    }).catchError((e) {
      print("update person chat room error :${e}");
    });

    //case group chat
  }
}