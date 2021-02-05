// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:socialapp/call/model/call_model.dart';
// import 'package:socialapp/call/repository/call_agora_repository.dart';
// import 'package:socialapp/call/screen/call_screen.dart';

// class CallUtility {
//   static final CallAgoraRepository callAgoraRepository = CallAgoraRepository();

//   //database path
//   static final mRef = FirebaseFirestore.instance.collection("user info");

//   //initial info call
//   static dial({String senderId, String receiverId, context}) async {
//     String senderName = "";
//     String senderPic = "";
//     String receiverName = "";
//     String receiverPic = "";

//     //get info data sender
//     await mRef.doc("$senderId").get().then((info) {
//       senderName = info["user"].toString();
//       senderPic = info['imageProfile'].toString().isEmpty
//           ? 'https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg'
//           : '${info['imageProfile']}';
//     }).catchError((e) {
//       senderName = "";
//       senderPic = "";
//     });

//     //get info data receiver
//     await mRef.doc("$receiverId").get().then((info) {
//       receiverName = info["user"].toString();
//       receiverPic = info['imageProfile'].toString().isEmpty
//           ? 'https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg'
//           : '${info['imageProfile']}';
//     }).catchError((e) {
//       receiverName = "";
//       receiverPic = "";
//     });

//     //model
//     CallModel callModel = CallModel(
//       callId: senderId,
//       callName: senderName,
//       callPic: senderPic,
//       receiverId: receiverId,
//       receiverName: receiverName,
//       receiverPic: receiverPic,
//       channelId: Random().nextInt(1000).toString(),
//     );

//     //start call
//     bool callMade = await callAgoraRepository.onMakeCall(call: callModel);
//     //
//     callModel.hasDialled = true;

//     if (callMade) {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => CallScreen(
//           call: callModel,
//           uid: receiverId,
//         ),
//       ));
//     }
//   }
// }
