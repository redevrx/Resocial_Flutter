import 'package:equatable/equatable.dart';

class FindFreindResultModel extends Equatable {
  final String uid;
  final String userName;
  final String imageProfile;
  String result;

  FindFreindResultModel(
      {this.uid, this.userName, this.imageProfile, this.result});

  @override
  // TODO: implement props
  List<Object> get props =>
      [this.uid, this.userName, this.imageProfile, this.result];
}
