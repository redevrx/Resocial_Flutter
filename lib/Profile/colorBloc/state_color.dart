import 'package:flutter/cupertino.dart';

abstract class ColorState {}

class onColorChangeState extends ColorState {
  final Color color;

  onColorChangeState({this.color});

  @override
  String toString() => "${this.color}";
}
