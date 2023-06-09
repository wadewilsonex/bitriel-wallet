# STRUCUTURE
├── lib/
│   ├── data/
│   │   ├── repositories/
│   │   │   └── account_repository.dart
│   │   └── sdk/
│   │       └── bitriel_sdk.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   └── account.dart
│   │   ├── models/
│   │   │   ├── account_model.dart
│   │   │   └── mnemonic_model.dart
│   │   ├── repositories/
│   │   │   └── account_repository.dart
│   │   └── use_cases/
│   │       ├── create_account_use_case.dart
│   │       └── import_account_use_case.dart
│   ├── presentation/
│   │   ├── providers/
│   │   │   └── account_provider.dart
│   │   ├── screens/
│   │   │   ├── create_account_screen.dart
│   │   │   └── import_account_screen.dart
│   │   └── widgets/
│   │       ├── account_card.dart
│   │       └── mnemonic_form.dart
│   └── standalone/
│       ├── utils/
│       │   └── utility_file.dart
│       ├── components/
│       │   └── component_file.dart
│       └── widgets/
│           └── widget_file.dart
├── pubspec.yaml
└── README.md

# State

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:domain/entities/user.dart';
import 'package:domain/usecases/get_user.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GetUser getUser;

  LoginBloc({this.getUser});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      try {
        final user = await getUser();
        yield LoginSuccess(user: user);
      } catch (e) {
        yield LoginFailure(error: e);
      }
    }
  }
}

enum LoginEvent {
  LoginButtonPressed,
}

class LoginState {
  final User user;
  final String error;

  LoginState({this.user, this.error});

  factory LoginState.initial() => LoginState(user: null, error: null);

  factory LoginState.success({User user}) => LoginState(user: user, error: null);

  factory LoginState.failure({String error}) => LoginState(user: null, error: error);
}

# UIs
import 'package:flutter/material.dart';
import 'package:domain/entities/user.dart';
import 'package:presentation/blocs/login_bloc.dart';
import 'package:presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  final LoginBloc bloc;

  LoginScreen({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: LoginForm(
          bloc: bloc,
        ),
      ),
    );
  }
}


Data <- Repository <- Usecases <- Provider <- Presentation