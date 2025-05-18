import 'package:bloc/bloc.dart';

import '/domains/gender.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthLogin extends AuthEvent {
  const AuthLogin();
}

class AuthSignUp extends AuthEvent {
  const AuthSignUp();
}

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();

  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  final String userName;

  const AuthSuccess({required this.userName});

  List<Object> get props => [userName];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  List<Object> get props => [message];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  void login(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      emit(AuthSuccess(userName: email));
    }
    emit(const AuthError(message: "Invalid Credentials"));
  }

  void register(String firstName, String lastName, String email, String phoneNo,
      Gender gender, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      emit(AuthSuccess(userName: email));
    }
    emit(const AuthError(message: "Invalid Credentials"));
  }
}
