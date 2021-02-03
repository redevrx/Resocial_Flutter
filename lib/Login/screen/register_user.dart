import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/login_bloc.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'package:socialapp/Login/screen/widget/login/login_widget.dart';
import 'package:socialapp/Login/screen/widget/register/register_widget.dart';
import 'package:socialapp/localizations/languages.dart';
import 'package:socialapp/widgets/appBar/app_bar_login.dart';
import 'package:socialapp/widgets/cardBackground/item_card_shape_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => LoginBloc(),
      child: signUpScreen(),
    ));
  }
}

class signUpScreen extends StatelessWidget {
  /*
  method check user login app 
  if user there value is null
  represend user not login 
  */
  // void checkUserLogin(BuildContext context) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     Navigator.pushNamedAndRemoveUntil(context, "/addProfile", (r) => false);
  //     print("register ...");
  //   } else {
  //     print("yet register..");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    /*
    make new instance Login bloc
    for use manager register such as
     - register user 
     - to login page
     */
    final LoginBloc loginBloc =
        BlocProvider.of<LoginBloc>(context); //context.bloc<LoginBloc>();

    //call checkUserLogin
    // checkUserLogin(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: <Widget>[
                  // app bar page
                  AppBarCustom(
                    title:
                        "${AppLocalizations.of(context).translate("titleSignUp")}",
                    titleColor: Color(0xFFFF2D55),
                    status: "register",
                  ),

                  //  create container shap path
                  SizedBox(
                    height: 12,
                  ),

                  //bloc login show status user register
                  //
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is onShowProgressDialog) {
                        return CircularProgressIndicator();
                      } else if (state is onLoingFaield) {
                        print("onLoginFailed :" + state.toString());
                        return Text(state.data);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Container(
                    height: constraints.maxHeight * .82,
                    child: SingleChildScrollView(
                      child: Stack(
                        children: <Widget>[
                          //card background
                          cardShape(context),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 0.0,
                              ),
                              // (kIsWeb)
                              //     ? Container(
                              //         width:
                              //             MediaQuery.of(context).size.width * 0.38,
                              //         child: textEmail(
                              //           email: txtEmail,
                              //         ),
                              //       )
                              //make bloc check text email change
                              //
                              BlocBuilder<LoginBloc, LoginState>(
                                buildWhen: (previous, current) =>
                                    previous.email != current.email,
                                cubit: loginBloc,
                                builder: (context, state) {
                                  if (state is onEmailStateChange) {
                                    textEmail(
                                      loginBloc: loginBloc,
                                      state: state,
                                    );
                                  }
                                  return textEmail(
                                    loginBloc: loginBloc,
                                    state: null,
                                  );
                                },
                              ),
                              // (kIsWeb)
                              //     ? Container(
                              //         width:
                              //             MediaQuery.of(context).size.width * 0.38,
                              //         child: textUserName(
                              //           userName: txtUserName,
                              //         ),
                              //       )

                              //make login bloc for track data that change
                              textUserName(
                                loginBloc: loginBloc,
                              ),

                              // (kIsWeb)
                              //     ? Container(
                              //         width:
                              //             MediaQuery.of(context).size.width * 0.38,
                              //         child: textPassword(
                              //           password: txtPass,
                              //         ),
                              //       )
                              //make bloc password change
                              BlocBuilder<LoginBloc, LoginState>(
                                buildWhen: (previous, current) =>
                                    previous.password != current.password,
                                cubit: loginBloc,
                                builder: (context, state) {
                                  if (state is onPasswordStateChange) {
                                    return txtPassword(
                                      loginBloc: loginBloc,
                                      state: state,
                                    );
                                  }
                                  return txtPassword(
                                    loginBloc: loginBloc,
                                    state: null,
                                  );
                                },
                              ),

                              // (kIsWeb)
                              //     ? Container(
                              //         width:
                              //             MediaQuery.of(context).size.width * 0.38,
                              //         child: textPasswordCm(
                              //           passwordCm: textPassCm,
                              //         ),
                              //       )
                              //password change
                              BlocBuilder<LoginBloc, LoginState>(
                                cubit: loginBloc,
                                builder: (context, state) {
                                  if (state is onCmPasswordStateChange) {
                                    return textPasswordCm(
                                      loginBloc: loginBloc,
                                      state: state,
                                    );
                                  }
                                  return textPasswordCm(
                                    loginBloc: loginBloc,
                                    state: null,
                                  );
                                },
                              ),

                              // create button action
                              // (kIsWeb)
                              //     ? Container(
                              //         width:
                              //             MediaQuery.of(context).size.width * 0.38,
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 46.0, vertical: 43.0),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: <Widget>[
                              //             buttonToLogin(
                              //               bloc: loginBloc,
                              //             ),
                              //             buttonSignUp(
                              //               bloc: loginBloc,
                              //               email: txtEmail.text,
                              //               userName: txtUserName.text,
                              //               password: txtPass.text,
                              //               passwordCm: textPassCm.text,
                              //             )
                              //           ],
                              //         ),
                              //       )
                              //create  button
                              //btn to login and btn sing up
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 22.0, horizontal: 42.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    buttonToLogin(
                                      bloc: loginBloc,
                                    ),
                                    buttonSignUp(
                                      bloc: loginBloc,
                                    )
                                  ],
                                ),
                              ),

                              //bloc listener
                              //check status register
                              BlocListener<LoginBloc, LoginState>(
                                cubit: loginBloc,
                                listener: (context, state) {
                                  if (state is onToLogin) {
                                    print("onLogin :to login page");
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/login', (r) => false);
                                  }
                                  if (state is onCreateAccountSuccessfully) {
                                    print("onLogin :" + state.data.toString());
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "/addProfile", (r) => false);
                                  }
                                },
                                child: Container(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  Align cardShape(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: BackgroundClipper(),
        child: Hero(
            tag: 'background',
            child: Container(
              width:
                  //  (kIsWeb)
                  //     ? MediaQuery.of(context).size.width * 0.41
                  MediaQuery.of(context).size.width * 0.9,
              height:
                  // (kIsWeb)
                  //     ? MediaQuery.of(context).size.height * 0.84
                  MediaQuery.of(context).size.height * 0.89,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )),
            )),
      ),
    );
  }
}

