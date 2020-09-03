import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:socialapp/comments/models/comment_model.dart';
import 'package:socialapp/home/export/export_file.dart';

class CommentRepository {
  Future<List<CommentModel>> loadComments(String postId) async {
    List<CommentModel> commentModel;
    final _mRef = FirebaseFirestore.instance;

    await _mRef
        .collection('comments')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      commentModel = value.docs
          .map((model) => CommentModel.fromJson(model.data()))
          .toList();
    }).catchError((e) => print(e));

    if (commentModel != null) {
      // commentModel.reversed;
    }

    return commentModel;
  }

  Future<bool> addComment(PostModel postModel, String message) async {
    bool result;
    var userName = '';
    var imageProfile = '';

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

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

    Map<String, dynamic> mapBody = HashMap();
    //comment detail
    mapBody['commentId'] = postModel.postId;
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
        .doc(uid + time + day)
        .setData(mapBody)
        .then((value) => result = true)
        .catchError((e) => result = false);

    if (result) {
      //add count comment one
      await addCountComment(postModel.postId, postModel.commentCount);
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
        .updateData({'commentCount': '${int.parse(commentCount) + 1}'})
        .then((value) => print('value : Comment Success'))
        .catchError((e) => print(e));
  }
}
