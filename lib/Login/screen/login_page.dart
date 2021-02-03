import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/login_bloc.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'package:socialapp/Login/screen/register_user.dart';
import 'package:socialapp/Login/screen/widget/login/login_widget.dart';
import 'package:socialapp/home/screen/home_page.dart';
import 'package:socialapp/localizations/languages.dart';
import 'package:socialapp/widgets/appBar/app_bar_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  _checkUserLogin(context);
    return WillPopScope(
        child: Scaffold(
            body: BlocProvider(
          create: (context) => LoginBloc(),
          child: loginScreen(),
        )),
        onWillPop: () {
//          _checkUserLogin(context);
          new Future(() => false);
        });
  }
}

class loginScreen extends StatelessWidget {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
  //     print("Create UI Success");
  //   });
  // }

  // @override
  // void didChangeDependencies() {
  //   _checkUserLogin(context);
  //   print("Current Page Login");
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    //check user login app
    // _checkUserLogin(context);
    print("Current Page Login");

    //new instances Login bloc
    //use it manager user lgin or register
    //and event text change such as
    // - email -password
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: <Widget>[
                  //make app bar title login app
                  AppBarCustom(
                    title:
                        "${AppLocalizations.of(context).translate("titleSignIn")}",
                    titleColor: Color(0xFF0D8E53),
                    status: "login",
                  ),
                  SizedBox(
                    height: 2,
                  ),

                  // login bloc show status from event login
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is onShowProgressDialog) {
                        print("show dialog");
                        return CircularProgressIndicator();
                      } else if (state is onLoingFaield) {
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
                          //make background login page
                          cardShape(),
                          Column(
                            children: <Widget>[
                              // (kIsWeb)
                              //     ? Container(
                              //         width:
                              //             MediaQuery.of(context).size.width * 0.38,
                              //         child: textEmail(
                              //           txtEmail: txtEmail,
                              //         ),
                              //       )

                              //make bloc login track email change and keep it as shared pref
                              BlocBuilder<LoginBloc, LoginState>(
                                buildWhen: (previous, current) =>
                                    previous.email != current.email,
                                cubit: loginBloc,
                                builder: (context, state) {
                                  if (state is onEmailStateChange) {
                                    return textEmail(
                                        loginBloc: loginBloc, state: state);
                                  }
                                  return textEmail(
                                      loginBloc: loginBloc, state: null);
                                },
                              ),

                              //make bloc login track password and keep
                              BlocBuilder<LoginBloc, LoginState>(
                                buildWhen: (previous, current) =>
                                    previous.password != current.password,
                                cubit: loginBloc,
                                builder: (context, state) {
                                  if (state is onPasswordStateChange) {
                                    return textPassword(
                                        loginBloc: loginBloc, state: state);
                                  }
                                  return textPassword(
                                      loginBloc: loginBloc, state: null);
                                },
                              ),
                              // (kIsWeb)
                              //     ? Container(
                              //         width:
                              //             MediaQuery.of(context).size.width * 0.38,
                              //         child: textPassword(
                              //           txtPassword: txtPassword,
                              //           email: txtEmail.text,
                              //           loginBloc: loginBloc,
                              //         ),
                              //       )

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
                              //             buttonToSignUp(loginBloc: loginBloc),
                              //             buttonLogin(
                              //                 txtEmail: txtEmail,
                              //                 txtPassword: txtPassword,
                              //                 loginBloc: loginBloc)
                              //           ],
                              //         ),
                              //       )
                              //build button
                              _buildPaddingButton(loginBloc),

                              //make bloc login check status from event login
                              //and make navigator
                              BlocListener<LoginBloc, LoginState>(
                                cubit: loginBloc,
                                listener: (context, state) {
                                  if (state is onToSingUp) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SignUpScreen();
                                    }));
                                  } else if (state is onLoginSuccessfully) {
                                    print(state.toString());
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(
                                            pageNumber: 0,
                                          ),
                                        ),
                                        (route) => false);
                                    // Navigator.of(context).pushNamed("/home");
                                  } else if (state
                                      is onCreateAccountSuccessfully) {
                                    print("onLogin :" + state.data.toString());

                                    //

                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "/addProfile", (r) => false);
                                  }
                                },
                                child: Container(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  Padding _buildPaddingButton(LoginBloc loginBloc) {
    // double center = MediaQuery.of(context).size.width * .5;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 46.0, vertical: 43.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buttonToSignUp(loginBloc: loginBloc),
              buttonLogin(
                  // txtEmail: txtEmail,
                  // txtPassword: txtPassword,
                  loginBloc: loginBloc)
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () => loginBloc.add(onLoginWithGoogle()),
                  child: Container(
                      width: 42.0,
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        child: Image.asset("assets/icons/google.png"),
                      )),
                ),
                SizedBox(
                  width: 32.0,
                ),
                InkWell(
                  onTap: () => loginBloc.add(onLoginWithFacebook()),
                  child: Container(
                      width: 42.0,
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        child: Image.asset("assets/icons/facebook.png"),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   txtEmail.dispose();
  //   txtPassword.dispose();
  //   super.dispose();
  // }
}

//user login
//check uid
// Future _checkUserLogin(BuildContext context) async {
//   FirebaseAuth.instance.authStateChanges().listen((user) {
//     if (user != null) {
//       Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
//       print("Login ..." + user.uid);
//     } else {
//       print("yet Login.." + user.uid);
//     }
//   });
//   // final user = auth.currentUser;
// }
// ItemCardShaps(MediaQuery.of(context).size.width * 064, MediaQuery.of(context).size.height * 0.36)
