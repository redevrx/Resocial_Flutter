import 'dart:collection';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
import 'package:socialapp/userPost/screen/create_new_post.dart';

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
    } else if (event is onUserChangePassowrdEvent) {
      yield* onChangePassword(event);
    } else if (event is onLoginWithGoogle) {
      yield* onLoginGoogle(event);
    } else if (event is onLoginWithFacebook) {
      yield* onLoginFacebook(event);
    }
  }

  @override
  Stream<LoginState> onLoginFacebook(onLoginWithFacebook event) async* {
    final result = await signInWithFacebook();
    if (result) {
      yield onCreateAccountSuccessfully("signIn Success");
    } else {
      yield onLoingFaield("Error Not Access Your Email..");
    }
  }

//google login
  @override
  Stream<LoginState> onLoginGoogle(onLoginWithGoogle event) async* {
    final result = await signInWithGoogle();
    if (result) {
      yield onCreateAccountSuccessfully("signIn Success");
    } else {
      yield onLoingFaield("Error Not Access Your Email..");
    }
  }

  @override
  Stream<LoginState> onChangePassword(onUserChangePassowrdEvent event) async* {
    final _auth = FirebaseAuth.instance;
    _sharedPreferences = await SharedPreferences.getInstance();
    bool checkError = false;

    await _auth
        .sendPasswordResetEmail(
            email: event.email ?? _sharedPreferences.getString("email"))
        .whenComplete(() {
      print("send change password in email success");
      checkError = true;
    }).catchError((e) {
      print("error send change password in email :${e}");
      checkError = false;
    });

    if (checkError) {
      //send email change password
      //success
      //remove all data user register in shared preferace
      await _sharedPreferences.remove("email");
      yield onUserChangePasswordState("");
    } else {
      //error
      //remove all data user register in shared preferace
      await _sharedPreferences.remove("email");
      yield onUserChangePasswordErrorState("resulError");
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
    if (data.password == data.passwordCm && data.password.length >= 8) {
      //user create account
      //print(data.email+" : "+data.passwordCm);
      // print(
      //     "email :${data.email} user :${data.userName} passw : ${data.password} cmPass : ${data.passwordCm}");
      final it = await onCreateAccount(
          _auth, data.email.toString(), data.password.toString());
      if (it) {
        final use = await _auth.currentUser;
        final it2 = await onSaveData(_db, data, null, use.uid.toString());
        if (it2) {
          //use.uid.toString()
          //remove all data user register in shared preferace
          await _sharedPreferences.remove("email");
          await _sharedPreferences.remove("userName");
          await _sharedPreferences.remove("password");
          await _sharedPreferences.remove("cmPassword");
          print("craete account success");
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

/*
this method will sign in with facebook
 */
  Future<bool> signInWithFacebook() async {
    // / Trigger the sign-in flow
    // final result = await FacebookAuth.instance.login();

    // // Create a credential from the access token
    // final credential = FacebookAuthProvider.credential(result.token);

    // final user = await FirebaseAuth.instance.signInWithCredential(credential);

    // if (user.user.email != null) {
    //   await onSaveData(
    //       FirebaseFirestore.instance,
    //       new SignUpModel(
    //           user.user.email, user.user.displayName, "password", "passwordCm"),
    //       user.user.uid);
    //   return true;
    // } else {
    //   await GoogleSignIn().signOut();
    //   return false;
    // }
  }

/*
login with google 
and get email and user anme
 */
  Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleInUser = await GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    ).signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleInUser.authentication;

    // / Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //use google login with firebase
    final user = await FirebaseAuth.instance.signInWithCredential(credential);

    if (user.user.email != null) {
      await onSaveData(
          FirebaseFirestore.instance,
          new SignUpModel(
              user.user.email, user.user.displayName, "password", "passwordCm"),
          user.user.photoURL,
          user.user.uid);
      return true;
    } else {
      await GoogleSignIn().signOut();
      return false;
    }
  }

//alter create account success
//keep user info in database
  Future<bool> onSaveData(
      FirebaseFirestore db, SignUpModel data, String image, String uid) async {
    //fi save user info success give return true

    //crate map data
    Map<String, Object> mapBody = HashMap();
    mapBody["email"] = data.email;
    mapBody["user"] = data.userName;
    mapBody["uid"] = uid;
    mapBody["imageProfile"] = image ?? "";
    return await db.collection("user info").doc(uid).set(mapBody).then((data) {
      return true;
    }).catchError((e) {
      return false;
    });
  }

//register with fireabser auth
//register with email password
  Future<bool> onUserLogin(
    FirebaseAuth auth,
    String email,
    String password,
  ) async {
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
