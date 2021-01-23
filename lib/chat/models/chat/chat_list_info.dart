import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatListInfo extends Equatable {
  String _name;
  String _lastMessage;
  String _time;
  String _alert;
  String _image;
  String _uid;
  String _type;
  String _groupId;
  String _createBy;
  String _status;

  dynamic _participant;

  ChatListInfo(
      String name,
      String lastMessage,
      String time,
      String alert,
      String image,
      String uid,
      String type,
      String groupId,
      String createBy,
      String participant,
      String status) {
    this._name = name;
    this._lastMessage = lastMessage;
    this._time = time;
    this._alert = alert;
    this._image = image;
    this._uid = uid;
    this._type = type;
    this._groupId = groupId;
    this._createBy = createBy;
    this._participant = participant;
    this._status = status;
  }

  String get name => this._name;
  String get lastMessage => this._lastMessage;
  String get time => this._time;
  String get alert => this._alert;
  String get image => this._image;
  String get uid => this._uid;
  String get type => this._type;
  String get groupId => this._groupId;
  String get createBy => this._createBy;
  dynamic get participant => this._participant;
  String get status => this._status;

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
        _alert = json['alert'] ?? "",
        _type = json['type'] ?? "",
        _groupId = json['groupId'] ?? "",
        _createBy = json['createBy'] ?? "",
        _participant = json['participant'] ?? "",
        _status = json['status'] ?? "";
}
