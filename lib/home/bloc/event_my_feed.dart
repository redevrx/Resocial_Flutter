import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/home/export/export_file.dart';

abstract class EventMyFeed {}

class onLoadMyFeedClick extends EventMyFeed {}

class onLoadedMyFeedClick extends EventMyFeed {
  final List<PostModel> models;

  onLoadedMyFeedClick(this.models);
}

class DisponseFeed extends EventMyFeed {}

class onLoadUserPostClick extends EventMyFeed {}

class onLoadUserFeedClick extends EventMyFeed {
  final String uid;

  onLoadUserFeedClick({this.uid = ""});
}

class onRemoveItemUpdateUI extends EventMyFeed {
  final List<PostModel> postModel;
  final List<EditProfileModel> details;
  onRemoveItemUpdateUI({this.postModel, this.details});
}
