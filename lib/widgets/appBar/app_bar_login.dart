import 'package:flutter/material.dart';
import 'package:socialapp/chat/screen/chat_screen.dart';
import 'package:socialapp/findFriends/screens/show_lis_friends.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class AppBarCustom extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String status;
  final double textSize;
  final double widgetSize;
  final String uid;

  const AppBarCustom(
      {Key key,
      this.title,
      this.titleColor,
      this.status,
      this.textSize = 36.0,
      this.widgetSize = 128,
      this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 2000),
        decoration: BoxDecoration(
            color: titleColor.withOpacity(.25),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0))), // Yellow
        height: MediaQuery.of(context).size.height / 5.2,
        // (kIsWeb) ? 90 : widgetSize,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 36.0, left: 4.0, right: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              status == "home page"
                  ? AnimatedContainer(
                      // padding: EdgeInsets.all(4),
                      duration: Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                          color: titleColor.withOpacity(.46),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: titleColor.withOpacity(.4),
                                blurRadius: 18,
                                offset: Offset(.5, .5),
                                spreadRadius: .5)
                          ]),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 32,
                        ),
                        color: titleColor,
                        onPressed: () {
                          //
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AllUser(),
                          ));
                        },
                      ),
                    )
                  : AnimatedContainer(
                      // padding: EdgeInsets.all(4),
                      duration: Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                          color: titleColor.withOpacity(.46),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: titleColor.withOpacity(.4),
                                blurRadius: 18,
                                offset: Offset(.5, .5),
                                spreadRadius: .1)
                          ]),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 32,
                        ),
                        color: titleColor,
                        onPressed: () {
                          if (status == "register") {
                            Navigator.of(context)
                                .pop(context); //pushNamed("/");
                          }
                        },
                      ),
                    ),
              Text(
                '${title}',
                style: TextStyle(
                    color: titleColor,
                    height: 1.2,
                    fontSize: textSize,
                    fontWeight: FontWeight.bold),
              ),
              status == "home page"
                  ? AnimatedContainer(
                      // padding: EdgeInsets.all(4),
                      duration: Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                          color: titleColor.withOpacity(.4),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: titleColor.withOpacity(.46),
                                blurRadius: 18,
                                offset: Offset(.5, .5),
                                spreadRadius: .1)
                          ]),
                      child: IconButton(
                          icon: Image.asset(
                            "assets/icons/messenger.png",
                            width: 25.0,
                            height: 25.0,
                          ),
                          onPressed: () async {
                            // open to chat screen
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 1),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    animation = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeInOutBack);
                                    return ScaleTransition(
                                      alignment: Alignment.center,
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return ChatScreen(
                                      uid: uid,
                                    );
                                  },
                                ),
                                (route) => false);
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //       builder: (context) => ChatScreen(
                            //         uid: uid,
                            //       ),
                            //     ),
                            //     (route) => false);
                          }))
                  : status == "register"
                      ? Opacity(
                          opacity: 0.0,
                          child: IconButton(
                              icon: Icon(Icons.more_vert), onPressed: () {}),
                        )
                      : status == "login"
                          ? Opacity(
                              opacity: 0.0,
                              child: IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {}),
                            )
                          : status == "profile"
                              ? Opacity(
                                  opacity: 0.0,
                                  child: IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {}),
                                )
                              : Container()
            ],
          ),
        ),
      ),
    );
  }
}
