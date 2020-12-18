import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/findFriends/eport/export_friend.dart';
import 'package:socialapp/findFriends/models/findFriendResult_model.dart';

class FriensManageRepo {
//read friends and check as friend with this user
  Future<List<FindFreindResultModel>> onFindFreindListStatus(
      List<FrindsModel> friendList) async {
    //new instances freind model list
    List<FindFreindResultModel> friendModel = [];

    for (int i = 0; i < friendList.length; i++) {
      //load get freind info
      //find freind status
      final result = await onCheckFriendInfo(friendList[i].uid);

      if (result == "request") {
        friendModel.add(new FindFreindResultModel(
            uid: friendList[i].uid,
            userName: friendList[i].userName,
            imageProfile: friendList[i].imageProfile,
            result: result));
      } else if (result == "send") {
        friendModel.add(new FindFreindResultModel(
            uid: friendList[i].uid,
            userName: friendList[i].userName,
            imageProfile: friendList[i].imageProfile,
            result: result));
      } else if (result == "friends") {
        friendModel.add(new FindFreindResultModel(
            uid: friendList[i].uid,
            userName: friendList[i].userName,
            imageProfile: friendList[i].imageProfile,
            result: result));
      } else if (result == "new") {
      } else {
        print("Error : ${result}");
      }
    }
    return friendModel;
  }

//check status freidn
//requesting
//sending
//
  Future<String> onCheckFriendInfo(String friendId) async {
    final _mRef = FirebaseFirestore.instance;
    final _pref = await SharedPreferences.getInstance();

    final uid = _pref.getString("uid");

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

//send request to freind
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

      await sendNotifyToRequestFreind(friendId, uid, "request");
    } else {
      result = "request Faield..";
    }

    return result;
  }

//send notify to freind that to request
  Future<void> sendNotifyToRequestFreind(
      String friendId, String uid, String type) async {
    //get time now
    var now = DateTime.now();
    //date format
    var date = DateFormat("yyyy-MM-dd").format(now);
    // String mDate = date.format(dateTime);

    // time format
    var time = DateFormat("H:m:s").format(now);

    final _mRef = FirebaseFirestore.instance;

    await _mRef.collection("user info").doc(uid).get().then((info) async {
      //
      final name = info.get("user").toString();

      // map keep  detail notification
      final notifyData = Map<String, String>();
      notifyData['date'] = date;
      notifyData['time'] = time;
      notifyData['uid'] = uid;
      notifyData['friendId'] = friendId;
      notifyData['type'] = type;
      notifyData["name"] = name;
      notifyData['postID'] = "postId";
      notifyData['message'] = 'like notification';
      notifyData['profileUrl'] =
          await _mRef.collection("user info").doc(uid).get().then((info) {
        return info.get('imageProfile').toString();
      });

      // //create firebase firestore instand
      // //save
      _mRef
          .collection("Notifications")
          .doc(friendId)
          .collection("notify")
          .doc(uid)
          .set(notifyData)
          .then((value) {
        print("create notify request friend success..");
        counterNotifyChange(friendId);
      });
    });
  }

//increment value + 1 if click like
  Future counterNotifyChange(String friendId) async {
    final _mRef = FirebaseFirestore.instance;
    //load counter notification and + 1
    try {
      await _mRef
          .collection("Notifications")
          .doc(friendId)
          .collection("counter")
          .doc('counter')
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
          c = int.parse(counterNotify.get("counter").toString());
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
      //     .doc(onwerId)
      //     .collection("notify")
      //     .doc("counter")
      //     .set({'counter': c += 1});
    }
  }

//unrequest freind
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

//other user request
//select accept or remove request
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

      sendNotifyToRequestFreind(friendId, uid, "accept");
    } else {
      result = "Remove Faield..";
    }

    return result;
  }

//remove freind
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
