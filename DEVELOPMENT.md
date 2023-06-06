# The three-tier architecture. 
# The three-tier architecture is a common software architecture that is used to design and develop large, complex applications
## In this project we follow Three-Layers, such as DATA, DOMAIN, PRESENTATION Layers for project structure.
## Also inside presentation layers we follow Features-First structure.

# STRUCUTURE
app
├──lib
│   ├── data
│   │   ├── providers
│   │   │   └── bitriel_sdk_provider.dart
│   │   ├── sdk
│   │   │   └── bitriel_sdk.dart
│   │   └── repositories
│   │       └── bitriel_repository.dart
│   ├── domain
│   │   ├── entities
│   │   │   └── bitriel_data.dart
│   │   ├── usecases
│   │   │   └── get_bitriel_data.dart
│   │   └── state
│   │       └── bitriel_state.dart
│   └── presentation
│       ├── components
│       │   ├── button.dart
│       │   └── text_field.dart
│       ├── screens
│       │   ├── home_screen.dart
│       │   └── bitriel_screen.dart
│       └── widgets
│           ├── app_bar.dart
│           └── list_view.dart
└── pubspec.yaml

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