class buttonSignUp extends StatelessWidget {
  final LoginBloc bloc;
  const buttonSignUp({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("${AppLocalizations.of(context).translate("btnSingUp")}"),
      elevation: 8.0,
      textColor: Colors.white.withOpacity(.9),
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        // print("on Register on work");
        // final data = SignUpModel(email, userName, password, passwordCm);
        // print("Password :" + data.password + passwordCm);
        //user register click
        FocusScope.of(context).unfocus();
        bloc.add(onSignUp(null));
      },
    );
  }
}

// class buttonToLogin extends StatelessWidget {
//   final LoginBloc bloc;

//   const buttonToLogin({
//     Key key, this.bloc,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//         data: ThemeData(primaryColor: Colors.red),
//         child: OutlineButton(
//           highlightedBorderColor: Colors.red,
//           child: Text(
//             'Login',
//             style: Theme.of(context)
//                 .textTheme
//                 .headline5
//                 .apply(color: Colors.white.withOpacity(.7)),
//           ),
//           onPressed: () {
//             bloc.add(onOpenLogin());
//           },
//           borderSide: BorderSide(color: Colors.red),
//           shape: StadiumBorder(),
//         ));
//   }
// }

// class textPasswordCm extends StatelessWidget {
//   final TextEditingController passwordCm;

//   const textPasswordCm({
//     Key key, this.passwordCm,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.only(top: 12.0, right: 36.0, left: 36.0),
//         child: Theme(
//           data: ThemeData(
//               inputDecorationTheme: InputDecorationTheme(
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)))),
//           child: Container(
//             child: TextField(
//               controller: passwordCm,
//               autofocus: false,
//               obscureText: true,
//               decoration: InputDecoration(
//                   hintText: "Password",
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20.0),
//                         bottomRight: Radius.circular(20.0)),
//                     borderSide: BorderSide(width: 1, color: Colors.red),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20.0),
//                           bottomRight: Radius.circular(20.0)),
//                       borderSide:
//                           BorderSide(color: Colors.red.withOpacity(.3))),
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20.0),
//                           bottomRight: Radius.circular(20.0)))),
//             ),
//           ),
//         ));
//   }
// }

// class textPassword extends StatelessWidget {
//   final TextEditingController password;

//   const textPassword({
//     Key key, this.password,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.only(top: 12.0, right: 36.0, left: 36.0),
//         child: Theme(
//           data: ThemeData(
//               inputDecorationTheme: InputDecorationTheme(
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)))),
//           child: Container(
//             child: TextField(
//               controller: password,
//               obscureText: true,
//               decoration: InputDecoration(
//                   hintText: "Password",
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20.0),
//                         bottomRight: Radius.circular(20.0)),
//                     borderSide: BorderSide(width: 1, color: Colors.red),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20.0),
//                           bottomRight: Radius.circular(20.0)),
//                       borderSide:
//                           BorderSide(color: Colors.red.withOpacity(.3))),
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20.0),
//                           bottomRight: Radius.circular(20.0)))),
//             ),
//           ),
//         ));
//   }
// }

// class textUserName extends StatelessWidget {
//   final TextEditingController userName;

//   const textUserName({
//     Key key, this.userName,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.only(top: 12.0, right: 36.0, left: 36.0),
//         child: Theme(
//           data: ThemeData(
//               inputDecorationTheme: InputDecorationTheme(
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)))),
//           child: Container(
//             child: TextField(
//               controller: userName,
//               decoration: InputDecoration(
//                   hintText: "User Name",
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20.0),
//                         bottomRight: Radius.circular(20.0)),
//                     borderSide: BorderSide(width: 1, color: Colors.red),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20.0),
//                           bottomRight: Radius.circular(20.0)),
//                       borderSide:
//                           BorderSide(color: Colors.red.withOpacity(.3)
//                           )
//                           ),
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20.0),
//                           bottomRight: Radius.circular(20.0)))),
//             ),
//           ),
//         ));
//   }
// }

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
