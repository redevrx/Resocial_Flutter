import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/home/export/export_file.dart';

abstract class StateMyFeed {}

class onFeedProgress extends StateMyFeed {}

class onFeedSuccessful extends StateMyFeed {
  final List<PostModel> models;
  final List<String> likeResult;
  final List<EditProfileModel> detail;
  onFeedSuccessful({this.likeResult, this.models, this.detail});
  @override
  String toString() => "${this.models},${this.detail}";
  // @overrid
  // String getDetail () => "${this.details}";
}

class onUserFeedSuccess extends StateMyFeed {
  final List<PostModel> models;

  onUserFeedSuccess({this.models});
}

class onFeedUserFuccessful extends StateMyFeed {}

class onFeedFaield extends StateMyFeed {}
