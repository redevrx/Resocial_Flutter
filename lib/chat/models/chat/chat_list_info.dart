import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatListInfo extends Equatable {
  String _name;
  String _lastMessage;
  String _time;
  String _alert;
  String _image;
  String _uid;

  ChatListInfo(String name, String lastMessage, String time, String alert,
      String image, String uid) {
    this._name = name;
    this._lastMessage = lastMessage;
    this._time = time;
    this._alert = alert;
    this._image = image;
    this._uid = uid;
  }

  String get name => this._name;
  String get lastMessage => this._lastMessage;
  String get time => this._time;
  String get alert => this._alert;
  String get image => this._image;
  String get uid => this._uid;

  @override
  // TODO: implement props
  List<Object> get props => [
        {this._name, this._lastMessage, this._time, this._alert, this._image}
      ];

  ChatListInfo.fromJson(QueryDocumentSnapshot json)
      : _uid = json['uid'] ?? "",
        _name = json['name'] ?? "",
        _lastMessage = json["lastMessage"] ?? "",
        _time = json['time'] ?? "",
        _image = json['profile'] ?? "",
        _alert = json['alert'] ?? "";
}
