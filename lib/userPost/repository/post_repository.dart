import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

class PostRepository {
  //update user post
  //step 1 check post have image ?
  //if yes gave remove image
  //step 2 check post not have image
  //step 3 re post with content
  Future<String> onUpdatePost(
      String uid,
      String message,
      File image,
      String url,
      String postId,
      String like,
      String comment,
      String type) async {
    bool va = false;
    String result = "";
    final _mRef = FirebaseFirestore.instance;

    //map to json
    Map mapBody = HashMap<String, dynamic>();

    //get date time
    final now = DateTime.now();
    var date = DateFormat("yyyy-MM-dd").format(now);
    // String mDate = date.format(dateTime);
    var time = DateFormat("H:m:s").format(now);
    // String mTime = time.format(dateTime);

    //check type update image or message
    if (type == 'image') {
      //image
      //check user update image
      if (image != null && url.isEmpty) {
        // user update image
        print('update post image');

        final _mRefFile =
            FirebaseStorage().ref().child("Post Image").child("Images");

        //save image to data storage
        final uploadTask = _mRefFile.child(postId).putFile(image);

        String urlImage =
            await (await uploadTask.onComplete).ref.getDownloadURL();

        //make map to json
        mapBody["uid"] = uid;
        mapBody["postId"] = postId;
        mapBody["body"] = message;
        mapBody["image"] = "${urlImage}";
        mapBody['date'] = date;
        mapBody['time'] = time;
        mapBody['type'] = 'image';
        mapBody['likesCount'] = "${like}";
        mapBody['commentCount'] = "${comment}";

        await _mRef.collection("Post").doc(postId).update(mapBody).then((_) {
          print("Update post successful..");

          va = true;
        });
      } else {
        // user not update image
        print('not update post image');
        //make map to json
        mapBody["uid"] = uid;
        mapBody["postId"] = postId;
        mapBody["body"] = message;
        mapBody["image"] = "${url}";
        mapBody['date'] = date;
        mapBody['time'] = time;
        mapBody['type'] = 'image';
        mapBody['likesCount'] = "${like}";
        mapBody['commentCount'] = "${comment}";

        await _mRef.collection("Post").doc(postId).update(mapBody).then((_) {
          print("Update post successful..");

          va = true;
        });
      }
    } else {
      print('update post message');
      //message
      //make map to json
      mapBody["uid"] = uid;
      mapBody["postId"] = postId;
      mapBody["body"] = message;
      mapBody["image"] = "";
      mapBody['date'] = date;
      mapBody['time'] = time;
      mapBody['type'] = 'message';
      mapBody['likesCount'] = "${like}";
      mapBody['commentCount'] = "${comment}";

      await _mRef.collection("Post").doc(postId).update(mapBody).then((_) {
        print("Update post successful..");

        va = true;
      });
    }

    //check value and return
    if (va) {
      result = 'successful';
    } else {
      result = 'faield';
    }

    return result;
  }

//remove post
//1 remove image from firebase storegae if have ?
//2 remove post from firestore
  Future<void> removePost(String postId) async {
    final _mRef = FirebaseFirestore.instance;
    final _mRefFile =
        FirebaseStorage().ref().child("Post Image").child("Images");

    try {
      await _mRefFile
          .child(postId)
          .delete()
          .then((value) => print('remove image success'))
          .catchError((e) => print(e));

      await _mRef
          .collection('Post')
          .doc(postId)
          .delete()
          .then((value) => print('remove post success'))
          .catchError((e) => print(e));

      await _mRef
          .collection('comments')
          .doc(postId)
          .delete()
          .then((value) => print('remove comments success'))
          .catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  }

//create new post
//post with image |check|
// post wuth message not image |check|
//if there is giav upload image to firebase storage before
//and make save content post to firestore
  Future<String> onCreatePost(String uid, String message, File image) async {
    bool va = false;
    String result = "";

    final _mRef = FirebaseFirestore.instance;
    final _mRefFile =
        FirebaseStorage().ref().child("Post Image").child("Images");

    final key = _mRef.collection("Post").doc().id;
    Map mapBody = HashMap<String, dynamic>();

    //get date time
    final now = DateTime.now();
    var date = DateFormat("yyyy-MM-dd").format(now);
    // String mDate = date.format(dateTime);

    var time = DateFormat("H:m:s").format(now);
    // String mTime = time.format(dateTime);

    //check user post with message or image
    if (image != null) {
      //post message with image

      //save image to data storage
      final uploadTask = _mRefFile.child(key).putFile(image);

      String url = await (await uploadTask.onComplete).ref.getDownloadURL();

      //make map to json
      mapBody["uid"] = uid;
      mapBody["postId"] = key;
      mapBody["body"] = message;
      mapBody["image"] = "${url}";
      mapBody['date'] = date;
      mapBody['time'] = time;
      mapBody['type'] = 'image';
      mapBody['likeResult'] = {};
      mapBody['likesCount'] = "0";
      mapBody['commentCount'] = "0";

      await _mRef.collection("Post").doc(key).set(mapBody).then((_) {
        print("post successful..");

        va = true;
      });
    } else {
      //post with message

      //make map to json
      mapBody["uid"] = uid;
      mapBody["postId"] = key;
      mapBody["body"] = message;
      mapBody["image"] = "";
      mapBody['date'] = date;
      mapBody['time'] = time;
      mapBody['type'] = 'message';
      mapBody['likeResult'] = {};
      mapBody['likesCount'] = "0";
      mapBody['commentCount'] = "0";

      await _mRef.collection("Post").doc(key).set(mapBody).then((_) {
        print("post successful..");

        va = true;
      });
    }

    //check value and return
    if (va) {
      result = 'successful';

      /*
      if post create success give create notify data  
      Notifications {
IdPOST:{
date:,
message:"",
time:'',
uid:'',
type:'' 
}
}
      */

      await createNotificaionsPost(key, uid, date, time, message, "new feed");
    } else {
      result = 'faield';
    }

    return result;
  }

//craete notification of user post
  Future createNotificaionsPost(String key, String uid, String date,
      String time, String message, String type) async {
    print('init create notify post of user');
    final _mRef = FirebaseFirestore.instance;
    var name = '';

    // map keep  detail notification
    final notifyData = Map<String, String>();
    notifyData['date'] = date;
    notifyData['time'] = time;
    notifyData['uid'] = uid;
    notifyData['onwerId'] = uid;
    notifyData['type'] = type;
    notifyData['postID'] = key;
    notifyData['message'] = message;
    notifyData['profileUrl'] =
        await _mRef.collection("user info").doc(uid).get().then((info) {
      name = info.get("user").toString();
      return info.get('imageProfile').toString();
    });
    notifyData['name'] = '${name}';

    await _mRef
        .collection("friends")
        .doc(uid)
        .collection("status")
        .get()
        .then((user) async {
      for (int i = 0; i < user.docs.length; i++) {
        final friendId = user.docs[i].id.toString();

        (friendId != uid) ? await sendNotifyTOFriend(friendId, name) : null;
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
          (friendId != uid) ? await counterNotifyChange(friendId) : null;
        });
      }
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

  Future sendNotifyTOFriend(String friendId, String friendName) async {
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
      notifyData['body'] = friendName + " give create new post now";
      notifyData['title'] = "New Post";
      notifyData['icon'] = "";

      //create notify head
      Map<Object, Object> notifyHead = HashMap();
      notifyHead['to'] = deviceToken;
      notifyHead['notification'] = notifyData;

      //http post to FCM

      await http.post('https://fcm.googleapis.com/fcm/send',
          headers: {
            'Authorization': 'key=$token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(notifyHead));
    });
  }

  // void _initialBackgound(String uid) {
  //   if (Platform.isIOS) {
  //     // ios setting task
  //   } else {
  //     // android setting task
  //     Workmanager.initialize(_callbackDispatcher, isInDebugMode: true);
  //     Workmanager.registerPeriodicTask("sendNotifyToFriend", "PostNotify",
  //         initialDelay: Duration(minutes: 2), frequency: Duration(minutes: 15));
  //   }
  // }

  // void _callbackDispatcher() {
  //   Workmanager.executeTask((taskName, inputData) async {
  //     print('start service send notify post ');
  //     final _mRef = FirebaseFirestore.instance;
  //     _mRef.collection("friends").doc(userId).get().then((user) {});
  //     return Future.value(true);
  //   });
  // }
}
