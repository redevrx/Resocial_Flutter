import 'package:flutter/material.dart';
import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/login_bloc.dart';

class buttonToLogin extends StatelessWidget {
  final LoginBloc bloc;
  
  const buttonToLogin({
    Key key, this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(primaryColor: Colors.red),
        child: OutlineButton(
          highlightedBorderColor: Colors.red,
          child: Text(
            'Login',
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
  final TextEditingController passwordCm;
  
  const textPasswordCm({
    Key key, this.passwordCm,
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
              controller: passwordCm,
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password",
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

class textPassword extends StatelessWidget {
  final TextEditingController password;
  
  const textPassword({
    Key key, this.password,
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
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password",
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
  final TextEditingController userName;
  
  const textUserName({
    Key key, this.userName,
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
              controller: userName,
              decoration: InputDecoration(
                  hintText: "User Name",
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
                          BorderSide(color: Colors.red.withOpacity(.3)
                          )
                          ),
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

class textEmail extends StatelessWidget {
  final TextEditingController email;
  const textEmail({
    Key key, this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 46.0, right: 46.0, top: 146.0),
          child: Container(
            child: TextField(
              controller: email,
          decoration: InputDecoration(
              hintText: "Email",
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
                  borderSide: BorderSide(color: Colors.red.withOpacity(.3))),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)))),
        ),
      ),
    );
  }
}
