import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthFellowshipFormSubmitted>(_onFellowshipFormSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthUserUpdated>(_onUserUpdated);
  }

  // ── Watch Firebase auth state ──
  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    await emit.onEach<User?>(
      _authRepository.authStateChanges,
      onData: (user) async {
        if (user == null) {
          emit(const AuthUnauthenticated());
        } else {
          final userModel = await _authRepository.getUserProfile(user.uid);
          if (userModel == null) {
            emit(const AuthUnauthenticated());
            return;
          }
          if (!userModel.formFilled) {
            emit(AuthNeedsForm(user: userModel));
          } else {
            emit(AuthAuthenticated(user: userModel));
          }
        }
      },
      onError: (error, stackTrace) {
        emit(AuthError(message: error.toString()));
      },
    );
  }

  // ── Login ──
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      if (!user.formFilled) {
        emit(AuthNeedsForm(user: user));
      } else {
        emit(AuthAuthenticated(user: user));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // ── Register ──
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
        birthday: event.birthday,
        phone: event.phone,
        department: event.department,
        level: event.level,
      );
      emit(AuthRegistrationSuccess(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // ── Fellowship Form ──
  Future<void> _onFellowshipFormSubmitted(
    AuthFellowshipFormSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.submitFellowshipForm(
        uid: event.uid,
        forumIds: event.forumIds,
        phone: event.phone,
        department: event.department,
        level: event.level,
        bio: event.bio,
      );
      final updatedUser = await _authRepository.getUserProfile(event.uid);
      if (updatedUser != null) {
        emit(AuthFormSubmitted(user: updatedUser));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // ── Logout ──
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // ── Password Reset ──
  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.resetPassword(event.email);
      emit(const AuthPasswordResetSent());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // ── User Updated ──
  Future<void> _onUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getUserProfile(event.uid);
      if (user == null) {
        emit(const AuthUnauthenticated());
        return;
      }
      if (!user.formFilled) {
        emit(AuthNeedsForm(user: user));
      } else {
        emit(AuthAuthenticated(user: user));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}