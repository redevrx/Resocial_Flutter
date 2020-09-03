import 'dart:collection';
import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/models/signUpModel.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginBloc extends Bloc<LoginEvevt, LoginState> {
  LoginBloc() : super(onInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvevt event) async* {
    if (event is onLogin) {
      yield* checkLogin(event);
    } else if (event is onOpenSignUp) {
      yield* openToSignUpPage(event);
    } else if (event is onOpenLogin) {
      yield* openToLoginPage(event);
    } else if (event is onSignUp) {
      yield* userRegister(event);
    }
  }

  @override
  Stream<LoginState> userRegister(onSignUp event) async* {
    final data = event.data;
    final _auth = FirebaseAuth.instance;
    final _db = FirebaseFirestore.instance;

    yield onShowProgressDialog();

    if (data.password == data.passwordCm && data.password.length >= 6) {
      //user create account
      //print(data.email+" : "+data.passwordCm);
      final it = await onCreateAccount(
          _auth, data.email.toString(), data.password.toString());
      if (it) {
        final use = await _auth.currentUser;
        final it2 = await onSaveData(_db, data, use.uid.toString());
        if (it2) {
          //use.uid.toString()
          yield onCreateAccountSuccessfully("${use.uid.toString()}");
        }
      } else {
        yield onLoingFaield("Create Account Failed.. password 6 char");
      }
    } else {
      // password invaid return failed
      yield onLoingFaield("Password invalid");
    }
  }

  @override
  Stream<LoginState> openToLoginPage(onOpenLogin evevt) async* {
    yield onToLogin();
  }

  @override
  Stream<LoginState> checkLogin(onLogin evevt) async* {
    final data = evevt.data;
    final _auth = FirebaseAuth.instance;

    yield onShowProgressDialog();

    var it = await onUserLogin(_auth, data.email, data.password);

    if (it) {
      yield onLoginSuccessfully("Login Successfully..");
    } else {
      yield onLoingFaield("Password invalid");
    }
  }

  @override
  Stream<LoginState> openToSignUpPage(onOpenSignUp evevt) async* {
    // navigatorKey.currentState.pushNamed("/signUp");
    yield onToSingUp();
  }

  Future<bool> onCreateAccount(
      FirebaseAuth auth, String email, String password) async {
    return await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user.uid.toString());
      print(value.user.email.toString());
      return true;
    }).catchError((e) {
      print("Error: " + e);
      return false;
    });
  }

  Future<bool> onSaveData(
      FirebaseFirestore db, SignUpModel data, String uid) async {
    Map<String, Object> mapBody = HashMap();
    mapBody["email"] = data.email;
    mapBody["user"] = data.userName;
    mapBody["uid"] = uid;
    return await db.collection("user info").doc(uid).set(mapBody).then((data) {
      return true;
    }).catchError((e) {
      return false;
    });
  }

  Future<bool> onUserLogin(
      FirebaseAuth auth, String email, String password) async {
    return await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      return true;
    }).catchError((e) {
      return false;
    });
  }
}
