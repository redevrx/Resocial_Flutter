import 'package:socialapp/Login/bloc/models/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

@immutable
abstract class LoginState{}

class onLoginSuccessfully extends LoginState
{
  final String data;

  onLoginSuccessfully(this.data):super();

  @override
  String toString ()=> "uid :${data}";
}

class onCreateAccountSuccessfully extends LoginState
{
  final String data;

  onCreateAccountSuccessfully(this.data):super();

  @override
  String toString ()=> "uid :${data}";
}
class onLoingFaield extends LoginState
{
  final String data;

  onLoingFaield(this.data);
  @override
  String toString() => "${data}";
}
class onShowProgress extends LoginState{}
class onToSingUp extends LoginState{}
class onToLogin extends LoginState{}
class onShowProgressDialog extends LoginState{}
class onInitialState extends LoginState
{
  final String data;

  onInitialState({this.data = ""});
  @override
  String toString() {
    // TODO: implement toString
    return this.data;
  }
}