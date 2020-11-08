import 'package:flutter/cupertino.dart';

@immutable
abstract class AddProfileState {}

class onSaveAddProfileSuccessfully extends AddProfileState {
  final String data;

  onSaveAddProfileSuccessfully({Key key, this.data});
  @override
  String toString() {
    // TODO: implement toString
    return data;
  }
}

class onSaveAddprofileDialog extends AddProfileState {}

class onSaveAddProfileFailed extends AddProfileState {
  final String data;

  onSaveAddProfileFailed({Key key, this.data});
  @override
  String toString() {
    // TODO: implement toString
    return data;
  }
}

class onSelecImageSuccess extends AddProfileState {
  final String imagePath;

  onSelecImageSuccess({this.imagePath});

  @override
  String toString() => "${this.imagePath}";
}
