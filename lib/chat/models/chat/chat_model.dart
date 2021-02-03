import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

@immutable
class ChatModel {
  String _type;
  String _time;
  String _from;
  String _message;
  String _to;
  String _messageId;
  String _image;
  String _senderName;
  String _senderImage;

  ChatModel(String type, String time, String from, String message, String to,
      String messageId, String image, String senderName, String senderImage) {
    this._type = type;
    this._time = time;
    this._from = from;
    this._message = message;
    this._to = to;
    this._messageId = messageId;
    this._image = image;
    this._senderName = senderName;
    this._senderImage = senderImage;
  }
  //
  ChatModel.fromJson(QueryDocumentSnapshot json)
      : this._type = json['type'] ?? "",
        this._time = json['time'] ?? "",
        this._from = json['from'] ?? "",
        this._message = json['message'] ?? "",
        this._to = json['to'] ?? "",
        this._messageId = json['messageId'] ?? "",
        this._image = json['image'] ?? "",
        this._senderName = json['senderName'] ?? "",
        this._senderImage = json['senderImage'] ?? "";

  ChatModel.fromJson3(dynamic json)
      : this._type = json['type'] ?? "",
        this._time = json['time'] ?? "",
        this._from = json['from'] ?? "",
        this._message = json['message'] ?? "",
        this._to = json['to'] ?? "",
        this._messageId = json['messageId'] ?? "",
        this._image = json['image'] ?? "",
        this._senderName = json['senderName'] ?? "",
        this._senderImage = json['senderImage'] ?? "";

  ChatModel.fromJson2(DataSnapshot json)
      : this._type = json.value['type'] ?? "",
        this._time = json.value['time'] ?? "",
        this._from = json.value['from'] ?? "",
        this._message = json.value['message'] ?? "",
        this._to = json.value['to'] ?? "",
        this._messageId = json.value['messageId'] ?? "",
        this._image = json.value['image'] ?? "",
        this._senderName = json.value['senderName'] ?? "",
        this._senderImage = json.value['senderImage'] ?? "";

  String get type => this._type;
  String get time => this._time;
  String get from => this._from;
  String get message => this._message;
  String get to => this._to;
  String get messageId => this._messageId;
  String get image => this._image;
  String get senderName => this._senderName;
  String get senderImage => this._senderImage;
}
