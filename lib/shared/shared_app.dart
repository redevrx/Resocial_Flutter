import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
class SharedApp
{
  Future<void> sharedText(BuildContext context,String message) async
  {
    final RenderBox box = context.findRenderObject();
    await Share.share
    (
      message,
      subject: 'Resocial App',
    sharePositionOrigin:
    box.localToGlobal(Offset.zero) & box.size);

    //await EsysFlutterShare.shareText(message, 'Resocial App');
  }

  Future<void> sharedImage(BuildContext context,String image,String message) async
  {
     final RenderBox box = context.findRenderObject();
    await Share.share
    (
      '${message}\n\n\n${image}',
      subject: 'Resocial App',
    sharePositionOrigin:
    box.localToGlobal(Offset.zero) & box.size);
   // await EsysFlutterShare.shareText('${message} \n\n${image}', 'Resocial App');
  }
}