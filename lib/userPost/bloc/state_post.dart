import 'dart:io';

abstract class StatePost {}

class OnPostProgress extends StatePost {}

class OnPostInitial extends StatePost {}

class OnPostSuccessful extends StatePost {}

class OnPostFailed extends StatePost {}

class OnImageFilePostChangeState extends StatePost {
  final List<String> pathFiles;

  OnImageFilePostChangeState({this.pathFiles});
  @override
  String toString() {
    // TODO: implement toString
    return "image path :${this.pathFiles}";
  }
}
