import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/auth/bloc/auth_bloc.dart';

class ASFFutoApp extends StatelessWidget {
  const ASFFutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: Builder(
        builder: (context) => BlocProvider(
          create: (context) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
          ),
          child: MaterialApp.router(
            title: 'ASF FUTO',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.dark,
            routerConfig: AppRouter.router,
          ),
        ),
      ),
    );
  }
}