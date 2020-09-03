import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/home/export/export_file.dart';

class FeedRepository {
  Future<List<PostModel>> getMyFeed(String uid) async {
    List<PostModel> models = List();

    final _mAuth = await FirebaseAuth.instance.currentUser;
    String userID;
    if (uid.isEmpty) {
      userID = await _mAuth.uid.toString();
    } else {
      userID = uid;
    }

    //firebase data path
    final _mRef = FirebaseFirestore.instance.collection("Post");
    await _mRef.where("uid", isEqualTo: userID).get().then((value) {
      models = value.docs.map((model) => PostModel.fromJson(model)).toList();
    }).catchError((e) {
      print(e);
    });

    return models;
  }

  Future<List<String>> onCheckUserLikePost(
      List<DocumentSnapshot> postId) async {
    List<String> result = List();

    //  print('I :${i}');
    //db
    final _mRef = FirebaseFirestore.instance;
    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    for (int i = 0; i < postId.length; i++) {
      await _mRef
          .collection("likes post")
          .doc(postId[i].data()['postId'].toString())
          .collection(uid)
          .doc("likes")
          .get()
          .then((value) async {
        var it = value.get("user").toString();
        //print("like result :${it}");

        if (it == uid) {
          await result.add('likes');
          // unlike
        } else {
          await result.add('un');
          // user like
        }
      }).catchError((e) async {
        await result.add('un');
      });
    }

    //get data in path
    // try
    // {
    //   await _mRef.collection("likes post").document(postId).get()
    // .then((value) async{
    //  var it = value["${uid}"].toString();
    //  //print("like result :${it}");

    //   if(it == uid)
    //   {
    //    await result.add('likes');
    //     // unlike
    //   }
    //   else
    //   {
    //   await result.add('un');
    //     // user like
    //   }
    // }).catchError((e) async
    // {

    //   await result.add('un');
    //    print("error load like :${e}");
    // });
    // }
    // catch(e)
    // {
    //   print(e);
    //    await result.add(false);
    // }
    return result;
  }

  Future<List<PostModel>> getFeed() async {
    List<PostModel> models = List();
    // List<DocumentSnapshot> likeModel;

    final _mRef = FirebaseFirestore.instance;

    await _mRef.collection("Post").get().then((value) {
      // print('map Value :'+value.documents[0].data['likeResult']['${value.documents[0].data['uid'].toString()}'].toString());
      //print('map Value :${value.documents.length}');
      // for (int i = 0; i < value.documents.length; i++) {

      //   likeModel.add(new LiekModel
      //   (
      //     user: value.documents[i].data['likeResult']['${value.documents[i].data['uid'].toString()}']
      //   ));

      //   models.add(new PostModel(
      //       body: value.documents[i].data['body'].toString(),
      //       commentCount: value.documents[i].data['commentCount'].toString(),
      //       date: value.documents[i].data['date'].toString(),
      //       image: value.documents[i].data['image'].toString(),
      //       likeResult:  likeModel,
      //       likesCount: value.documents[i].data['likesCount'].toString(),
      //       postId: value.documents[i].data['postId'],
      //       time: value.documents[i].data['time'].toString(),
      //       type: value.documents[i].data['type'].toString(),
      //       uid: value.documents[i].data['uid'].toString(),));
      // }
      models = value.docs.map((model) => PostModel.fromJson(model)).toList();
    });

    print('map Value :${models.length}');
    return models;
  }

  Future<List<EditProfileModel>> getUserDetail() async {
    List<EditProfileModel> detailModel = List();

    final _mRef = FirebaseFirestore.instance;

    await _mRef.collection('user info').get().then((value) {
      detailModel = value.docs
          .map((model) => EditProfileModel.fromJson(model.data()))
          .toList();
    });

    return detailModel;
  }
}
