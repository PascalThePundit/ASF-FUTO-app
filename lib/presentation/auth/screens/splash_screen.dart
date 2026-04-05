import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<double> _glowAnim;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _ringScale;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );
    _ringScale = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _bgController.repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 200), () {
      _logoController.forward().then((_) {
        _textController.forward();
      });
    });

    context.read<AuthBloc>().add(const AuthStarted());
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.home);
        } else if (state is AuthNeedsForm) {
          context.go(AppRoutes.fellowshipForm);
        } else if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedBuilder(
          animation: Listenable.merge([_bgController, _logoController, _textController]),
          builder: (context, _) {
            return Stack(
              children: [
                // ── Animated background glow ──
                Positioned(
                  top: -100,
                  left: -100,
                  child: Transform.scale(
                    scale: _ringScale.value,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.4 * _glowAnim.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -150,
                  right: -100,
                  child: Transform.scale(
                    scale: _ringScale.value * 0.8,
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.gold.withOpacity(0.15 * _glowAnim.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Center Content ──
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Logo ──
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer glow ring
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.gold.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                              // Inner ring
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.gold.withOpacity(0.6),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              // Logo container
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.surfaceElevated,
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppColors.gold,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold.withOpacity(0.3),
                                      blurRadius: 24,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    '✝',
                                    style: TextStyle(
                                      fontSize: 42,
                                      color: AppColors.gold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Text ──
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    AppColors.white,
                                    AppColors.gold,
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  'ASF FUTO',
                                  style: TextStyle(
                                    fontFamily: 'Gabarito',
                                    fontSize: 38,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Adventist Student Fellowship',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: AppColors.gold.withOpacity(0.4),
                                  ),
                                  color: AppColors.gold.withOpacity(0.08),
                                ),
                                child: const Text(
                                  'FUTO CHAPTER',
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),

                      // ── Loading dots ──
                      FadeTransition(
                        opacity: _textFade,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (i) {
                            return AnimatedBuilder(
                              animation: _bgController,
                              builder: (_, __) {
                                final delay = i * 0.2;
                                final t = (_bgController.value - delay).clamp(0.0, 1.0);
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.gold.withOpacity(0.3 + 0.7 * t),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}