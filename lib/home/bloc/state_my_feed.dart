import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';
import 'package:socialapp/home/export/export_file.dart';

abstract class StateMyFeed extends Equatable {
  const StateMyFeed();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class onFeedProgress extends StateMyFeed {}

// when start frish load feed
//will load 6 feed and
//will retrun in class
class onFeedSuccessfulInitial extends StateMyFeed {
  List<PostModel> models;
  bool refreshList;
  onFeedSuccessfulInitial({this.models, this.refreshList = false});
}

//will use onFeedSuccessful when
//end feed of onFeedSuccessfulInitial
class onFeedSuccessful extends StateMyFeed {
  final List<PostModel> models;
  final List<String> likeResult;
  final List<EditProfileModel> detail;
  bool refreshList;
  bool hasReachedMax;

  onFeedSuccessful(
      {this.hasReachedMax,
      this.likeResult,
      this.models,
      this.detail,
      this.refreshList});

  @override
  String toString() => "${this.models},${this.detail}";
  // @overrid
  // String getDetail () => "${this.details}";

  onFeedSuccessful copyWith(
      {List<PostModel> models,
      List<String> likeResult,
      List<EditProfileModel> detail,
      bool hasReachedMax}) {
    return onFeedSuccessful(
        models: models ?? this.models,
        likeResult: likeResult ?? this.likeResult,
        detail: detail ?? this.detail,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}

class onUserFeedSuccess extends StateMyFeed {
  final List<PostModel> models;
  bool refreshList;
  onUserFeedSuccess({this.models, this.refreshList = false});
}

class onUserFeedSuccessInitial extends StateMyFeed {
  final List<PostModel> models;
  bool refreshList;
  onUserFeedSuccessInitial({this.models, this.refreshList = false});
}

class onFeedUserFuccessful extends StateMyFeed {}

class onFeedFaield extends StateMyFeed {}

class onLoadOneFeedSuccess extends StateMyFeed {
  final PostModel model;

  onLoadOneFeedSuccess({this.model});

  @override
  String toString() {
    // TODO: implement toString
    return "${this.model}";
  }
}
