import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';

class FriendRepository {
  Future<List<FrindsModel>> loadRequestFriendUserInfo(
      List<String> idList) async {
    List<FrindsModel> friendList = new List();
    final _user = FirebaseFirestore.instance;

    for (int i = 0; i < idList.length; i++) {
      await _user
          .collection("user info")
          .doc(idList[i])
          .get()
          .then((value) async {
        await friendList.add(new FrindsModel(
            uid: value.get("uid").toString(),
            imageProfile: value.get("imageProfile").toString(),
            userName: value.get("user").toString()));
      });
    }

    return friendList;
  }

//load status request
//return string status
  Future<List<String>> loadRequestId() async {
    List<String> idList = List();
    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = _mAuth.uid.toString();

    final _mRef = FirebaseFirestore.instance;

    await _mRef
        .collection("requests friends")
        .doc(uid)
        .collection("request")
        .get()
        .then((value) {
      value.docs.forEach((it) async {
        print("request Id :" + it.id);
        await idList.add(it.id);
      });
    });

    return idList;
  }

  Future<List<FrindsModel>> loadFriendUserInfo(List<String> idList) async {
    List<FrindsModel> friendList = new List();
    final _user = FirebaseFirestore.instance;

    for (int i = 0; i < idList.length; i++) {
      await _user
          .collection("user info")
          .doc(idList[i])
          .get()
          .then((value) async {
        await friendList.add(new FrindsModel(
            uid: value.get("uid").toString(),
            imageProfile: value.get("imageProfile").toString(),
            status: value.get("userStatus").toString(),
            userName: value.get("user").toString()));
      });
    }

    return friendList;
  }

  Future<List<String>> loadFriendUser() async {
    // frindList.clear();
    List<String> idList = List();

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = _mAuth.uid.toString();

    final _mRef = FirebaseFirestore.instance;

    await _mRef
        .collection("friends")
        .doc(uid)
        .collection("status")
        .get()
        .then((value) {
      value.docs.forEach((it) async {
        if (it.id != null) {
          //print("Friend Id :" + it.documentID);
          await idList.add(it.id);
        }
      });
    });

//       await idList.forEach((it) async{
//        await _user.collection("user info").document(it).get().then((value) async{
//          // print("Friend Name :" + value["user"]);
//           await frindList.add(new FrindsModel(
//               uid: value["uid"].toString(),
//               imageProfile: value["imageProfile"].toString(),
//               userName: value["user"].toString()));
//         });
//       });

// frindList.forEach((element) {
//       print("Item :"+element.userName);
//     });
    return idList;
  }

//load user total 4 person
//if load success return true
  Future<List<FrindsModel>> LoadingFrindList() async {
    List<FrindsModel> frindList;

    final _mRef = FirebaseFirestore.instance;
    await _mRef.collection("user info").limit(4).get().then((value) {
      //  value.documents.forEach((it) {
      //    it.data.forEach((key, value) {
      //      print("key :${key} , value :${value}");
      //    });
      //   });
      // print(value.documents)
      frindList = value.docs
          .map((model) => FrindsModel.fromJson(model.data()))
          .toList();
    });

    if (frindList != null) {
      return frindList;
    } else {
      return null;
    }
  }

  //make search friend onwer this user
  Future<String> onCheckFriendCurrentUser(String friendId) async {
    final _mRef = FirebaseFirestore.instance.collection("friends");
    //get current user id
    final _sPref = await SharedPreferences.getInstance();
    String uid = _sPref.getString("uid");

    String checkFreind = "";

    // search friend id
    await _mRef
        .doc("${uid}")
        .collection("status")
        .doc(friendId)
        .get()
        .then((info) {
      checkFreind = info["status"].toString();
    }).catchError((_) {
      checkFreind = "not as freind";
    });

    return checkFreind;
  }

//search user
//field user by texts search
  Future<List<FrindsModel>> onFindFriend(String word) async {
    List<FrindsModel> frindList;

    final _mRef = FirebaseFirestore.instance;
    print("word search friend :${word}");

    await _mRef
        .collection("user info")
        .where("user", isGreaterThanOrEqualTo: word)
        .get()
        .then((value) {
      frindList =
          value.docs.map((e) => FrindsModel.fromJson(e.data())).toList();
    });
    return frindList;

    // if (frindList != null) {
    //   for (int i = 0; i < frindList.length; i++) {
    //     if (word.toUpperCase() == frindList[i].userName.toUpperCase()) {
    //       print(frindList[i].uid);
    //       return frindList[i];
    //     }
    //   }
    // } else {
    //   return null;
    // }

    // frindList.forEach((it) {
    // //  if(word.toUpperCase() == it.userName.toUpperCase())
    // //  {
    //     print(it.uid + " : "+it.userName);
    //  //}
    // });
  }
}
