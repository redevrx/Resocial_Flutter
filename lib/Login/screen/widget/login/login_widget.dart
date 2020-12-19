import 'package:flutter/material.dart';
import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/login_bloc.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'package:socialapp/localizations/languages.dart';
import 'package:socialapp/widgets/cardBackground/item_card_shape_v2.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class buttonLogin extends StatelessWidget {
  const buttonLogin({
    Key key,
    @required this.loginBloc,
  }) : super(key: key);

  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 8.0,
      child: Text(
        "${AppLocalizations.of(context).translate("btnLogin")}",
        style: Theme.of(context).textTheme.headline6.apply(color: Colors.white),
      ),
      textColor: Colors.white,
      color: Color(0xFF0D8E53).withOpacity(.65),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      onPressed: () {
        // final data = LoginModel(txtEmail.text, txtPassword.text);

        loginBloc.add(onLogin(null));
      },
    );
  }
}

class buttonToSignUp extends StatelessWidget {
  const buttonToSignUp({
    Key key,
    @required this.loginBloc,
  }) : super(key: key);

  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text(
        "${AppLocalizations.of(context).translate("btnSingUp")}",
        style: Theme.of(context).textTheme.headline6.apply(color: Colors.white),
      ),
      borderSide: BorderSide(color: Color(0xFF0D8E53)),
      shape: StadiumBorder(),
      onPressed: () {
        // Navigator.of(context).pushNamed('/signUp');
        loginBloc.add(onOpenSignUp());
      },
    );
  }
}

class textPassword extends StatelessWidget {
  const textPassword({
    Key key,
    @required this.state,
    this.loginBloc,
  }) : super(key: key);
  final onPasswordStateChange state;
  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 33.0, right: 46.0, left: 46.0),
      child: Container(
        child: TextField(
          onChanged: (password) =>
              loginBloc.add(onPasswordChange(password: password)),
          onSubmitted: (value) {
            // final data = LoginModel(state.email.value, state.password.value);
            loginBloc.add(onLogin(null));
          },
          autofocus: false,
          obscureText: true,
          decoration: InputDecoration(
              errorText: (state == null)
                  ? null
                  : state.password.invalid
                      ? "${AppLocalizations.of(context).translate("invalidPassword")}"
                      : null,
              prefixIcon: Icon(Icons.vpn_key, color: Colors.white),
              filled: true,
              hintStyle: TextStyle(color: Colors.white),
              hintText:
                  "${AppLocalizations.of(context).translate("lablePassword")}",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                borderSide: BorderSide(width: 1, color: Colors.green),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.white70)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)))),
        ),
      ),
    );
  }
}

class textEmail extends StatelessWidget {
  const textEmail({
    Key key,
    @required this.loginBloc,
    this.state,
  }) : super(key: key);

  final LoginBloc loginBloc;
  final onEmailStateChange state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36.0, right: 36.0, top: 220.0),
      child: Container(
        child: TextField(
          onChanged: (email) => loginBloc.add(onEmailChange(email: email)),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email, color: Colors.white),
              filled: true,
              helperText: '',
              errorText: (state == null)
                  ? null
                  : state.email.invalid
                      ? "${AppLocalizations.of(context).translate("invalidEmail")}"
                      : null,
              hintStyle: TextStyle(color: Colors.white),
              hintText:
                  "${AppLocalizations.of(context).translate("lableEmail")}",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                borderSide: BorderSide(width: 1, color: Colors.green),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.white70)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)))),
        ),
      ),
    );
  }
}

class cardShape extends StatelessWidget {
  const cardShape({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
          clipper: BackgroundClipper(),
          child: Hero(
            tag: "background",
            child: Container(
              width:
                  //(kIsWeb)
                  //     ? MediaQuery.of(context).size.width * 0.41
                  MediaQuery.of(context).size.width * 0.9,
              height:
                  // (kIsWeb)
                  //     ? MediaQuery.of(context).size.height * 0.84
                  MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.green, Color(0xFF0D8E53).withOpacity(.78)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )),
            ),
          )),
    );
  }
}
