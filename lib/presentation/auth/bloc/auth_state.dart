import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// ── Initial / checking auth ──
class AuthInitial extends AuthState {
  const AuthInitial();
}

// ── Loading ──
class AuthLoading extends AuthState {
  const AuthLoading();
}

// ── Authenticated — has user, form filled ──
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// ── Authenticated but fellowship form not filled yet ──
class AuthNeedsForm extends AuthState {
  final UserModel user;

  const AuthNeedsForm({required this.user});

  @override
  List<Object?> get props => [user];
}

// ── Unauthenticated ──
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// ── Registration success ──
class AuthRegistrationSuccess extends AuthState {
  final UserModel user;

  const AuthRegistrationSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

// ── Fellowship form submitted successfully ──
class AuthFormSubmitted extends AuthState {
  final UserModel user;

  const AuthFormSubmitted({required this.user});

  @override
  List<Object?> get props => [user];
}

// ── Password reset email sent ──
class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

// ── Error ──
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}