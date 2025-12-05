import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_logged_in_user.dart';
import '../../../../domain/auth/usecases/login.dart';
import '../../../../domain/auth/usecases/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/auth/usecases/register.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final GetLoggedInUser getUserUseCase;
  final Register registerUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getUserUseCase,
    required this.registerUseCase
  }) : super( AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
  }

  // ──────────────────────────────────────────────────────────────
  // Register Requested
  // ──────────────────────────────────────────────────────────────
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Use Case returns Either<Failure, AuthResult>
    final result = await registerUseCase(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (authResult) async {
        // FIX: Extract the token from AuthResult and save it
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', authResult.accessToken);
        
        // Emit success with the User entity
        emit(AuthRegisterSuccess(authResult.user));
      },
    );
  }

  // ──────────────────────────────────────────────────────────────
  // App Started → Check if user is already logged in
  // ──────────────────────────────────────────────────────────────
  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit( AuthLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        return emit( AuthUnauthenticated());
      }

      // If we have a token, try to fetch the full profile
      final user = await getUserUseCase(token: token);
      emit(AuthAuthenticated(user));
    } on Failure catch (f) {
      // If fetching profile fails (e.g., token expired), clear session
      await _clearToken();
      emit(AuthFailure(f.message));
      emit( AuthUnauthenticated());
    } catch (e) {
      await _clearToken();
      emit( AuthFailure('Session expired. Please login again.'));
      emit( AuthUnauthenticated());
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Login Requested
  // ──────────────────────────────────────────────────────────────
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit( AuthLoading());

    try {
      // FIX: Use case now returns AuthResult
      final authResult = await loginUseCase(
        email: event.email.trim(),
        password: event.password,
      );

      // FIX: Save the accessToken from AuthResult
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', authResult.accessToken);

      // Emit success with the User entity
      emit(AuthAuthenticated(authResult.user));
    } on Failure catch (f) {
      emit(AuthFailure(f.message));
    } catch (e) {
      emit( AuthFailure('Login failed. Please try again.'));
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Logout Requested
  // ──────────────────────────────────────────────────────────────
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit( AuthLoading());

    try {
      await logoutUseCase(token: event.token);
    } catch (_) {
      // Ignore logout errors — we want to log out anyway
    } finally {
      await _clearToken();
      emit( AuthUnauthenticated());
    }
  }
  

  // ──────────────────────────────────────────────────────────────
  // Helper: Clear saved token (Uses SharedPreferences as per original code)
  // ──────────────────────────────────────────────────────────────
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}