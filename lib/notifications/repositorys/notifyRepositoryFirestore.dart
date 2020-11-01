import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/notifications/models/notificationModel.dart';
import 'package:socialapp/notifications/repositorys/notifyRepository.dart';
import 'dart:async';

class NotifyRepositoryFirestore implements NotifyRepository {
  final _mRefNotify = FirebaseFirestore.instance;
  final _mRefCounter = FirebaseFirestore.instance;
  var uid = '';
  Future<void> initialNotify() async {
    //shared preference
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    final pref = await _pref;
    uid = pref.getString('uid');
  }

  @override
  Stream<String> getCounterNotify() {
    print("load counter notify uid:${uid}");
    return _mRefCounter
        .collection("Notifications")
        .doc("${uid}")
        .collection("counter")
        .doc("counter")
        .snapshots()
        .map((snapshot) {
      return snapshot.get("counter").toString();
    });
  }

  @override
  Stream<List<NotifyModel>> getNotifys() {
    print('start loading notify');
    return _mRefNotify
        .collection("Notifications")
        .doc('${uid}')
        .collection('notify')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((model) => NotifyModel.fromJson(model.data()))
          .toList();
    });
  }

  @override
  Future<void> removeNotify(String postID) async {
    print("remove notify list UID: ${uid} , postID: ${postID}");
    final _mRef = FirebaseFirestore.instance;

    await _mRef
        .collection("Notifications")
        .doc('${uid}')
        .collection("notify")
        .doc('${postID}')
        .delete()
        .then((value) => print('remove notify success'))
        .catchError((e) {
      print(e);
    });
  }

  @override
  Future<void> clearCounter() {
    final _mRef = FirebaseFirestore.instance;
    _mRef
        .collection("Notifications")
        .doc('$uid')
        .collection("counter")
        .doc('counter')
        .update({'counter': '0'}).then(
            (value) => print('clear counter notify success'));
  }
}
