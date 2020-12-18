import 'package:flutter/cupertino.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  //use in app bar home page
  String get appName;

  //login
  String get titleLogin;
  String get btnLogin;
  String get btnSingUp;
  String get lableEmail;
  String get lablePassword;

  //sign up
  String get titleSignUp;
  String get lableConfrimPassword;

  //use in bottom navigator
  String get lableHomePage;
  String get lableNotify;
  String get lableProfile;
  String get lableSetting;

  //dialog edit
  String get edit;
  String get lableUserStatus;
  String get lableUserName;
  String get btnUpdateNow;
  //

  //dialog select image or camara
  String get lableSelect;
  String get bodySelectImage;
  String get btnCamera;
  String get btnGallery;

  //notifications
  String get titleCreateNotify;
  String get titleLike;
  String get titleRequest;

  //setting app
  String get titleSettingApp;

  //account settings
  String get titleAccount;
  String get titleProfile;
  String get titleForgotPassword;
  String get titleSingOut;

  //notifications settings
  String get titleNotification;
  String get titleFriendNotify;
  String get titleChatNotify;
  String get titleAppNotify;

  //freind settings
  String get titleAllFreind;
  String get titleRequestPage;
  String get titleBlockUser;
}
