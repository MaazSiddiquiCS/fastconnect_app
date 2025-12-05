import 'package:equatable/equatable.dart';
import '../../../../domain/auth/entities/user.dart';

abstract class AuthState extends Equatable {
    AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
    AuthInitial();
}

class AuthLoading extends AuthState {
    AuthLoading();
}

class AuthRegisterSuccess extends AuthState {
  final User user;
  AuthRegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}


class AuthAuthenticated extends AuthState {
  final User user;
    AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
    AuthUnauthenticated();
}

class AuthFailure extends AuthState {
  final String message;
    AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}