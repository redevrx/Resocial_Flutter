import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  Password.pure() : super.pure('');
  Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError validator(String value) {
    // TODO: implement validator
    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}
