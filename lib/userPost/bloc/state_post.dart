import 'dart:io';

abstract class StatePost {}

class onPostProgress extends StatePost {}

class onPostInitial extends StatePost {}

class onPostSuccessful extends StatePost {}

class onPostFailed extends StatePost {}

class onImageFilePostChangeState extends StatePost {
  final File imageFile;

  onImageFilePostChangeState({this.imageFile});
  @override
  String toString() {
    // TODO: implement toString
    return "image path :${this.imageFile.path}";
  }
}
