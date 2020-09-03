import 'package:flutter/cupertino.dart';
import 'package:socialapp/Profile/EditPtofile/bloc/models/EditProfileModel.dart';

@immutable
abstract class EditProfileState{}

class onEditBackgroundSuccessfully extends EditProfileState{}
class onEditImageSuccessfully extends EditProfileState{}
class onEditUserNameSuccessfully extends EditProfileState{}
class onEditStatsSuccessfully extends EditProfileState{}
class onEditFailed extends EditProfileState
{
  final String data;

  onEditFailed({this.data = ""});
  @override
  String toString() {
    // TODO: implement toString
    return "${this.data}";
  }
}
class onShowDialog extends EditProfileState{}
class onLoadUserSuccessfully extends EditProfileState
{
  final EditProfileModel data;

  onLoadUserSuccessfully(this.data);

  @override
  String toString() {
    return "${this.data}";
  }
}
