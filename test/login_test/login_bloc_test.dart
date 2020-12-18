import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialapp/Login/bloc/events/login_evevt.dart';
import 'package:socialapp/Login/bloc/login_bloc.dart';
import 'package:socialapp/Login/bloc/states/login_state.dart';
import 'dart:async';

void main() {
  LoginBloc loginBloc;

  setUp(() {
    loginBloc = LoginBloc(); //Login_Bloc_Mock();
  });

// login test
  group("when enter email password and login sucess", () {
    blocTest<LoginBloc, LoginState>(
      "initial LoginBloc",
      build: () => LoginBloc(),
      act: (cubit) async => cubit.add(onLogin(null)),
      expect: [onShowProgressDialog()],
    );
  });
}
