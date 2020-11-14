import 'package:flutter/material.dart';

class ScreenRefresh extends StatelessWidget {
  const ScreenRefresh({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Navigator.of(context).pop();
    return Scaffold();
  }
}
