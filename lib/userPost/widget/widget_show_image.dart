import 'dart:io';
import 'package:flutter/material.dart';

class widgetShowImage extends StatelessWidget {
  final File image;
  final String url;
  const widgetShowImage({Key key, this.image, this.url = ""}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: image != null
          ? Image.file(
              image,
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
            )
          : (url.isEmpty)
              ? Container(
                  height: 300.0,
                )
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
    );
  }
}
