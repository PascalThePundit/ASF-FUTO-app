import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// ── Watch auth state changes from Firebase ──
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

// ── Login ──
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// ── Register ──
class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final DateTime birthday;
  final String? phone;
  final String? department;
  final String? level;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.birthday,
    this.phone,
    this.department,
    this.level,
  });

  @override
  List<Object?> get props => [name, email, password, birthday];
}

// ── Submit Fellowship Form ──
class AuthFellowshipFormSubmitted extends AuthEvent {
  final String uid;
  final List<String> forumIds;
  final String? phone;
  final String? department;
  final String? level;
  final String? bio;

  const AuthFellowshipFormSubmitted({
    required this.uid,
    required this.forumIds,
    this.phone,
    this.department,
    this.level,
    this.bio,
  });

  @override
  List<Object?> get props => [uid, forumIds];
}

// ── Logout ──
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

// ── Reset Password ──
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// ── User profile updated (from Firestore stream) ──
class AuthUserUpdated extends AuthEvent {
  final String uid;

  const AuthUserUpdated({required this.uid});

  @override
  List<Object?> get props => [uid];
}