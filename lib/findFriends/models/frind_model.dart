import 'package:flutter/cupertino.dart';

@immutable
class FrindsModel {
  String uid;
  String userName;
  String imageProfile;
  String status;

  FrindsModel(
      {Key key,
      this.uid = "",
      this.userName = "",
      this.imageProfile = "",
      this.status = ""});

  FrindsModel.fromJson(Map json)
      : uid = json["uid"],
        userName = json["user"],
        imageProfile = json["imageProfile"],
        status = json["userStatus"];

  Map toJson() {
    return {
      "uid": uid,
      "user": userName,
      "imageProfile": imageProfile,
      "userStatus": status
    };
  }
}
