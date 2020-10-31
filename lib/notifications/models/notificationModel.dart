import 'package:equatable/equatable.dart';

class NotifyModel extends Equatable {
  final String uid;
  final String name;
  final String time;
  final String date;
  final String message;
  final String postID;
  final String type;
  final String profileUrl;
  final String onwerId;

  NotifyModel(
      {this.uid,
      this.name,
      this.time,
      this.date,
      this.message,
      this.postID,
      this.type,
      this.profileUrl,
      this.onwerId});

  Map<String, Object> toJson() {
    return {
      'uid': uid ?? '',
      'name': name ?? '',
      'time': time ?? '',
      'date': date ?? '',
      'message': message ?? '',
      'postID': postID ?? '',
      'type': type ?? '',
      'profileUrl': profileUrl ?? '',
      'onwerId': onwerId ?? ''
    };
  }

  @override
  // TODO: implement props
  List<Object> get props =>
      [uid, name, time, date, message, postID, type, profileUrl];
  static String getCounter(Map<String, dynamic> json) {
    return json['counter'] ?? "";
  }

  String getTypeNotify() => type ?? '';

  static NotifyModel fromJson(Map<String, dynamic> json) {
    return NotifyModel(
        uid: json['uid'] ?? '',
        date: json['date'] ?? '',
        message: json['message'] ?? '',
        name: json['name'] ?? '',
        time: json['time'] ?? '',
        postID: json['postID'] ?? '',
        type: json['type'] ?? '',
        profileUrl: json['profileUrl'] ?? '',
        onwerId: json['onwerId'] ?? '');
  }
}
