import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_buttonx/materialButtonX.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/login_bloc.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/home/bloc/event_pageChange.dart';
import 'package:socialapp/localizations/languages.dart';

class widgetShowAccountSetting extends StatefulWidget {
  final BoxConstraints constraints;
  final PageNaviagtorChageBloc pageNaviagtorChageBloc;

  const widgetShowAccountSetting(
      {Key key, this.constraints, this.pageNaviagtorChageBloc})
      : super(key: key);

  @override
  _widgetShowAccountSettingState createState() =>
      _widgetShowAccountSettingState();
}

class _widgetShowAccountSettingState extends State<widgetShowAccountSetting> {
  AppLocalizations localeApp;
  LoginBloc loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    localeApp = AppLocalizations(null);
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
                        Icons.account_circle,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "${AppLocalizations.of(context).translate("lableProfile")}",
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
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => HomePage(
                      //     pageNumber: 2,
                      //   ),
                      // ));
                      widget.pageNaviagtorChageBloc
                          .add(onPageChangeEvent(pageNumber: 2));
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
                        "${AppLocalizations.of(context).translate("titleForgotPassword")}",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      //show dialog question change password
                      _userChangePassword(context);
                    },
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
                        "${AppLocalizations.of(context).translate("titleSingOut")}",
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
                      try {
                        final _ref = await SharedPreferences.getInstance();
                        _ref.remove("uid");
                        final _mAuth = FirebaseAuth.instance;
                        await _mAuth.signOut();
                        await GoogleSignIn().signOut();

                        Navigator.pushNamedAndRemoveUntil(
                            context, "/login", (r) => false);
                      } catch (e) {
                        print("login error :$e");

                        Navigator.pushNamedAndRemoveUntil(
                            context, "/login", (r) => false);
                      }
                    },
                  )
                ],
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.language_rounded,
                        size: 35.0,
                        color: Colors.black.withOpacity(.55),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        "${AppLocalizations.of(context).translate("titleLanguage")}",
                        style: Theme.of(context).textTheme.headline6.apply(
                              color: Colors.black.withOpacity(.65),
                            ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      if (await localeApp.readLocaleKey() == "th") {
                        localeApp.setLocale(context, new Locale("en", "EN"));
                      } else
                        localeApp.setLocale(context, new Locale("th", "TH"));
                    },
                    child: Icon(
                      Icons.refresh_outlined,
                      size: 30.0,
                      color: Colors.black.withOpacity(.55),
                    ),
                  )
                ],
              ),
            ),
            //
            SizedBox(
              height: 4.0,
              width: widget.constraints.maxWidth,
              child: Divider(
                color: Colors.black.withOpacity(.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showResult(
      BuildContext context, String message, Color typeColor, bool from) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "alert result for change password",
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, (from) ? -1 : 1), end: Offset.zero)
              .animate(animation),
          child: child,
        );
      },
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: from ? Alignment.bottomCenter : Alignment.topCenter,
          child: Container(
            height: 150.0,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 62.0),
            padding: EdgeInsets.only(right: 4.0),
            decoration: BoxDecoration(
                color: typeColor, borderRadius: BorderRadius.circular(22.0)),
            child: Stack(
              children: [
                Container(
                  height: 150.0,
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.0)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12.0,
                      ),
                      Text("${message}",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              decorationColor: Colors.white)),
                      Spacer(),
                      Material(
                        child: MaterialButtonX(
                          onClick: () => Navigator.of(context).pop(),
                          color: Colors.blueAccent,
                          height: 38.0,
                          icon: Icons.offline_pin,
                          iconSize: 20.0,
                          message:
                              "${AppLocalizations.of(context).translate("btnOk")}",
                          radius: 38.0,
                          width: 110.0,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _userChangePassword(BuildContext context) {
    bool _from = false;
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "user change passowrd",
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, (_from) ? -1 : 1), end: Offset.zero)
              .animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: _from ? Alignment.bottomCenter : Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 62.0),
            padding: EdgeInsets.only(right: 4.0),
            width: double.infinity,
            height: 250.0,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(22.0)),
            child: Stack(
              children: [
                Positioned(
                    child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  height: 250.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.0)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        "${AppLocalizations.of(context).translate("titleForgotPassword")}",
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            decorationColor: Colors.white),
                      ),
                      SizedBox(
                        height: 42.0,
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) =>
                            previous.email != current.email,
                        cubit: loginBloc,
                        builder: (context, state) {
                          if (state is onEmailStateChange) {
                            print("onEmailStateChange");
                            //current password
                            Material(
                                child: TextField(
                                    onSubmitted: (email) => loginBloc.add(
                                        onUserChangePassowrdEvent(
                                            email: email)),
                                    onChanged: (email) => loginBloc
                                        .add(onEmailChange(email: email)),
                                    enableInteractiveSelection: false,
                                    decoration: InputDecoration(
                                      filled: true,
                                      errorText: (state == null)
                                          ? null
                                          : state.email.invalid
                                              ? "${AppLocalizations.of(context).translate("invalidEmail")}"
                                              : null,
                                      hintText:
                                          "${AppLocalizations.of(context).translate("textEmailResetPassword")}",
                                      enabledBorder: InputBorder.none,
                                    )));
                          }
                          return Material(
                              child: TextFormField(
                                  onChanged: (email) => loginBloc
                                      .add(onEmailChange(email: email)),
                                  enableInteractiveSelection: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText:
                                        "${AppLocalizations.of(context).translate("textEmailResetPassword")}",
                                    enabledBorder: InputBorder.none,
                                  )));
                        },
                      ),
                      Spacer(),
                      BlocListener<LoginBloc, LoginState>(
                        cubit: loginBloc,
                        listener: (context, state) {
                          if (state is onUserChangePasswordState) {
                            //show alert dialog success
                            Navigator.of(context).pop();
                            _showResult(
                                context,
                                "${AppLocalizations.of(context).translate("textResetPassowrdSuccess")}",
                                Colors.green,
                                true);
                          }
                          if (state is onUserChangePasswordErrorState) {
                            //show alert dialog error
                            Navigator.of(context).pop();
                            _showResult(
                                context,
                                "${AppLocalizations.of(context).translate("textResetPasswordError")}",
                                Colors.redAccent,
                                true);
                          }
                        },
                        child: Container(),
                      ),
                      Material(
                        child: MaterialButtonX(
                          onClick: () => loginBloc
                              .add(onUserChangePassowrdEvent(email: null)),
                          color: Colors.blueAccent,
                          height: 38.0,
                          icon: Icons.vpn_key_rounded,
                          iconSize: 20.0,
                          message:
                              "${AppLocalizations.of(context).translate("btnOk")}",
                          radius: 38.0,
                          width: 110.0,
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
