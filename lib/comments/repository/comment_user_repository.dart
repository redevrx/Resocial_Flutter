import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/comments/models/comment_model.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:http/http.dart' as http;

class CommentRepository {
  //load comment of post use post id
  //return stream
  Stream<List<CommentModel>> loadComments(String postId) {
    final _mRef = FirebaseFirestore.instance;

    return _mRef
        .collection('comments')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) => CommentModel.fromJson(e.data())).toList();
    });
  }

//user wirte comment in post
  Future<bool> addComment(PostModel postModel, String message) async {
    bool result;
    var userName = '';
    var imageProfile = '';

    final _pref = await SharedPreferences.getInstance();

    final uid = _pref.getString("uid");

    final _mRef = FirebaseFirestore.instance;
    final _mRefUser = FirebaseFirestore.instance;

    //load detail user that comment this post
    await _mRefUser.collection('user info').doc(uid).get().then((value) async {
      userName = value.get("user").toString();
      imageProfile = value.get("imageProfile").toString();
    }).catchError((e) {
      print(e);
    });

/////////////////////////////////////////////////////////////////////////////////////
    ///
    ///
    //date time
    var now = DateTime.now();
    var time = DateFormat('H:m:s').format(now);
    var day = DateFormat('yyyy-MM-dd').format(now);
    String commentId = _mRef.collection("comments").doc().id;

    Map<String, dynamic> mapBody = HashMap();
    //comment detail
    mapBody['postId'] = postModel.postId;
    mapBody['commentId'] = commentId;
    mapBody['body'] = message.trim();
    mapBody['time'] = '${time}';
    mapBody['day'] = '${day}';
    //user commentd detail
    mapBody['userName'] = userName;
    mapBody['uid'] = uid;
    mapBody['imageProfile'] = imageProfile;

    //set path db
    await _mRef
        .collection('comments')
        .doc(postModel.postId)
        .collection('comments')
        .doc(commentId)
        .set(mapBody)
        .then((value) => result = true)
        .catchError((e) => result = false);

    if (result) {
      //add count comment one
      await addCountComment(postModel.postId, postModel.commentCount);

      //create notify comment
      createNotifyComment(postModel.postId, uid, day, time, message, userName,
          imageProfile, "comment");
      return result;
    } else {
      return result;
    }
  }

  Future<void> addCountComment(String postId, String commentCount) async {
    final _mRef = FirebaseFirestore.instance;

    await _mRef
        .collection('Post')
        .doc(postId)
        .update({'commentCount': '${int.parse(commentCount) + 1}'})
        .then((value) => print('value : Comment Success'))
        .catchError((e) => print(e));
  }

