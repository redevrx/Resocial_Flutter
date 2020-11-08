import 'package:socialapp/Login/bloc/models/login_model.dart';
import 'package:socialapp/Login/bloc/models/signUpModel.dart';

abstract class LoginEvevt {}

class onLogin extends LoginEvevt {
  final LoginModel data;

  onLogin(this.data);
}

class onSignUp extends LoginEvevt {
  final SignUpModel data;

  onSignUp(this.data);
}

class onUserNameChange extends LoginEvevt {
  final String userName;

  onUserNameChange({this.userName});
}

class onCmPasswordChange extends LoginEvevt {
  final String cmPassword;

  onCmPasswordChange({this.cmPassword});
}

class onEmailChange extends LoginEvevt {
  final String email;

  onEmailChange({this.email});
}

class onPasswordChange extends LoginEvevt {
  final String password;

  onPasswordChange({this.password});
}

class onOpenSignUp extends LoginEvevt {}

class onOpenLogin extends LoginEvevt {}
