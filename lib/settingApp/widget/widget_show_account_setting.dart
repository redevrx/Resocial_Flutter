import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/home/screen/home_page.dart';

class widgetShowAccountSetting extends StatefulWidget {
  final BoxConstraints constraints;

  const widgetShowAccountSetting({Key key, this.constraints}) : super(key: key);

  @override
  _widgetShowAccountSettingState createState() =>
      _widgetShowAccountSettingState();
}

class _widgetShowAccountSettingState extends State<widgetShowAccountSetting> {
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
                        Icons.account_circle,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "Profile",
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
                        builder: (context) => HomePage(
                          pageNumber: 2,
                        ),
                      ));
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
                        Icons.vpn_key,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "Forget Password",
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
                        Icons.exit_to_app,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "Sing out",
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
                    onTap: () async {
                      final _ref = await SharedPreferences.getInstance();
                      _ref.remove("uid");
                      final _mAuth = FirebaseAuth.instance;
                      await _mAuth.signOut();

                      Navigator.pushNamedAndRemoveUntil(
                          context, "/login", (r) => false);
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
