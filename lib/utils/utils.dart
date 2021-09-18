import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TOKEN_URL = "http://172.30.128.1:8080/resocial/api/v1/generate/";
const PersonURL =
    "https://firebasestorage.googleapis.com/v0/b/flutter-resocial.appspot.com/o/download.png?alt=media&token=34d4da7d-7475-437b-a0ce-48f9e4018c65";

const Example_Profile =
    "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg";

const CALL_ICON_USER =
    "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg";

///
Future<void> onLoadingDialog(BuildContext context, {String message}) async {
  return showGeneralDialog(
    context: context,
    barrierLabel: "",
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 750),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Align(
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .45,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(18.0)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.5),
                        borderRadius: BorderRadius.circular(18.0)),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )),
              ),
            )),
      );
    },
  );
}
