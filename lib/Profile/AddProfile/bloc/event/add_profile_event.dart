import 'dart:io';

import 'package:socialapp/Profile/AddProfile/bloc/models/add_profile_model.dart';

abstract class AddProfileEvent {}

class onSaveAddprofile extends AddProfileEvent {
  final AddProfileModel data;

  onSaveAddprofile(this.data);
}

class onUserStatusChange extends AddProfileEvent {
  final String userStatus;

  onUserStatusChange({this.userStatus});
}

class onNickNameChange extends AddProfileEvent {
  final String nickName;

  onNickNameChange({this.nickName});
}

class onImageProfileChange extends AddProfileEvent {
  final String imagePath;

  onImageProfileChange({this.imagePath});
}
