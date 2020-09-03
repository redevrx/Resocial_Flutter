import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialapp/home/export/export_file.dart';

class LikeRepository {
  Future<List<String>> onCheckUserLikePost(
      List<DocumentSnapshot> postId) async {
    List<String> result = List();

    //  print('I :${i}');
    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();
    //db
    final _mRef = FirebaseFirestore.instance;

    for (int i = 0; i < postId.length; i++) {
      await _mRef
          .collection("likes post")
          .doc(postId[i].data()["postId"].toString())
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

  Future<bool> onLike(String postId, String status) async {
    bool result;
    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();
    //db
    // final _mRef = Firestore.instance;

    //get data in path
    // await _mRef.collection("Post").document(postId).get().then((value) async {
    //   var it = value['likeResult']["${uid}"].toString();
    //   print('get curent like post :${it}');
    //   if (it == null || it.isEmpty) {
    //     result = true;
    //   } else {
    //     result = false;
    //   }
    // }).catchError((e) {
    //   result = false;
    // });

    if (status == 'un') {
      // unlike
      print('unlike working');
      await unLike(postId, uid);
      await decrementLikeCount(postId, uid);
      //unlike success
      return result;
    } else {
      // user like
      print('like working');
      await like(postId, uid);
      await incrementLikeCount(postId, uid);
      //user like success
      return result;
    }
  }

  // add like count one like
  Future<void> incrementLikeCount(String postId, String uid) async {
    final _mRef = FirebaseFirestore.instance;
    await _mRef.collection('Post').doc(postId).get().then((value) async {
      var likeCount = value.get("likesCount").toString();

      await _mRef
          .collection('Post')
          .doc(postId)
          .update({'likesCount': '${(int.parse(likeCount) + 1)}'})
          .then((_) => print('Increment Like Success'))
          .catchError((e) => print('Increment Like :${e}'));
    }).catchError((e) => print(e));
  }

  //remove like count one like
  Future<void> decrementLikeCount(String postId, String uid) async {
    final _mRef = FirebaseFirestore.instance;
    await _mRef.collection('Post').doc(postId).get().then((value) async {
      var likeCount = value.get("likesCount").toString();

      // remove like
      await _mRef
          .collection('Post')
          .doc(postId)
          .update({'likesCount': '${(int.parse(likeCount) - 1)}'})
          .then((_) => print('Decrement Like Success'))
          .catchError((e) => print('Decrement Like :${e}'));
    }).catchError((e) {
      print(e);
    });
  }

// like method
  Future<bool> like(String postId, String uid) async {
    bool result;
    Map<String, Object> map = HashMap();

    final _mRef = FirebaseFirestore.instance;
    await _mRef.collection("Post").document(postId).get().then((value) async {
      map = value.data()["likeResult"];
      map[uid] = uid;
//read old data like and save new like
      await _mRef
          .collection("Post")
          .doc(postId)
          .update({'likeResult': map})
          .then((value) => result = true)
          .catchError((e) => result = false);
    }).catchError((e) {});
    //get data in path

    return result;
  }

  //un like method
  Future<bool> unLike(String postId, String uid) async {
    bool result;

    final _mRef = FirebaseFirestore.instance;
    //get data in path
    Map<String, Object> map = HashMap();
    await _mRef.collection("Post").doc(postId).get().then((value) async {
      map = value.data()["likeResult"];
      map[uid] = null;
//read old data like and save new like
      await _mRef
          .collection("Post")
          .doc(postId)
          .update({'likeResult': map})
          .then((value) => result = true)
          .catchError((e) => result = false);
    }).catchError((e) {});

    return result;
  }

  Future<bool> likeOne(String postId) async {
    bool result;

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();
    //db
    final _mRef = FirebaseFirestore.instance;

    print('re :' + postId);
    // get data in path
    await _mRef
        .collection("likes post")
        .doc(postId)
        .collection(uid)
        .doc("likes")
        .get()
        .then((value) async {
      var it = value.get("user").toString();
      if (it == uid) {
        result = true;
      }
    }).catchError((e) {
      result = false;
    });

    return result;
  }
}
