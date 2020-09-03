import 'package:flutter/cupertino.dart';

@immutable
class FrindsModel
{
  final String uid;
  final String userName;
  final String imageProfile;

  FrindsModel({Key key,this.uid = "", this.userName = "", this.imageProfile = ""});
  
  FrindsModel.fromJson(Map json):
  uid = json["uid"],
  userName =json["user"],
  imageProfile = json["imageProfile"];

  Map toJson()
  {
    return {"uid":uid,"user":userName,"imageProfile":imageProfile};
  }
}