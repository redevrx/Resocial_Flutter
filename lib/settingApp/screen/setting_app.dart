import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/localizations/language/language.dart';
import 'package:socialapp/localizations/languages.dart';
import 'package:socialapp/settingApp/export/setting_export.dart';

class SettingApp extends StatefulWidget {
  @override
  _SettingAppState createState() => _SettingAppState();
}

class _SettingAppState extends State<SettingApp> {
  bool changeSize = false;
  // bool _lights = true;

  PageNaviagtorChageBloc pageNaviagtorChageBloc;

  @override
  void initState() {
    // TODO: implement initState

    pageNaviagtorChageBloc = BlocProvider.of<PageNaviagtorChageBloc>(context);
    super.initState();
  }

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
                      _showText(
                          "${AppLocalizations.of(context).translate("titleAccount")}"),
                      SizedBox(
                        height: 4.0,
                      ),
                      widgetShowAccountSetting(
                          constraints: constraints,
                          pageNaviagtorChageBloc: pageNaviagtorChageBloc),
                      SizedBox(
                        height: 12.0,
                      ),
                      _showText(
                          "${AppLocalizations.of(context).translate("titleNotification")}"),
                      widgetShowNotifySetting(
                        constraints: constraints,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      _showText(
                          "${AppLocalizations.of(context).translate("titleFriendNotify")}"),
                      widgetShowFriendsSetting(
                        constraints: constraints,
                      ),
                      SizedBox(
                        height: 12.0,
                      )
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
