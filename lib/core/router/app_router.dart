import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../presentation/auth/screens/splash_screen.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/register_screen.dart';
import '../../presentation/auth/screens/fellowship_form_screen.dart';
import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/profile/screens/profile_screen.dart';
import '../../presentation/forums/screens/forums_list_screen.dart';
import '../../presentation/forums/screens/create_forum_screen.dart';
import '../../presentation/chat/screens/chat_list_screen.dart';
import '../../presentation/chat/screens/chat_room_screen.dart';
import '../../presentation/chat/screens/general_chat_screen.dart';
import '../../presentation/stories/screens/story_viewer_screen.dart';
import '../../presentation/stories/screens/story_create_screen.dart';
import '../../presentation/bible/screens/bible_home_screen.dart';
import '../../presentation/bible/screens/bible_reader_screen.dart';
import '../../presentation/bible/screens/bible_search_screen.dart';
import '../../presentation/hymnal/screens/hymnal_home_screen.dart';
import '../../presentation/hymnal/screens/hymn_detail_screen.dart';
import '../../presentation/hymnal/screens/call_to_worship_screen.dart';
import '../../presentation/notifications/screens/notifications_screen.dart';
import '../../presentation/admin/screens/admin_dashboard_screen.dart';
import '../../presentation/admin/screens/verify_user_screen.dart';
import '../../presentation/admin/screens/manage_forums_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String fellowshipForm = '/fellowship-form';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String userProfile = '/profile/:uid';
  static const String forums = '/forums';
  static const String createForum = '/forums/create';
  static const String chatList = '/chats';
  static const String chatRoom = '/chats/:roomId';
  static const String generalChat = '/chats/general';
  static const String storyViewer = '/stories/:storyId';
  static const String storyCreate = '/stories/create';
  static const String bible = '/bible';
  static const String bibleReader = '/bible/:book/:chapter';
  static const String bibleSearch = '/bible/search';
  static const String hymnal = '/hymnal';
  static const String hymnDetail = '/hymnal/:hymnId';
  static const String callToWorship = '/hymnal/call-to-worship';
  static const String notifications = '/notifications';
  static const String adminDashboard = '/admin';
  static const String verifyUser = '/admin/verify/:uid';
  static const String manageForums = '/admin/forums';
}

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isOnAuth = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;
      final isOnSplash = state.matchedLocation == AppRoutes.splash;

      // Let splash handle its own redirect
      if (isOnSplash) return null;

      // Not logged in → go to login
      if (user == null && !isOnAuth) return AppRoutes.login;

      // Logged in but on auth screen → go home
      if (user != null && isOnAuth) return AppRoutes.home;

      return null;
    },
    routes: [
      // ── Auth ──
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.fellowshipForm,
        builder: (context, state) => const FellowshipFormScreen(),
      ),

      // ── Main Shell ──
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // ── Profile ──
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.userProfile,
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return ProfileScreen(uid: uid);
        },
      ),

      // ── Forums ──
      GoRoute(
        path: AppRoutes.forums,
        builder: (context, state) => const ForumsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.createForum,
        builder: (context, state) => const CreateForumScreen(),
      ),

      // ── Chat ──
      GoRoute(
        path: AppRoutes.chatList,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: AppRoutes.generalChat,
        builder: (context, state) => const GeneralChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatRoom,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          final roomName = state.uri.queryParameters['name'] ?? 'Chat';
          return ChatRoomScreen(roomId: roomId, roomName: roomName);
        },
      ),

      // ── Stories ──
      GoRoute(
        path: AppRoutes.storyCreate,
        builder: (context, state) => const StoryCreateScreen(),
      ),
      GoRoute(
        path: AppRoutes.storyViewer,
        builder: (context, state) {
          final storyId = state.pathParameters['storyId']!;
          return StoryViewerScreen(storyId: storyId);
        },
      ),

      // ── Bible ──
      GoRoute(
        path: AppRoutes.bible,
        builder: (context, state) => const BibleHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.bibleSearch,
        builder: (context, state) => const BibleSearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.bibleReader,
        builder: (context, state) {
          final book = state.pathParameters['book']!;
          final chapter = int.parse(state.pathParameters['chapter']!);
          final version = state.uri.queryParameters['version'] ?? 'kjv';
          return BibleReaderScreen(book: book, chapter: chapter, version: version);
        },
      ),

      // ── Hymnal ──
      GoRoute(
        path: AppRoutes.hymnal,
        builder: (context, state) => const HymnalHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.callToWorship,
        builder: (context, state) => const CallToWorshipScreen(),
      ),
      GoRoute(
        path: AppRoutes.hymnDetail,
        builder: (context, state) {
          final hymnId = state.pathParameters['hymnId']!;
          return HymnDetailScreen(hymnId: hymnId);
        },
      ),

      // ── Notifications ──
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // ── Admin ──
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.manageForums,
        builder: (context, state) => const ManageForumsScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyUser,
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return VerifyUserScreen(uid: uid);
        },
      ),
    ],

    // ── Error Page ──
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}