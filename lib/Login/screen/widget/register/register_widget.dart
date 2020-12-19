import 'package:flutter/material.dart';
import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/login_bloc.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'package:socialapp/localizations/languages.dart';

class buttonToLogin extends StatelessWidget {
  final LoginBloc bloc;

  const buttonToLogin({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(primaryColor: Colors.red),
        child: OutlineButton(
          highlightedBorderColor: Colors.red,
          child: Text(
            "${AppLocalizations.of(context).translate("btnLogin")}",
            style: Theme.of(context)
                .textTheme
                .headline5
                .apply(color: Colors.white.withOpacity(.7)),
          ),
          onPressed: () {
            bloc.add(onOpenLogin());
          },
          borderSide: BorderSide(color: Colors.red),
          shape: StadiumBorder(),
        ));
  }
}

class textPasswordCm extends StatelessWidget {
  final LoginBloc loginBloc;
  final onCmPasswordStateChange state;

  const textPasswordCm({
    Key key,
    this.loginBloc,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, right: 36.0, left: 36.0),
        child: Theme(
          data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)))),
          child: Container(
            child: TextField(
              onSubmitted: (value) => loginBloc.add(onSignUp(null)),
              onChanged: (cmPassword) =>
                  loginBloc.add(onCmPasswordChange(cmPassword: cmPassword)),
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                  errorText: (state == null)
                      ? null
                      : state.password.invalid
                          ? "${AppLocalizations.of(context).translate("invalidPassword")}"
                          : null,
                  hintText:
                      "${AppLocalizations.of(context).translate("lableConfrimPassword")}",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: Colors.red.withOpacity(.3))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)))),
            ),
          ),
        ));
  }
}

class txtPassword extends StatelessWidget {
  final LoginBloc loginBloc;
  final onPasswordStateChange state;
  const txtPassword({
    Key key,
    this.loginBloc,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, right: 36.0, left: 36.0),
        child: Theme(
          data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)))),
          child: Container(
            child: TextField(
              onChanged: (password) =>
                  loginBloc.add(onPasswordChange(password: password)),
              obscureText: true,
              decoration: InputDecoration(
                  errorText: (state == null)
                      ? null
                      : state.password.invalid
                          ? "${AppLocalizations.of(context).translate("invalidPassword")}"
                          : null,
                  hintText:
                      "${AppLocalizations.of(context).translate("lablePassword")}",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: Colors.red.withOpacity(.3))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)))),
            ),
          ),
        ));
  }
}

class textUserName extends StatelessWidget {
  final LoginBloc loginBloc;

  const textUserName({
    Key key,
    this.loginBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, right: 36.0, left: 36.0),
        child: Theme(
          data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)))),
          child: Container(
            child: TextField(
              onChanged: (name) =>
                  loginBloc.add(onUserNameChange(userName: name)),
              decoration: InputDecoration(
                  hintText:
                      "${AppLocalizations.of(context).translate("lableUserName")}",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: Colors.red.withOpacity(.3))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)))),
            ),
          ),
        ));
  }
}

// class textEmail extends StatelessWidget {
//   final TextEditingController email;
//   const textEmail({
//     Key key, this.email,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.only(left: 46.0, right: 46.0, top: 146.0),
//           child: Container(
//             child: TextField(
//               controller: email,
//           decoration: InputDecoration(
//               hintText: "Email",
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20.0),
//                     bottomRight: Radius.circular(20.0)),
//                 borderSide: BorderSide(width: 1, color: Colors.red),
//               ),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.0),
//                       bottomRight: Radius.circular(20.0)),
//                   borderSide: BorderSide(color: Colors.red.withOpacity(.3))),
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.0),
//                       bottomRight: Radius.circular(20.0)))),
//         ),
//       ),
//     );
//   }
// }
