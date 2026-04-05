import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  void _onForgotPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email first')),
      );
      return;
    }
    context.read<AuthBloc>().add(AuthPasswordResetRequested(email: email));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) context.go(AppRoutes.home);
        if (state is AuthNeedsForm) context.go(AppRoutes.fellowshipForm);
        if (state is AuthPasswordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent!')),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // ── Background glows ──
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gold.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Content ──
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.08),

                          // ── Logo mark ──
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.surfaceElevated],
                              ),
                              border: Border.all(color: AppColors.gold, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold.withOpacity(0.25),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text('✝',
                                  style: TextStyle(fontSize: 26, color: AppColors.gold)),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Title ──
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [AppColors.white, AppColors.gold],
                            ).createShader(bounds),
                            child: const Text(
                              'Welcome\nBack 👋',
                              style: TextStyle(
                                fontFamily: 'Gabarito',
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Sign in to your ASF FUTO account',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 44),

                          // ── Email ──
                          _buildLabel('Email'),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                                fontFamily: 'DMSans',
                                color: AppColors.textPrimary,
                                fontSize: 15),
                            decoration: const InputDecoration(
                              hintText: 'your@email.com',
                              prefixIcon: Icon(Icons.email_outlined, size: 20),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Enter your email';
                              if (!v.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // ── Password ──
                          _buildLabel('Password'),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onLogin(),
                            style: const TextStyle(
                                fontFamily: 'DMSans',
                                color: AppColors.textPrimary,
                                fontSize: 15),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Enter your password' : null,
                          ),

                          // ── Forgot password ──
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _onForgotPassword,
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: AppColors.gold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ── Login Button ──
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return _GoldButton(
                                onPressed: isLoading ? null : _onLogin,
                                isLoading: isLoading,
                                label: 'Sign In',
                              );
                            },
                          ),

                          const SizedBox(height: 28),

                          // ── Divider ──
                          Row(
                            children: [
                              Expanded(
                                child: Container(height: 1, color: AppColors.divider),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('or',
                                    style: TextStyle(
                                        fontFamily: 'DMSans',
                                        color: AppColors.textHint,
                                        fontSize: 13)),
                              ),
                              Expanded(
                                child: Container(height: 1, color: AppColors.divider),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // ── Register Button ──
                          _GhostButton(
                            onPressed: () => context.push(AppRoutes.register),
                            label: 'Create an Account',
                          ),

                          const SizedBox(height: 40),

                          // ── Footer ──
                          Center(
                            child: Text(
                              'Rooted in Faith • Growing in Fellowship',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                color: AppColors.textHint,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ── Reusable Gold Button ──
class _GoldButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const _GoldButton({
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: onPressed == null
                ? [AppColors.gold.withOpacity(0.4), AppColors.goldDark.withOpacity(0.4)]
                : [AppColors.gold, AppColors.goldDark],
          ),
          boxShadow: onPressed == null
              ? []
              : [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.background,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.background,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}

// ── Reusable Ghost Button ──
class _GhostButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const _GhostButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.glassBorder, width: 1.5),
          color: AppColors.glassWhite,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}