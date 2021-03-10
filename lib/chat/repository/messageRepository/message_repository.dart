import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:socialapp/chat/models/chat/chat_list_info.dart';
import 'package:socialapp/chat/models/chat/chat_model.dart';
import 'package:http/http.dart' as http;

class MessageRepository {
/**
 update chat list info
 update only alert time and message 
 */
  Future<void> onUpdateChatListInfoLastMessage(
      String senderId, String receiveId, String message, String time) async {
    final mChatRef = FirebaseFirestore.instance.collection("ChatsList");
    final mChatReceiveRef = FirebaseFirestore.instance.collection("ChatsList");
    final mChatSenderRef = FirebaseFirestore.instance.collection("ChatsList");

    //read alert number of receive
    int receiveAlertNumber = 0;
    await mChatRef
        .doc("${receiveId}")
        .collection("list")
        .doc("${senderId}")
        .get()
        .then((chatListInfo) {
      if (chatListInfo.get("alert").toString() == "0" ||
          chatListInfo.get("alert").toString() == null) {
        receiveAlertNumber = 0;
      } else {
        receiveAlertNumber = int.parse(chatListInfo.get("alert").toString());
      }
    }).catchError((e) {
      receiveAlertNumber = 0;
    });
    //

    //update of sender and if message send from current alert as 0
    await mChatSenderRef
        .doc("${senderId}")
        .collection("list")
        .doc("${receiveId}")
        .update({'alert': '0', 'lastMessage': '${message}', 'time': "${time}"})
        .then((value) => print("update last message sender success"))
        .catchError((e) => print("update last message sender error :${e}"));

    //update receive and laert =  oln value + = 1
    await mChatReceiveRef
        .doc("${receiveId}")
        .collection("list")
        .doc("${senderId}")
        .update({
          'alert': '${receiveAlertNumber += 1}',
          'lastMessage': '${message}',
          'time': "${time}"
        })
        .then((value) => print("update last message receive success"))
        .catchError((e) => print("update last message receive error :${e}"));
  }

//
/**
 this method will send message between current user with freind 
 in chat room
 case send message with image
 will upload image to firebase server after
 and will save text data or message to firebase server
 */
  Future<bool> onSendMessage(String senderId, String receiveId,
      ChatListInfo model, String type, String message, File image) async {
    //database path
    final mMessageSenderRef =
        FirebaseDatabase.instance.reference().child("Messages");
    // final _messageKey = FirebaseFirestore.instance.collection("Messages");
    final mMessageReceiveRef =
        FirebaseDatabase.instance.reference().child("Messages");

    //FirebaseFirestore.instance.collection("Messages");
    final mSenderInfo = FirebaseFirestore.instance.collection("user info");

    var senderName = "";
    var senderImage = "";
    final now = DateTime.now();
    var time = DateFormat("H:m:s:dd:MM:yyyy").format(now);
    var messageId = mMessageSenderRef.child("").push().key.toString();
    //_messageKey.doc("s").collection("Post").doc().id;
    bool checkResul = false;

    //read sender info
    await mSenderInfo.doc("${senderId}").get().then((info) {
      senderName = info["user"].toString();
      senderImage = info["imageProfile"].toString();
    }).catchError((e) {
      senderName = "";
      senderImage = "";
    });

    //map message structor sender
    Map messageSender = HashMap<String, dynamic>();
    messageSender['type'] = type;
    messageSender['time'] = time;
    messageSender['from'] = senderId;
    messageSender['message'] = message;
    messageSender['to'] = receiveId;
    messageSender['messageId'] = messageId;
    messageSender["image"] = '';
    messageSender['senderName'] = senderName;
    messageSender['senderImage'] = senderImage;

    //map message structor sender
    Map messageReceive = HashMap<String, dynamic>();
    messageReceive['type'] = type;
    messageReceive['time'] = time;
    messageReceive['from'] = senderId;
    messageReceive['message'] = message;
    messageReceive['to'] = receiveId;
    messageReceive['messageId'] = messageId;
    messageReceive["image"] = '';
    messageReceive['senderName'] = model.name;
    messageReceive['senderImage'] = model.image;

    // send message of receive
    await mMessageReceiveRef
        .child("${receiveId}")
        .child("${senderId}")
        .child("${messageId}")
        .set(messageReceive)
        .then((value) {
      print('send message receive success');
    }).catchError((e) {
      print("send message receive error ${e}");
    });

    // send message of sender
    await mMessageSenderRef
        .child("${senderId}")
        .child("${receiveId}")
        .child("${messageId}")
        .set(messageSender)
        .then((value) {
      print('send message sender success');
      checkResul = true;
    }).catchError((e) {
      checkResul = false;
      print("send message sender error ${e}");
    });

    await onUpdateChatListInfoLastMessage(
        senderId, receiveId, message, "${time}");

    await sendNotifyTOFriend(receiveId, model.name, message);

    //
    return checkResul;
  }
  //

