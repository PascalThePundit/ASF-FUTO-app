import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  DateTime? _selectedBirthday;
  String? _selectedLevel;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<String> _levels = [
    '100 Level', '200 Level', '300 Level', '400 Level',
    '500 Level', '600 Level', 'Postgraduate',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.gold,
            surface: AppColors.surfaceElevated,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedBirthday = picked);
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      if (_selectedBirthday == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your birthday')),
        );
        return;
      }
      context.read<AuthBloc>().add(AuthRegisterRequested(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            birthday: _selectedBirthday!,
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            department: _departmentController.text.trim().isEmpty ? null : _departmentController.text.trim(),
            level: _selectedLevel,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegistrationSuccess) context.go(AppRoutes.fellowshipForm);
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // ── Background glow ──
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.primary.withOpacity(0.4),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.gold.withOpacity(0.1),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    // ── App Bar ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          _GlassIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onPressed: () => context.pop(),
                          ),
                        ],
                      ),
                    ),

                    // ── Scrollable form ──
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [AppColors.white, AppColors.gold],
                                ).createShader(bounds),
                                child: const Text(
                                  'Join ASF\nFUTO 🙌',
                                  style: TextStyle(
                                    fontFamily: 'Gabarito',
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Create your fellowship account',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 14,
                                    color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 36),

                              _buildLabel('Full Name'),
                              const SizedBox(height: 10),
                              _buildField(
                                controller: _nameController,
                                hint: 'John Doe',
                                icon: Icons.person_outline,
                                action: TextInputAction.next,
                                caps: TextCapitalization.words,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Enter your name'
                                    : null,
                              ),
                              const SizedBox(height: 18),

                              _buildLabel('Email'),
                              const SizedBox(height: 10),
                              _buildField(
                                controller: _emailController,
                                hint: 'your@email.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                action: TextInputAction.next,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Enter your email';
                                  if (!v.contains('@')) return 'Enter a valid email';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              _buildLabel('Phone (optional)'),
                              const SizedBox(height: 10),
                              _buildField(
                                controller: _phoneController,
                                hint: '08012345678',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                action: TextInputAction.next,
                              ),
                              const SizedBox(height: 18),

                              _buildLabel('Department (optional)'),
                              const SizedBox(height: 10),
                              _buildField(
                                controller: _departmentController,
                                hint: 'e.g. Computer Science',
                                icon: Icons.school_outlined,
                                action: TextInputAction.next,
                                caps: TextCapitalization.words,
                              ),
                              const SizedBox(height: 18),

                              _buildLabel('Level (optional)'),
                              const SizedBox(height: 10),
                              _buildDropdown(),
                              const SizedBox(height: 18),

                              _buildLabel('Birthday'),
                              const SizedBox(height: 10),
                              _buildBirthdayPicker(),
                              const SizedBox(height: 18),

                              _buildLabel('Password'),
                              const SizedBox(height: 10),
                              _buildPasswordField(
                                controller: _passwordController,
                                hint: 'Min. 6 characters',
                                obscure: _obscurePassword,
                                onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                                action: TextInputAction.next,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Enter a password';
                                  if (v.length < 6) return 'Min. 6 characters';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              _buildLabel('Confirm Password'),
                              const SizedBox(height: 10),
                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                hint: 'Repeat your password',
                                obscure: _obscureConfirm,
                                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                action: TextInputAction.done,
                                onSubmit: (_) => _onRegister(),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Confirm your password';
                                  if (v != _passwordController.text) return 'Passwords do not match';
                                  return null;
                                },
                              ),

                              const SizedBox(height: 36),

                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;
                                  return _GoldButton(
                                    onPressed: isLoading ? null : _onRegister,
                                    isLoading: isLoading,
                                    label: 'Create Account',
                                  );
                                },
                              ),

                              const SizedBox(height: 20),

                              Center(
                                child: GestureDetector(
                                  onTap: () => context.pop(),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: AppColors.textSecondary,
                                          fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Sign In',
                                          style: TextStyle(
                                            color: AppColors.gold,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction action = TextInputAction.next,
    TextCapitalization caps = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: action,
      textCapitalization: caps,
      style: const TextStyle(fontFamily: 'DMSans', color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    TextInputAction action = TextInputAction.next,
    void Function(String)? onSubmit,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      textInputAction: action,
      onFieldSubmitted: onSubmit,
      style: const TextStyle(fontFamily: 'DMSans', color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
          onPressed: onToggle,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.glassBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLevel,
          isExpanded: true,
          dropdownColor: AppColors.surfaceElevated,
          style: const TextStyle(fontFamily: 'DMSans', color: AppColors.textPrimary, fontSize: 15),
          hint: const Text('Select your level',
              style: TextStyle(fontFamily: 'DMSans', color: AppColors.textHint, fontSize: 15)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
          onChanged: (v) => setState(() => _selectedLevel = v),
        ),
      ),
    );
  }

  Widget _buildBirthdayPicker() {
    return GestureDetector(
      onTap: _pickBirthday,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.cake_outlined, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(
              _selectedBirthday != null
                  ? DateFormat('MMMM dd, yyyy').format(_selectedBirthday!)
                  : 'Select your birthday',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 15,
                color: _selectedBirthday != null ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _GlassIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.glassWhite,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 18),
      ),
    );
  }
}

class _GoldButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const _GoldButton({required this.onPressed, required this.label, this.isLoading = false});

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
          boxShadow: onPressed == null ? [] : [
            BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 6)),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.background))
              : Text(label,
                  style: const TextStyle(
                    fontFamily: 'DMSans', fontSize: 16, fontWeight: FontWeight.w700,
                    color: AppColors.background, letterSpacing: 0.3,
                  )),
        ),
      ),
    );
  }
}