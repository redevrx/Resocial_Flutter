import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/notifications/exportNotify.dart';
import 'dart:async';

class widgetShowNotifySetting extends StatefulWidget {
  final BoxConstraints constraints;

  const widgetShowNotifySetting({
    Key key,
    this.constraints,
  }) : super(key: key);
  @override
  _widgetShowNotifySettingState createState() =>
      _widgetShowNotifySettingState();
}

class _widgetShowNotifySettingState extends State<widgetShowNotifySetting> {
  SharedPreferences _pref;
  PushNotificationService notifyService;

  bool friendNotify = false;
  bool chatNotify = false;
  bool appNotify = false;

  _getNotifyStatus() async {
    _pref = await SharedPreferences.getInstance();

    notifyService = PushNotificationService();
    // await notifyService.initialise();
    setState(() {
      friendNotify = _pref.getBool("friendNotify") == null
          ? false
          : _pref.getBool("friendNotify");

      chatNotify = (_pref.getBool('chatNotify') == null)
          ? false
          : _pref.getBool('chatNotify');

      appNotify = (_pref.getBool("appNotify") == null)
          ? false
          : _pref.getBool("appNotify");
    });
  }

  @override
  void initState() {
    _getNotifyStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      child: Container(
        width: widget.constraints.maxWidth,
        // height: 50.0,
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
                        Icons.notifications_active,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "Friend notifications",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: friendNotify ?? false,
                    activeColor: Color(0xFF4DD964),
                    onChanged: (value) async {
                      if (!value) {
                        print('old :' + '$friendNotify' + ": new:" + '$value');
                        await notifyService.unSubscribe(
                            'Friend_notifications', 'friendNotify');
                        setState(() {
                          friendNotify = value;
                        });
                      } else {
                        print('old :' + '$friendNotify' + ": new:" + '$value');
                        await notifyService.onSubscribe(
                            'Friend_notifications', 'friendNotify');
                        setState(() {
                          friendNotify = value;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
              width: widget.constraints.maxWidth,
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
                        Icons.notifications_active,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "Chat notifications",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: chatNotify,
                    activeColor: Color(0xFF4DD964),
                    onChanged: (value) {
                      setState(() {
                        chatNotify = value;
                        _pref.setBool('chatNotify', value);
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
              width: widget.constraints.maxWidth,
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
                        Icons.notifications_active,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "App notifications",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: appNotify,
                    activeColor: Color(0xFF4DD964),
                    onChanged: (value) async {
                      if (!value) {
                        print('old :' + '$friendNotify' + ": new:" + '$value');
                        await notifyService.unSubscribe(
                            'App_notifications', 'appNotify');
                        setState(() {
                          appNotify = value;
                        });
                      } else {
                        print('old :' + '$friendNotify' + ": new:" + '$value');
                        await notifyService.onSubscribe(
                            'App_notifications', 'appNotify');
                        setState(() {
                          appNotify = value;
                        });
                      }
                    },
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
