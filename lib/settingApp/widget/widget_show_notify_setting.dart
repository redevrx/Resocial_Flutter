import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class widgetShowNotifySetting extends StatefulWidget {
  final bool lights;
  final BoxConstraints constraints;

  const widgetShowNotifySetting({Key key, this.lights, this.constraints})
      : super(key: key);
  @override
  _widgetShowNotifySettingState createState() =>
      _widgetShowNotifySettingState();
}

class _widgetShowNotifySettingState extends State<widgetShowNotifySetting> {
  bool _lights;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _lights = widget.lights;
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
                    value: _lights,
                    activeColor: Color(0xFF4DD964),
                    onChanged: (value) {
                      setState(() {
                        _lights = value;
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
                        "Chat notifications",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: _lights,
                    activeColor: Color(0xFF4DD964),
                    onChanged: (value) {
                      setState(() {
                        _lights = value;
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
                        "Post notifications",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: _lights,
                    activeColor: Color(0xFF4DD964),
                    onChanged: (value) {
                      setState(() {
                        _lights = value;
                      });
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
