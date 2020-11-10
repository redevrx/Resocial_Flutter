import 'package:flutter/material.dart';

abstract class ColorEvent {}

class onColorChangeEvent extends ColorEvent {
  final Color color;

  onColorChangeEvent({this.color});
}
