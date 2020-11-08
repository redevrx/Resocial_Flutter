import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String _email;
  final String _password;

  LoginModel(this._email, this._password);

  String get email => this._email;
  String get password => this._password;

  @override
  // TODO: implement props
  List<Object> get props => [this._email, this._password];
}
