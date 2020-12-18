import 'package:flutter/material.dart';
import 'package:socialapp/findFriends/screens/show_lis_friends.dart';
import 'package:socialapp/localizations/languages.dart';

class appBarSetting extends StatefulWidget {
  final bool changeSize;

  const appBarSetting({Key key, this.changeSize}) : super(key: key);
  @override
  _appBarSettingState createState() => _appBarSettingState();
}

class _appBarSettingState extends State<appBarSetting> {
  bool size;

  @override
  void initState() {
    // TODO: implement initState
    size = widget.changeSize;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 700),
        height: size ? 140.0 : 120.0,
        color: Color(0xFFF3EFF9),
        child: Material(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AnimatedContainer(
                      // padding: EdgeInsets.all(4),
                      duration: Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 27,
                                offset: Offset(.5, .5),
                                spreadRadius: .1)
                          ]),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          size: 30.0,
                        ),
                        onPressed: () {
                          setState(() {
                            size = !size;
                          });
                        },
                      ),
                    ),
                    Text(
                      '${AppLocalizations.of(context).translate("titleSettingApp")}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    AnimatedContainer(
                        // padding: EdgeInsets.all(4),
                        duration: Duration(milliseconds: 800),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 27,
                                  offset: Offset(.5, .5),
                                  spreadRadius: .1)
                            ]),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 30.0,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AllUser(),
                            ));
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
