import 'package:flutter/material.dart';
import 'package:socialapp/findFriends/screens/show_lis_friends.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppBarCustom extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String status;
  final double textSize;
  final double widgetSize;

  const AppBarCustom(
      {Key key,
      this.title,
      this.titleColor,
      this.status,
      this.textSize = 36.0,
      this.widgetSize = 128})
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
        height: (kIsWeb) ? 90 : widgetSize,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: (kIsWeb) ? 6.0 : 36.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              status == "home page"
                  ? IconButton(
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
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 32,
                      ),
                      color: titleColor,
                      onPressed: () {
                        if (status == "register") {
                          Navigator.of(context).pop(context); //pushNamed("/");
                        }
                      },
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
                  ? IconButton(
                      icon: Icon(
                        Icons.chat,
                        color: titleColor,
                      ),
                      onPressed: () async {})
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
