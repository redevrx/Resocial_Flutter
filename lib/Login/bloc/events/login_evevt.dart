import 'package:socialapp/Login/bloc/models/login_model.dart';
import 'package:socialapp/Login/bloc/models/signUpModel.dart';

abstract class LoginEvevt{}

class onLogin extends LoginEvevt
{
  final LoginModel data;

  onLogin(this.data);
}
class onSignUp extends LoginEvevt
{
  final SignUpModel data;

  onSignUp(this.data);
}
class onOpenSignUp extends LoginEvevt{}
class onOpenLogin extends LoginEvevt{}