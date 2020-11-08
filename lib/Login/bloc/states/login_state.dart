import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:socialapp/Login/bloc/models/emailModel.dart';
import 'package:socialapp/Login/bloc/models/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:socialapp/Login/bloc/models/passwordModel.dart';

@immutable
abstract class LoginState {
  final Email email;
  final Password password;
  final FormzStatus status;

  LoginState({this.email, this.password, this.status});
  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return "${this.email} ${this.password} ${this.status}";
  // }

  // LoginState copyWith({
  //   Email email,
  //   Password password,
  //   FormzStatus status,
  // }) {
  //   return LoginState(
  //     email: email ?? this.email,
  //     password: password ?? this.password,
  //     status: status ?? this.status,
  //   );
  // }
}

class onLoginSuccessfully extends LoginState {
  final String data;

  onLoginSuccessfully(this.data) : super();

  @override
  String toString() => "uid :${data}";
}

class onCreateAccountSuccessfully extends LoginState {
  final String data;

  onCreateAccountSuccessfully(this.data) : super();

  @override
  String toString() => "uid :${data}";
}

class onLoingFaield extends LoginState {
  final String data;

  onLoingFaield(this.data);
  @override
  String toString() => "${data}";
}

class onEmailStateChange extends LoginState {
  final Email email;
  final Password password;
  final FormzStatus status;

  onEmailStateChange({this.email, this.password, this.status});

  onEmailStateChange copyWith({
    Email email,
    Password password,
    FormzStatus status,
  }) {
    return onEmailStateChange(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}

class onPasswordStateChange extends LoginState {
  final Email email;
  final Password password;
  final FormzStatus status;

  onPasswordStateChange({this.email, this.password, this.status});

  onPasswordStateChange copyWith({
    Email email,
    Password password,
    FormzStatus status,
  }) {
    return onPasswordStateChange(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}

class onShowProgress extends LoginState {}

class onToSingUp extends LoginState {}

class onToLogin extends LoginState {}

class onShowProgressDialog extends LoginState {}

class onInitialState extends LoginState {
  final String data;

  onInitialState({this.data = ""});
  @override
  String toString() {
    // TODO: implement toString
    return this.data;
  }
}
