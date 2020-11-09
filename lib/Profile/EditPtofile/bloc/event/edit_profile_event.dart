import 'dart:io';

import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';

abstract class EditProfileEvent {}

class EditProfileBackgroundClik extends EditProfileEvent {
  final File image;

  EditProfileBackgroundClik(this.image);
}

class EditProfileImageClick extends EditProfileEvent {
  final File image;

  EditProfileImageClick(this.image);
}

class EditProfileNameClik extends EditProfileEvent {
  final String data;

  EditProfileNameClik({this.data = ""});
}

class EditProfileStstusClick extends EditProfileEvent {
  final String data;

  EditProfileStstusClick({this.data = ""});
}

class EditProfileLoadUserInfo extends EditProfileEvent {
  final String uid;
  EditProfileLoadUserInfo({this.uid = ""});
}

class loadFriendProfile extends EditProfileEvent {
  final String uid;

  loadFriendProfile({this.uid = ""});
}

class onDisponscEditProfile extends EditProfileEvent {}

class loadedFriendProfileSuccess extends EditProfileEvent {
  final EditProfileModel model;

  loadedFriendProfileSuccess({this.model});
}

class EditProfileLoadedUserInfo extends EditProfileEvent {
  final EditProfileModel model;

  EditProfileLoadedUserInfo({this.model});
}

class loadFriendProfilePost extends EditProfileEvent {}
