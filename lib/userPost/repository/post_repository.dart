import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class PostRepository {
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
    } catch (e) {
      print(e);
    }
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
  }

  Future<String> onCreatePost(String uid, String message, File image) async {
    bool va = false;
    String result = "";

    final _mRef = FirebaseFirestore.instance;
    final _mRefFile =
        FirebaseStorage().ref().child("Post Image").child("Images");

    final key = _mRef.collection("PostP").id;
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
    } else {
      result = 'faield';
    }

    return result;
  }
}
