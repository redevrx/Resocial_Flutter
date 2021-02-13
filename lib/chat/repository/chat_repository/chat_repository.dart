import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socialapp/chat/models/chat/chat_list_info.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class ChatRepository {
  //make mwthod save chat info user
  // keep freind info of current  in list chat
  Future<bool> onSavefriendInfoChatList(String senderId,
      List<FrindsModel> friendModel, String groupName, File image) async {
    //path keep chat list info
    final mChatSenderRef = FirebaseFirestore.instance.collection("ChatsList");
    final mChatReceiveRef = FirebaseFirestore.instance.collection("ChatsList");
    final mSenderInfo = FirebaseFirestore.instance.collection("user info");
    final mStorage = FirebaseStorage.instance.ref().child("GroupIcons");
    final mRef = FirebaseFirestore.instance.collection("Participants");

    // var lastMessage = "";
    // var timeOfLastMessage = "";
    var senderName = "";
    var senderImage = "";
    var senderStatus = "";
    var now = DateTime.now();
    var time = DateFormat("H:mm:ss:dd:MM:yyyy").format(now);

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

    //check type create chat room
    //if friendModel == 1 is one to one chat
    //then is group chat

    if (friendModel.length == 1) {
      //one to one chat
      //start create
      //map data of sender
      Map friendChatInfoSender = HashMap<String, dynamic>();
      //there is data structor maybe FrindsModel
      friendChatInfoSender["uid"] = friendModel[0].uid;
      friendChatInfoSender["name"] = friendModel[0].userName;
      friendChatInfoSender["lastMessage"] = "Create Chat Room";
      friendChatInfoSender["time"] = "${time}";
      friendChatInfoSender["profile"] = friendModel[0].imageProfile;
      friendChatInfoSender['alert'] = "0";
      friendChatInfoSender["type"] = "person";
      friendChatInfoSender["groupId"] = "";
      friendChatInfoSender["createBy"] = "";
      friendChatInfoSender["participant"] = [];
      friendChatInfoSender['status'] = friendModel[0].status;

      //map data of receive
      Map friendChatInfoReceive = HashMap<String, dynamic>();
      //there is data structor maybe FrindsModel
      friendChatInfoReceive["uid"] = senderId;
      friendChatInfoReceive["name"] = senderName;
      friendChatInfoReceive["lastMessage"] = "Create Chat Room";
      friendChatInfoReceive["time"] = "$time";
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
          .doc("${friendModel[0].uid}")
          .set(friendChatInfoSender)
          .then((value) {
        print("save chat sender info list successfully");
      }).catchError((e) {
        print("save chat sender error :${e}");
      });

      //save data receive
      await mChatReceiveRef
          .doc("${friendModel[0].uid}")
          .collection("list")
          .doc("${senderId}")
          .set(friendChatInfoReceive)
          .then((value) {
        print("save chat receive info list successfully");
      }).catchError((e) {
        print("save chat sender error :${e}");
      });
    } else {
      var urlImage = '';
      //generate group id
      var groupId = mChatReceiveRef.doc().collection("group").doc().id;

      //put file to server
      var process = mStorage.child("${groupId}").putFile(image);
      //download url if image
      urlImage = await (await process.onComplete).ref.getDownloadURL();
      //

      //save room chat by creator
      //map data of sender
      Map friendChatInfoSender = HashMap<String, dynamic>();
      //there is data structor maybe FrindsModel
      friendChatInfoSender["uid"] = senderId;
      friendChatInfoSender["name"] = "$groupName";
      friendChatInfoSender["lastMessage"] = "Create Group Chat";
      friendChatInfoSender["time"] = "${time}";
      friendChatInfoSender["profile"] = "$urlImage";
      friendChatInfoSender['alert'] = "0";
      friendChatInfoSender["type"] = "group";
      friendChatInfoSender["groupId"] = "$groupId";
      friendChatInfoSender["createBy"] = "$senderName";
      friendChatInfoSender["participant"] = {};
      friendChatInfoSender['status'] = "Group";

      //save data sender
      await mChatReceiveRef
          .doc("${senderId}")
          .collection("list")
          .doc("${groupId}")
          .set(friendChatInfoSender)
          .then((value) {
        print("save chat group participant successfully");
      }).catchError((e) {
        print("save chat sender error :${e}");
      });

      //save sender  Participants group

      await mRef
          .doc("${senderId}")
          .collection("groupPart")
          .doc('${groupId}')
          .set({'groupId': "${groupId}"}).then((_) {
        print("save Participants success");
      }).catchError((e) {
        print("save Participants error :$e");
      });

      //create group chat
      for (int i = 0; i <= friendModel.length; i++) {
        //map data of sender
        Map friendChatInfoSender = HashMap<String, dynamic>();
        //there is data structor maybe FrindsModel
        friendChatInfoSender["uid"] = friendModel[i].uid;
        friendChatInfoSender["name"] = "$groupName";
        friendChatInfoSender["lastMessage"] = "Create Group Chat";
        friendChatInfoSender["time"] = "${time}";
        friendChatInfoSender["profile"] = urlImage ?? "";
        friendChatInfoSender['alert'] = "0";
        friendChatInfoSender["type"] = "group";
        friendChatInfoSender["groupId"] = "$groupId";
        friendChatInfoSender["createBy"] = "$senderName";
        friendChatInfoSender["participant"] = {};
        friendChatInfoSender['status'] = "Group";

        //save group info
        //save data sender
        await mChatSenderRef
            .doc("${friendModel[i].uid}")
            .collection("list")
            .doc("${groupId}")
            .set(friendChatInfoSender)
            .then((value) {
          print("save chat group participant successfully");
        }).catchError((e) {
          print("save chat sender error :${e}");
        });

        await mRef
            .doc("${friendModel[i].uid}")
            .collection("groupPart")
            .doc('${groupId}')
            .set({'groupId': "${groupId}"}).then((_) {
          print("save Participants success");
        }).catchError((e) {
          print("save Participants error :$e");
        });
      }
      //

    }
  }
  //

  //this method will read list chat show in chat home screeb
  //list chat is friend that chat with current user
  PublishSubject _chatListController = PublishSubject<List<ChatListInfo>>();
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
        .collection("list")
        .orderBy("time", descending: true);

    //read data type real-time
    mChatSenderRef.snapshots().map((it) {
      return it.docs.map((e) => ChatListInfo.fromJson(e)).toList();
    }).listen((model) => _chatListController.add(model));

    return _chatListController?.stream;
  }
  //

  void close() async {
    await _chatListController.close();
  }

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
