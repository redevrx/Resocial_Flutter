import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriensManageRepo {
  Future<String> onCheckFriendInfo(String friendId) async {
    final _mRef = FirebaseFirestore.instance;
    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();
    final data = await _mRef
        .collection("requests friends")
        .doc(uid)
        .collection("request")
        .doc(friendId)
        .get();
    var result = "";
    var info = null;
    try {
      info = data.get("status").toString();
    } catch (e) {
      print(e);
    }

    if (info != null) {
      //there is persernal this as list
      //check as friend or requesting friend

      if (info == "request") {
        //accept friend
        result = "request";
      }
      if (info == "send") {
        //show button unrequest remove request
        result = "send";
      }
    } else {
      //check as friend this uer
      //call methot check friend
      //if value is empty not as friend
      //not empty is friend

      final friendList = await _mRef
          .collection("friends")
          .doc(uid)
          .collection("status")
          .doc("${friendId}")
          .get();
      // final docId = await _mRef.collection("friends").doc(uid).collection("status").getdocs();
      var friendInfo = null;

      try {
        friendInfo = friendList.get("status").toString();

        // docId.docs.forEach((element) {
        //    print("Friend Id :"+element.docID);
        //  });

        //print("Friend Id :"+id);
      } catch (e) {
        print(e);
      }

      if (friendInfo != null) {
        //not empty is friend
        result = "friends";
      } else {
        //if value is empty not as friend
        //show button request friend
        result = "new";
      }
    }

    print("Friends Result :" + result);
    return result;
  }

  Future<String> onRequestFreind(String friendId) async {
    bool it1, it2 = false;
    var result = "";

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _mRef = FirebaseFirestore.instance;
    final mapSender = Map<String, dynamic>();
    mapSender["status"] = "request";

    final mapFriend = Map<String, dynamic>();
    mapFriend["status"] = "send";

    await _mRef
        .collection("requests friends")
        .doc(uid)
        .collection("request")
        .doc("${friendId}")
        .set(mapSender)
        .then((_) {
      it1 = true;
    });

    await _mRef
        .collection("requests friends")
        .doc(friendId)
        .collection("request")
        .doc("${uid}")
        .set(mapFriend)
        .then((_) {
      it2 = true;
    });

    if (it1 && it2) {
      result = "successfully";
    } else {
      result = "request Faield..";
    }

    return result;
  }

  Future<String> onUnRequest(String friendId) async {
    bool it1, it2 = false;
    var result = "";

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _mRef = FirebaseFirestore.instance;

    await _mRef
        .collection("requests friends")
        .doc(friendId)
        .collection("request")
        .doc("${uid}")
        .delete()
        .then((value) {
      it1 = true;
    });

    await _mRef
        .collection("requests friends")
        .doc(uid)
        .collection("request")
        .doc("${friendId}")
        .delete()
        .then((value) {
      it2 = true;
    });

    if (it1 && it2) {
      result = "successfully";
    } else {
      result = "Remove Faield..";
    }

    return result;
  }

  Future<String> onAcceptFreind(String friendId) async {
    bool it1, it2 = false;
    var result = "";

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _mRefUser = FirebaseFirestore.instance;
    final _mRefFriend = FirebaseFirestore.instance;
    final _mRefDelUser = FirebaseFirestore.instance;
    final _mRefDelFreind = FirebaseFirestore.instance;

    // Map<String, dynamic> mapBody = new HashMap();
    // mapBody["status"] = "friend";

    await _mRefDelUser
        .collection("requests friends")
        .doc(friendId)
        .collection("request")
        .doc("${uid}")
        .delete()
        .then((value) {
      print("remove request user :");
      // it1 = true;
    }).catchError((e) {
      print(e);
    });

    await _mRefDelFreind
        .collection("requests friends")
        .doc(uid)
        .collection("request")
        .doc("${friendId}")
        .delete()
        .then((value) {
      print("remove request freind :");
      //    it2 = true;
    }).catchError((e) {
      print(e);
    });

    await _mRefUser
        .collection("friends")
        .doc(uid)
        .collection("status")
        .doc("${friendId}")
        .set({"status": "friend"}).then((value) {
      it1 = true;
    });

    await _mRefFriend
        .collection("friends")
        .doc(friendId)
        .collection("status")
        .doc("${uid}")
        .set({"status": "friend"}).then((value) {
      it2 = true;
    });

    if (it1 && it2) {
      result = "successfully";
    } else {
      result = "Remove Faield..";
    }

    return result;
  }

  Future<String> onRemoveFriends(String friendId) async {
    bool it1, it2 = false;
    var result = "";

    final _mAuth = await FirebaseAuth.instance.currentUser;
    final uid = await _mAuth.uid.toString();

    final _mRef = FirebaseFirestore.instance;

    await _mRef
        .collection("friends")
        .doc(uid)
        .collection("status")
        .doc("${friendId}")
        .delete()
        .then((value) {
      it1 = true;
    });

    await _mRef
        .collection("friends")
        .doc(friendId)
        .collection("status")
        .doc("${uid}")
        .delete()
        .then((value) {
      it2 = true;
    });

    if (it1 && it2) {
      result = "successfully";
    } else {
      result = "Remove Faield..";
    }

    return result;
  }
}
