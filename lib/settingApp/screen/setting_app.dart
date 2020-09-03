import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/settingApp/export/setting_export.dart';

class SettingApp extends StatefulWidget {
  @override
  _SettingAppState createState() => _SettingAppState();
}

class _SettingAppState extends State<SettingApp> {
  bool changeSize = false;
  bool _lights = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: <Widget>[
                appBarSetting(changeSize: changeSize),
                Container(
                  width: constraints.maxWidth,
                  color: Color(0xFFF3EFF9),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      _showText("Account"),
                      SizedBox(
                        height: 4.0,
                      ),
                      widgetShowAccountSetting(
                        constraints: constraints,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      _showText("Notifications"),
                      widgetShowNotifySetting(
                        lights: _lights,
                        constraints: constraints,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      _showText("Friends"),
                      widgetShowFriendsSetting(constraints: constraints,),
                      SizedBox(height: 12.0,)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _showText(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        child: Text(
          "${title}",
          style: TextStyle(color: Colors.black.withOpacity(.45)),
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
