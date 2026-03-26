import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/constants/firestore_constants.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Current User Stream ──
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Current Firebase User ──
  User? get currentUser => _auth.currentUser;

  // ── Register ──
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required DateTime birthday,
    String? phone,
    String? department,
    String? level,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      // Update display name
      await user.updateDisplayName(name);

      // Create user document in Firestore
      final userModel = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        birthday: birthday,
        phone: phone,
        department: department,
        level: level,
        createdAt: DateTime.now(),
        formFilled: false,
        duesPaid: false,
        badgeStatus: BadgeStatus.none,
        role: UserRole.user,
      );

      await _firestore
          .collection(FirestoreConstants.users)
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Login ──
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      final userDoc = await _firestore
          .collection(FirestoreConstants.users)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User profile not found. Please contact admin.');
      }

      return UserModel.fromMap(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Logout ──
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ── Get User Profile ──
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore
        .collection(FirestoreConstants.users)
        .doc(uid)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // ── Watch User Profile (realtime) ──
  Stream<UserModel?> watchUserProfile(String uid) {
    return _firestore
        .collection(FirestoreConstants.users)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!);
    });
  }

  // ── Submit Fellowship Form ──
  Future<void> submitFellowshipForm({
    required String uid,
    required List<String> forumIds,
    String? phone,
    String? department,
    String? level,
    String? bio,
  }) async {
    await _firestore
        .collection(FirestoreConstants.users)
        .doc(uid)
        .update({
      FirestoreConstants.formFilled: true,
      FirestoreConstants.badgeStatus: FirestoreConstants.badgeGrey,
      FirestoreConstants.forumIds: forumIds,
      if (phone != null) FirestoreConstants.phone: phone,
      if (department != null) FirestoreConstants.department: department,
      if (level != null) FirestoreConstants.level: level,
      if (bio != null) FirestoreConstants.bio: bio,
    });

    // Add user to each selected forum's members subcollection
    for (final forumId in forumIds) {
      await _firestore
          .collection(FirestoreConstants.forums)
          .doc(forumId)
          .collection(FirestoreConstants.members)
          .doc(uid)
          .set({
        'joinedAt': FieldValue.serverTimestamp(),
        'uid': uid,
      });

      // Increment member count
      await _firestore
          .collection(FirestoreConstants.forums)
          .doc(forumId)
          .update({
        FirestoreConstants.forumMemberCount: FieldValue.increment(1),
      });
    }
  }

  // ── Update FCM Token ──
  Future<void> updateFcmToken(String uid, String token) async {
    await _firestore
        .collection(FirestoreConstants.users)
        .doc(uid)
        .update({FirestoreConstants.fcmToken: token});
  }

  // ── Reset Password ──
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Check if form filled ──
  Future<bool> isFormFilled(String uid) async {
    final doc = await _firestore
        .collection(FirestoreConstants.users)
        .doc(uid)
        .get();
    if (!doc.exists) return false;
    return doc.data()?[FirestoreConstants.formFilled] ?? false;
  }

  // ── Error Handler ──
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled. Contact admin.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }
}