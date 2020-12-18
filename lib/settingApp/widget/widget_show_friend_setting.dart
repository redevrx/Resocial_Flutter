import 'package:flutter/material.dart';
import 'package:socialapp/localizations/languages.dart';
import 'package:socialapp/showFriend/screen/show_friend.dart';

class widgetShowFriendsSetting extends StatelessWidget {
  final BoxConstraints constraints;
  const widgetShowFriendsSetting({
    Key key,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.supervised_user_circle,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "${AppLocalizations.of(context).translate("titleAllFreind")}",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 30.0,
                      color: Colors.black.withOpacity(.55),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShowFriends(
                          wordSate: "All Friends",
                        ),
                      ));
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
              width: constraints.maxWidth,
              child: Divider(
                color: Colors.black.withOpacity(.55),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.group_add,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "${AppLocalizations.of(context).translate("titleRequest")}",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 30.0,
                      color: Colors.black.withOpacity(.55),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShowFriends(
                          wordSate: "Request Friends",
                        ),
                      ));
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
              width: constraints.maxWidth,
              child: Divider(
                color: Colors.black.withOpacity(.55),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.block,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "${AppLocalizations.of(context).translate("titleBlockUser")}",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 30.0,
                      color: Colors.black.withOpacity(.55),
                    ),
                    onTap: () async {},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
