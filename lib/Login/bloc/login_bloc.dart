import 'dart:collection';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/models/emailModel.dart';
import 'package:socialapp/Login/bloc/models/login_model.dart';
import 'package:socialapp/Login/bloc/models/passwordModel.dart';
import 'package:socialapp/Login/bloc/models/signUpModel.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginBloc extends Bloc<LoginEvevt, LoginState> {
  LoginBloc() : super(onInitialState());

//shared keep user data such as user name email pass
//alter use success if remove all that keep
  SharedPreferences _sharedPreferences;
  var _email1;

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
    } else if (event is onUserNameChange) {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.remove("userName");
      await _sharedPreferences.setString("userName", event.userName);
    } else if (event is onEmailChange) {
      _sharedPreferences = await SharedPreferences.getInstance();

      final _email = Email.dirty(event.email);
      _email1 = _email;
      _sharedPreferences.remove("email");
      await _sharedPreferences.setString("email", _email.value);

      yield onEmailStateChange()
          .copyWith(email: _email, status: Formz.validate([_email]));
    } else if (event is onPasswordChange) {
      _sharedPreferences = await SharedPreferences.getInstance();

      final _password = Password.dirty(event.password);
      _sharedPreferences.remove("password");
      await _sharedPreferences.setString("password", _password.value);
      yield onPasswordStateChange().copyWith(
          password: _password, status: Formz.validate([_password, _password]));
    } else if (event is onCmPasswordChange) {
      _sharedPreferences = await SharedPreferences.getInstance();

      final _password = Password.dirty(event.cmPassword);
      await _sharedPreferences.remove("cmPassword");
      await _sharedPreferences.setString("cmPassword", _password.value);
      yield onCmPasswordStateChange().copyWith(
          password: _password, status: Formz.validate([_password, _password]));
    }
  }

  @override
  Stream<LoginState> userRegister(onSignUp event) async* {
    _sharedPreferences = await SharedPreferences.getInstance();

    //firebaser instances
    final _auth = FirebaseAuth.instance;
    final _db = FirebaseFirestore.instance;

//add data that there in data shared pref as model
    final data = SignUpModel(
        _sharedPreferences.getString("email"),
        _sharedPreferences.getString("userName"),
        _sharedPreferences.getString("password"),
        _sharedPreferences.getString("cmPassword"));

// show dialog
    yield onShowProgressDialog();

    // data have to > 8
    //will change stable as version
    if (data.password == data.passwordCm && data.password.length >= 6) {
      //user create account
      //print(data.email+" : "+data.passwordCm);
      // print(
      //     "email :${data.email} user :${data.userName} passw : ${data.password} cmPass : ${data.passwordCm}");
      final it = await onCreateAccount(
          _auth, data.email.toString(), data.password.toString());
      if (it) {
        final use = await _auth.currentUser;
        final it2 = await onSaveData(_db, data, use.uid.toString());
        if (it2) {
          //use.uid.toString()
          //remove all data user register in shared preferace
          _sharedPreferences.remove("email");
          _sharedPreferences.remove("userName");
          _sharedPreferences.remove("password");
          _sharedPreferences.remove("cmPassword");
          yield onCreateAccountSuccessfully("${use.uid.toString()}");
        }
      } else {
        yield onLoingFaield("Create Account Failed.. password 8 char");
      }
    } else {
      // password invaid return failed
      yield onLoingFaield("Create Account Failed.. password 8 char");
    }
  }

  @override
  Stream<LoginState> openToLoginPage(onOpenLogin evevt) async* {
    yield onToLogin();
  }

  @override
  Stream<LoginState> checkLogin(onLogin evevt) async* {
    _sharedPreferences = await SharedPreferences.getInstance();

    yield onShowProgressDialog();

//add data to login model
//data from shared pref
    final data = LoginModel(_sharedPreferences.getString("email"),
        _sharedPreferences.getString("password"));

    final _auth = FirebaseAuth.instance;

//call on userLogin will retrun
//true if login success
    var it = await onUserLogin(_auth, data.email, data.password);

    if (it) {
      //remove email and password login
      _sharedPreferences.remove("email");
      _sharedPreferences.remove("password");
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
    // alter create account success return true
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

//alter create account success
//keep user info in database
  Future<bool> onSaveData(
      FirebaseFirestore db, SignUpModel data, String uid) async {
    //fi save user info success give return true

    //crate map data
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

//register with fireabser auth
//register with email password
  Future<bool> onUserLogin(
      FirebaseAuth auth, String email, String password) async {
    print("email :${email} : password : ${password}");
    return await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      return true;
    }).catchError((e) {
      return false;
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
