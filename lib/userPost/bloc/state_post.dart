import 'dart:io';

abstract class StatePost {}

class OnPostProgress extends StatePost {}

class OnPostInitial extends StatePost {}

class OnPostSuccessful extends StatePost {}

class OnPostFailed extends StatePost {}

class OnImageFilePostChangeState extends StatePost {
  final List<String> pathFiles;
  List urls;
  List urlTypes;

  OnImageFilePostChangeState({this.pathFiles, this.urls, this.urlTypes});
  @override
  String toString() {
    return "image path :${this.pathFiles}";
  }
}

class OnImageFileRemoveChangeState extends StatePost {
  final List urls;
  final List urlTypes;

  OnImageFileRemoveChangeState({this.urls, this.urlTypes});
}
