import 'package:cloud_firestore/cloud_firestore.dart';
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
  ChatModel.fromJson(DocumentSnapshot json)
      : this._type = json['type'] ?? "",
        this._time = json['time'] ?? "",
        this._from = json['from'] ?? "",
        this._message = json['message'] ?? "",
        this._to = json['to'] ?? "",
        this._messageId = json['messageId'] ?? "",
        this._image = json['image'] ?? "",
        this._senderName = json['senderName'] ?? "",
        this._senderImage = json['senderImage'] ?? "";
}
