import 'package:socialapp/notifications/models/notificationModel.dart';

abstract class NotifyRepository {
  Stream<List<NotifyModel>> getNotifys(String uid);
  Future<String> getCounterNotify(String uid);
  Future<void> removeNotify(String uid, String postID);
  Future<void> clearCounter(String uid);
}
