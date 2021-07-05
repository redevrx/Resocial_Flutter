import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class PostModel {
  String body;
  String commentCount;
  String date;
  String time;
  List urls;
  List urlsType;
  Map likeResults;
  String likesCount;
  String postId;
  String uid;
  String type;

  PostModel({
    this.type,
    this.body,
    this.commentCount,
    this.likeResults,
    this.date,
    this.time,
    this.urls,
    this.urlsType,
    this.likesCount,
    this.postId,
    this.uid,
  });

  //to json
  PostModel.fromJson(DocumentSnapshot json)
      : body = json.get("body"),
        commentCount = json.get("commentCount"),
        date = json.get("date"),
        time = json.get("time"),
        urls = json.get("urls"),
        urlsType = json.get("urlsType"),
        likeResults = json.get("likeResult"),
        likesCount = json.get("likesCount"),
        postId = json.get("postId"),
        type = json.get("type"),
        uid = json.get("uid");

  PostModel.fromJson2(QueryDocumentSnapshot json)
      : body = json.get("body"),
        commentCount = json.get("commentCount"),
        date = json.get("date"),
        time = json.get("time"),
        urls = json.get("urls"),
        urlsType = json.get("urlsType"),
        likeResults = json.get("likeResult"),
        likesCount = json.get("likesCount"),
        postId = json.get("postId"),
        type = json.get("type"),
        uid = json.get("uid");

  Future<String> getUID() async {
    try {
      final _mAuth = await FirebaseAuth.instance.currentUser;
      if (await _mAuth.uid.toString() == null) {
        return "";
      }
      return await _mAuth.uid.toString();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUserDetail() async {
    DocumentSnapshot doc;
    final _mRef = FirebaseFirestore.instance;
    await _mRef.collection('user info').doc(this.uid).get().then((value) {
      doc = value;
    }).catchError((e) {
      print(e);
    });

    return doc;
  }

  bool getUserLikePost(String currentUid) {
    //print('Current User Id:${uid}');
    bool result = false;
    if (likeResults.toString().length <= 2) {
      result = false;
    } else {
      //var uid = await getUID();
      //print('change :${likeResults['JjmL5jvV8nd4Sl2FhOxrjyym4Mo1']}');
      // likeResults.values.forEach((it) {
      //   if (uid == it.toString()) {
      //     result = true;
      //     //print('User like Id:${it} userId:${uid}');
      //   } else {
      //     result = false;
      //     //print('Not like Id:${it} userId:${uid}');
      //   }
      // });
      // print("like result id: ${likeResults['${currentUid}']}");

      //step
      /*
      1 data structure like :[
        "uid":"uid", -> current user login id
        "asjiodja":asjiodja
      ]

      on post if uid field == uid
      current user did like this psot
      but but uid field != user not like this post
      //or uid field == null

      if like return true else false
      //
       */
      if (likeResults['${currentUid}'] == currentUid) {
        result = true;
      } else {
        result = false;
      }
    }
    // print("like result t f:$result");
    return result;
  }

  Map toJson() {
    return {
      'body': body,
      'type': type,
      'commentCount': commentCount,
      'likeResult': likeResults,
      'date': date,
      'time': time,
      'urls': urls,
      'urlsType': urlsType,
      'likesCount': likesCount,
      'postId': postId,
      'uid': uid,
    };
  }
}
