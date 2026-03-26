import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_constants.dart';

enum BadgeStatus { none, grey, gold }

enum UserRole { user, admin, forumHead }

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final List<String> forumIds;
  final BadgeStatus badgeStatus;
  final bool isForumHead;
  final String? forumHeadOf;
  final DateTime? birthday;
  final bool formFilled;
  final bool duesPaid;
  final UserRole role;
  final String? fcmToken;
  final DateTime createdAt;
  final String? phone;
  final String? department;
  final String? level;
  final String? bio;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.forumIds = const [],
    this.badgeStatus = BadgeStatus.none,
    this.isForumHead = false,
    this.forumHeadOf,
    this.birthday,
    this.formFilled = false,
    this.duesPaid = false,
    this.role = UserRole.user,
    this.fcmToken,
    required this.createdAt,
    this.phone,
    this.department,
    this.level,
    this.bio,
  });

  // ── From Firestore ──
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map[FirestoreConstants.uid] ?? '',
      name: map[FirestoreConstants.name] ?? '',
      email: map[FirestoreConstants.email] ?? '',
      avatarUrl: map[FirestoreConstants.avatarUrl],
      forumIds: List<String>.from(map[FirestoreConstants.forumIds] ?? []),
      badgeStatus: _parseBadgeStatus(map[FirestoreConstants.badgeStatus]),
      isForumHead: map[FirestoreConstants.isForumHead] ?? false,
      forumHeadOf: map[FirestoreConstants.forumHeadOf],
      birthday: map[FirestoreConstants.birthday] != null
          ? (map[FirestoreConstants.birthday] as Timestamp).toDate()
          : null,
      formFilled: map[FirestoreConstants.formFilled] ?? false,
      duesPaid: map[FirestoreConstants.duesPaid] ?? false,
      role: _parseRole(map[FirestoreConstants.role]),
      fcmToken: map[FirestoreConstants.fcmToken],
      createdAt: map[FirestoreConstants.createdAt] != null
          ? (map[FirestoreConstants.createdAt] as Timestamp).toDate()
          : DateTime.now(),
      phone: map[FirestoreConstants.phone],
      department: map[FirestoreConstants.department],
      level: map[FirestoreConstants.level],
      bio: map[FirestoreConstants.bio],
    );
  }

  // ── To Firestore ──
  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.uid: uid,
      FirestoreConstants.name: name,
      FirestoreConstants.email: email,
      FirestoreConstants.avatarUrl: avatarUrl,
      FirestoreConstants.forumIds: forumIds,
      FirestoreConstants.badgeStatus: _badgeStatusToString(badgeStatus),
      FirestoreConstants.isForumHead: isForumHead,
      FirestoreConstants.forumHeadOf: forumHeadOf,
      FirestoreConstants.birthday:
          birthday != null ? Timestamp.fromDate(birthday!) : null,
      FirestoreConstants.formFilled: formFilled,
      FirestoreConstants.duesPaid: duesPaid,
      FirestoreConstants.role: _roleToString(role),
      FirestoreConstants.fcmToken: fcmToken,
      FirestoreConstants.createdAt: Timestamp.fromDate(createdAt),
      FirestoreConstants.phone: phone,
      FirestoreConstants.department: department,
      FirestoreConstants.level: level,
      FirestoreConstants.bio: bio,
    };
  }

  // ── Copy With ──
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatarUrl,
    List<String>? forumIds,
    BadgeStatus? badgeStatus,
    bool? isForumHead,
    String? forumHeadOf,
    DateTime? birthday,
    bool? formFilled,
    bool? duesPaid,
    UserRole? role,
    String? fcmToken,
    DateTime? createdAt,
    String? phone,
    String? department,
    String? level,
    String? bio,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      forumIds: forumIds ?? this.forumIds,
      badgeStatus: badgeStatus ?? this.badgeStatus,
      isForumHead: isForumHead ?? this.isForumHead,
      forumHeadOf: forumHeadOf ?? this.forumHeadOf,
      birthday: birthday ?? this.birthday,
      formFilled: formFilled ?? this.formFilled,
      duesPaid: duesPaid ?? this.duesPaid,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      level: level ?? this.level,
      bio: bio ?? this.bio,
    );
  }

  // ── Helpers ──
  bool get isBirthday {
    if (birthday == null) return false;
    final now = DateTime.now();
    return now.month == birthday!.month && now.day == birthday!.day;
  }

  bool get isAdmin => role == UserRole.admin;

  String get displayRole {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.forumHead:
        return 'Forum Head';
      case UserRole.user:
        return 'Member';
    }
  }

  String get badgeLabel {
    switch (badgeStatus) {
      case BadgeStatus.gold:
        return 'Verified Member';
      case BadgeStatus.grey:
        return 'Form Filled';
      case BadgeStatus.none:
        return 'Unverified';
    }
  }

  // ── Private Parsers ──
  static BadgeStatus _parseBadgeStatus(String? value) {
    switch (value) {
      case FirestoreConstants.badgeGold:
        return BadgeStatus.gold;
      case FirestoreConstants.badgeGrey:
        return BadgeStatus.grey;
      default:
        return BadgeStatus.none;
    }
  }

  static String _badgeStatusToString(BadgeStatus status) {
    switch (status) {
      case BadgeStatus.gold:
        return FirestoreConstants.badgeGold;
      case BadgeStatus.grey:
        return FirestoreConstants.badgeGrey;
      case BadgeStatus.none:
        return FirestoreConstants.badgeNone;
    }
  }

  static UserRole _parseRole(String? value) {
    switch (value) {
      case FirestoreConstants.roleAdmin:
        return UserRole.admin;
      case FirestoreConstants.roleForumHead:
        return UserRole.forumHead;
      default:
        return UserRole.user;
    }
  }

  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return FirestoreConstants.roleAdmin;
      case UserRole.forumHead:
        return FirestoreConstants.roleForumHead;
      case UserRole.user:
        return FirestoreConstants.roleUser;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserModel && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() => 'UserModel(uid: $uid, name: $name, email: $email)';
}