//craete notification of user post
  Future createNotifyComment(String key, String uid, String date, String time,
      String message, String name, String imageProfile, String type) async {
    print('init create notify post of user');
    final _mRef = FirebaseFirestore.instance;

    // map keep  detail notification
    final notifyData = Map<String, String>();
    notifyData['date'] = date;
    notifyData['time'] = time;
    notifyData['uid'] = uid;
    notifyData['onwerId'] = uid;
    notifyData['type'] = type;
    notifyData['postID'] = key;
    notifyData['message'] = message;
    notifyData['profileUrl'] = imageProfile;
    notifyData['name'] = '${name}';

//get user all that comment this post
//for send notify
    await _mRef
        .collection("comments")
        .doc(key)
        .collection("comments")
        .get()
        .then((user) async {
      for (int i = 0; i < user.docs.length; i++) {
        final friendId = user.docs[i].get("uid").toString();

        await sendNotifyTOFriend(friendId, name, message);
        // //create firebase firestore instand
        // //save
        _mRef
            .collection("Notifications")
            .doc(friendId)
            .collection("notify")
            .doc(key)
            .set(notifyData)
            .then((value) async {
          print("create notify success..");
          await counterNotifyChange(friendId);
        });
      }
    });
  }

  Future<bool> updateComment(
      String postId, String commentId, String message) async {
    final _mRef = FirebaseFirestore.instance.collection("comments");
    // CommentModel model = CommentModel();

    // await _mRef
    //     .doc(postId)
    //     .collection("comments")
    //     .doc(commentId)
    //     .get()
    //     .then((value) {
    //   model = CommentModel.fromJson(value.data());
    // }).catchError((e) {
    //   print("laod comment info for update error :" + e);
    // });

    //update comment
    // model.body = message;

    await _mRef
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .update({"body": message})
        .then((value) => true)
        .catchError((e) {
          print("laod comment info for update error :" + e);
          return false;
        });
  }

  Future sendNotifyTOFriend(
      String friendId, String friendName, String message) async {
    final _mRef = FirebaseFirestore.instance;
    _mRef.collection("user info").doc(friendId).get().then((info) async {
      final token =
          "AAAAqTVcAxY:APA91bFEdF2P_svKU7oOJ__XdVI6jTfjI-fP_2x0tpWEW9Z-xut891GBLAmTIYv4S5LwGtEc1Jn3_tMAoRiX5SVShXHOIvopdCBEHDM6IjZ7dQ9UnhXhikr_rZD7fl7cOAuGkb_iyQE0";
      final deviceToken = info.get("deviceToken").toString();

      //create notify data
      Map<Object, Object> notifyData = HashMap();
      notifyData['body'] = "${message}";
      notifyData['title'] = "${friendName} give Comment";
      notifyData['icon'] = "";

      //create notify head
      Map<Object, Object> notifyHead = HashMap();
      notifyHead['to'] = deviceToken;
      notifyHead['notification'] = notifyData;

      //http post to FCM
      await http.Client().post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Authorization': 'key=$token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(notifyHead));
    });
  }

  //increment notify counter
  Future counterNotifyChange(String friendId) async {
    final _mRef = FirebaseFirestore.instance;
    //load counter notification and + 1
    try {
      await _mRef
          .collection("Notifications")
          .doc(friendId)
          .collection("counter")
          .doc("counter")
          .get()
          .then((counterNotify) {
        if (counterNotify.data() == null) {
          //new counter 0
          int c = 0;
          _mRef
              .collection("Notifications")
              .doc(friendId)
              .collection("counter")
              .doc('counter')
              .set({'counter': c += 1});
        } else {
          //current + = 1
          int c = 0;
          c = int.parse(counterNotify.get('counter').toString());
          _mRef
              .collection("Notifications")
              .doc(friendId)
              .collection("counter")
              .doc('counter')
              .set({'counter': c += 1});
        }
      });
    } catch (e) {
      //new counter 0
      print(e);
      // int c = 0;
      // _mRef
      //     .collection("Notifications")
      //     .doc(friendId)
      //     .collection("notify")
      //     .doc("counter")
      //     .set({'counter': c += 1});
    }
  }

//remove comment
  Future<bool> removeComment(String postId, String commentId) async {
    final mRef = FirebaseFirestore.instance.collection("comments");
    print("starting remove comment");
    return await mRef
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .delete()
        .then((value) {
      unCountComment(postId);
      return true;
    }).catchError((e) {
      print("remove comment user in post Id error :" + e);
      return false;
    });
  }

  Future<void> unCountComment(String postId) async {
    final _mRef = FirebaseFirestore.instance;

    int commentCount = 0;

//get old comment count
    await _mRef.collection("Post").doc(postId).get().then((value) {
      final data = value.data()['commentCount'];
      if (data != null && data != "") {
        commentCount = int.parse(data);
      } else {
        commentCount = 0;
      }
    }).catchError((e) {
      print("get comment count error :" + e);
    });

    //update new comment
    await _mRef
        .collection('Post')
        .doc(postId)
        .update({'commentCount': '${commentCount - 1}'})
        .then((value) => print('value : Comment Success'))
        .catchError((e) => print(e));
  }
}
