import 'package:flutter/cupertino.dart';

@immutable
class FrindsModel {
  String uid;
  String userName;
  String imageProfile;

  FrindsModel(
      {Key key, this.uid = "", this.userName = "", this.imageProfile = ""});

  FrindsModel.fromJson(Map json)
      : uid = json["uid"],
        userName = json["user"],
        imageProfile = json["imageProfile"];

  Map toJson() {
    return {"uid": uid, "user": userName, "imageProfile": imageProfile};
  }
}
