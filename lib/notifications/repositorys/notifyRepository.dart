import 'package:socialapp/notifications/models/notificationModel.dart';

abstract class NotifyRepository {
  Stream<List<NotifyModel>> getNotifys();
  Stream<String> getCounterNotify();
  Future<void> removeNotify(String postID);
  Future<void> clearCounter();
}