  /*
  remove message that current user send to friend
  if message that is last message give update chat list info 
  as unsend 
   */

  Future<Null> onRemoveMessage(
      String senderId, String receiveId, String messageId) async {
    //data base path
    final mMessageSenderRef =
        FirebaseDatabase.instance.reference().child("Messages");
    final mMessageReceiveRef =
        FirebaseDatabase.instance.reference().child("Messages");

    //get time
    final now = DateTime.now();
    var time = DateFormat("H:m:s:dd:MM:yyyy").format(now);
    //remove message from database
    await mMessageSenderRef
        .child("${senderId}")
        .child("${receiveId}")
        .child("${messageId}")
        .remove()
        .then((value) => print("unSend Message sender success"))
        .catchError((e) => print('unSend message sender error :${e}'));

    await mMessageReceiveRef
        .child("${receiveId}")
        .child("${senderId}")
        .child("${messageId}")
        .remove()
        .then((value) => print("unSend Message receive success"))
        .catchError((e) => print('unSend message receive error :${e}'));

    //update chat list info
    await onUpdateChatListInfoLastMessage(senderId, receiveId, "unSend", time);
  }

  /*
  read message chat between current user and friend
   */
  var _mMessage = FirebaseDatabase.instance.reference().child("Messages");
  List<ChatModel> _messageModel = [];

  //
  Stream<List<ChatModel>> onReadMessage(String senderId, String receiveId) {
    print("start load message");
    //database path
    final _messageController = PublishSubject<List<ChatModel>>();
    //
    // var now = DateTime.now();
    // var time = DateFormat("H:m:s:dd:MM:yyyy").format(now);

    _mMessage
        .child("${senderId}")
        .child("${receiveId}")
        .onValue
        .listen((message) {
      _messageModel = [];
      final map = message.snapshot.value;
      if (map != null) {
        List<dynamic> list = map.values.toList();
        Iterable i = list;
        _messageModel = i.map((e) => ChatModel.fromJson3(e)).toList();
        // _messageModel.sort((a, b) => a.time.compareTo('$time'));
        // ..sort((a, b) => b['time'].compareTo(a['time']));
        _messageController.add(_messageModel);
      } else {
        _messageModel = [];
        _messageController.add([]);
      }

      // Map<dynamic, dynamic>.from(message.snapshot.value).forEach((k, v) {
      //   _messageModel.add(new ChatModel.fromJson3(v));

      //   _messageController.add(_messageModel);
      // });
    });

    return _messageController.stream;
  }

  Future<void> closeController() async {
    // _messageController?.done;
    // _messageController?.close();
    _messageModel = [];
    _mMessage.onDisconnect();
  }

  Future sendNotifyTOFriend(
      String friendId, String friendName, String message) async {
    final _mRef = FirebaseFirestore.instance;
    _mRef.collection("user info").doc(friendId).get().then((info) async {
      final token =
          "AAAAqTVcAxY:APA91bFEdF2P_svKU7oOJ__XdVI6jTfjI-fP_2x0tpWEW9Z-xut891GBLAmTIYv4S5LwGtEc1Jn3_tMAoRiX5SVShXHOIvopdCBEHDM6IjZ7dQ9UnhXhikr_rZD7fl7cOAuGkb_iyQE0";
      var deviceToken = "";
      try {
        deviceToken = (info.get("deviceToken").toString() != null)
            ? info.get("deviceToken").toString()
            : "";
      } catch (e) {
        print("$e");
      }

      //create notify data
      Map<Object, Object> notifyData = HashMap();
      notifyData['body'] = friendName + ":$message";
      notifyData['title'] = "New Caht";
      notifyData['icon'] = "";

      //create notify head
      Map<Object, Object> notifyHead = HashMap();
      notifyHead['to'] = deviceToken;
      notifyHead['notification'] = notifyData;

      //http post to FCM

      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Authorization': 'key=$token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(notifyHead));
    });
  }
}
