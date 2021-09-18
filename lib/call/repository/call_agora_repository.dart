import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socialapp/call/model/call_model.dart';
import 'package:socialapp/call/repository/call_repository.dart';
import 'package:socialapp/call/screen/call_screen.dart';
import 'package:http/http.dart' as http;
import 'package:socialapp/utils/utils.dart';

class CallAgoraRepository implements CallRepository {
  //database path
  final mCallRef = FirebaseFirestore.instance.collection("call");

  //call this method for start call
  @override
  Future<bool> onMakeCall({CallModel call}) async {
    try {
      //
      call.hasDialled = true;
      //make map call
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      //
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      //keep data call to firestore
      await mCallRef.doc(call.callId).set(hasDialledMap);
      //
      await mCallRef.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print("make call error :$e");
      return false;
    }
  }

  //call this method for end call
  @override
  Future<bool> onEndCall({CallModel call}) async {
    try {
      //remove call id
      await mCallRef.doc(call.callId).delete();

      //remove receiver id in call database path
      await mCallRef.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print('call end error :$e');
      return false;
    }
  }

  Stream<DocumentSnapshot> CallStream1({String uid}) {
    if (FirebaseAuth.instance.currentUser != null) {
      return mCallRef.doc(FirebaseAuth.instance.currentUser.uid).snapshots();
    }
  }

  @override
  Stream<CallModel> CallStream({String uid}) {
    PublishSubject<CallModel> _callStream = PublishSubject();

    mCallRef.doc(FirebaseAuth.instance.currentUser.uid).snapshots().map((it) {
      final call = CallModel.formMap(it.data());

      _callStream.add(call);
    });

    _callStream.stream;
  }

  //start call
  //keep info call to database
  //and request token call
  @override
  void dial(
      {String senderId,
      String receiverId,
      String channelName,
      bool type,
      BuildContext context}) async {
    //database path
    final mRef = FirebaseFirestore.instance.collection("user info");

    //initial info call

    String senderName = "";
    String senderPic = "";
    String receiverName = "";
    String receiverPic = "";
    String tokenCall = "";

    await http.Client()
        .get(Uri.parse(TOKEN_URL +
            'token?channelName=$channelName&uid=0&role=publisher&expireTime=3600'))
        .then((token) {
      Map t = jsonDecode(token.body);
      tokenCall = t['token'];
      print('${token.body}');
    }).catchError((e) => print(e));

    //get info data sender
    await mRef.doc("$senderId").get().then((info) {
      senderName = info["user"].toString();
      senderPic = info['imageProfile'].toString().isEmpty
          ? CALL_ICON_USER
          : '${info['imageProfile']}';
    }).catchError((e) {
      senderName = "";
      senderPic = "";
    });

    //get info data receiver
    await mRef.doc("$receiverId").get().then((info) {
      receiverName = info["user"].toString();
      receiverPic = info['imageProfile'].toString().isEmpty
          ? CALL_ICON_USER
          : '${info['imageProfile']}';
    }).catchError((e) {
      receiverName = "";
      receiverPic = "";
    });

    //model
    CallModel callModel = CallModel(
        callId: senderId,
        callName: senderName,
        callPic: senderPic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        channelName: channelName,
        token: tokenCall,
        typeCall: type);

    //start call
    bool callMade = await this.onMakeCall(call: callModel);
    //
    callModel.hasDialled = true;

    if (callMade) {
      print('start dual success go to Call Screen');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreen(
          call: callModel,
          uid: receiverId,
        ),
      ));
    }
  }
}
