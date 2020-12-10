import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/home/export/export_file.dart';

abstract class EventMyFeed extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class onLoadMyFeedClick extends EventMyFeed {
  //start load new feed from startModel
  final List<PostModel> satrtModels;
  bool refeshPage;
  onLoadMyFeedClick({this.satrtModels, this.refeshPage = false});
}

class onLoadedMyFeedClick extends EventMyFeed {
  final List<PostModel> models;
  bool refeshPage;

  onLoadedMyFeedClick({this.models, this.refeshPage});
}

class onLoadUserFeeded extends EventMyFeed {
  final List<PostModel> model;
  bool refeshPage;
  onLoadUserFeeded({this.model, this.refeshPage});
}

class DisponseFeed extends EventMyFeed {}

class onLoadUserPostClick extends EventMyFeed {}

class onLoadUserFeedClick extends EventMyFeed {
  final String uid;
  final String from;
  bool refeshPage;

  onLoadUserFeedClick({this.uid = "", this.from = "", this.refeshPage});
}

class onRemoveItemUpdateUI extends EventMyFeed {
  final List<PostModel> postModel;
  final List<EditProfileModel> details;
  onRemoveItemUpdateUI({this.postModel, this.details});
}

class onLoadOneFeed extends EventMyFeed {
  final String postId;

  onLoadOneFeed({this.postId});
}
