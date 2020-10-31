import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/notifications/models/notificationModel.dart';
import 'package:socialapp/notifications/repositorys/notifyRepository.dart';
import 'dart:async';

class NotifyRepositoryFirestore implements NotifyRepository {
  final _mRefNotify = FirebaseFirestore.instance;
  final _mRefCounter = FirebaseFirestore.instance;

  @override
  Future<String> getCounterNotify(String uid) async {
    print('load counter notify uid:${uid}');
    var counter = '';
    await _mRefCounter
        .collection("Notifications")
        .doc("${uid}")
        .collection("counter")
        .doc("counter")
        .get()
        .then((value) {
      counter = value.get("counter").toString();
      print(counter);
    });

    return counter;
  }

  @override
  Stream<List<NotifyModel>> getNotifys(String uid) {
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
  Future<void> removeNotify(String uid, String postID) async {
    print("remove notify list UID: ${uid} , postID: ${postID}");
    final _mRef = FirebaseFirestore.instance;

    _mRef
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
  Future<void> clearCounter(String uid) {
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
