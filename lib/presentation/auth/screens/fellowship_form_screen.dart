import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/widgets/forum_selector_widget.dart';

class FellowshipFormScreen extends StatefulWidget {
  const FellowshipFormScreen({super.key});

  @override
  State<FellowshipFormScreen> createState() => _FellowshipFormScreenState();
}

class _FellowshipFormScreenState extends State<FellowshipFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  String? _selectedLevel;
  List<String> _selectedForumIds = [];
  int _currentStep = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<String> _levels = [
    '100 Level', '200 Level', '300 Level',
    '400 Level', '500 Level', '600 Level', 'Postgraduate',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate forum selection
      if (_selectedForumIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one forum to join'),
          ),
        );
        return;
      }
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _animController.reset();
      _animController.forward();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _animController.reset();
      _animController.forward();
    }
  }

  void _onSubmit() {
    final authState = context.read<AuthBloc>().state;
    String? uid;

    if (authState is AuthNeedsForm) {
      uid = authState.user.uid;
    } else if (authState is AuthRegistrationSuccess) {
      uid = authState.user.uid;
    }

    if (uid == null) return;

    context.read<AuthBloc>().add(
          AuthFellowshipFormSubmitted(
            uid: uid,
            forumIds: _selectedForumIds,
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            department: _departmentController.text.trim().isEmpty
                ? null
                : _departmentController.text.trim(),
            level: _selectedLevel,
            bio: _bioController.text.trim().isEmpty
                ? null
                : _bioController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFormSubmitted || state is AuthAuthenticated) {
          context.go(AppRoutes.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top Header ──
              _buildHeader(),

              // ── Progress Bar ──
              _buildProgressBar(),

              // ── Step Content ──
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: _buildCurrentStep(),
                    ),
                  ),
                ),
              ),

              // ── Bottom Buttons ──
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    final titles = [
      'Join Your Forums 🏛️',
      'About You 📝',
      'Almost There! 🎉',
    ];
    final subtitles = [
      'Select the forums you belong to in ASF FUTO',
      'Tell us a little more about yourself',
      'Review and submit your fellowship form',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Step ${_currentStep + 1} of 3',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              // ASF logo small
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('✝',
                      style: TextStyle(fontSize: 18, color: AppColors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(titles[_currentStep], style: AppTypography.displaySmall),
          const SizedBox(height: 6),
          Text(
            subtitles[_currentStep],
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Progress Bar ──
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 5,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.divider,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Current Step Builder ──
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Forums();
      case 1:
        return _buildStep2About();
      case 2:
        return _buildStep3Review();
      default:
        return const SizedBox();
    }
  }

  // ── Step 1: Forum Selection ──
  Widget _buildStep1Forums() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.15),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'You can join multiple forums. Your forum tag will show on your profile.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ForumSelectorWidget(
          selectedForumIds: _selectedForumIds,
          onSelectionChanged: (ids) {
            setState(() => _selectedForumIds = ids);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Step 2: About You ──
  Widget _buildStep2About() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        _buildLabel('Phone Number (optional)'),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          style: AppTypography.bodyLarge,
          decoration: const InputDecoration(
            hintText: '08012345678',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Department (optional)'),
        TextFormField(
          controller: _departmentController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: AppTypography.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'e.g. Computer Science',
            prefixIcon: Icon(Icons.school_outlined),
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Level (optional)'),
        DropdownButtonFormField<String>(
          value: _selectedLevel,
          style: AppTypography.bodyLarge,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.layers_outlined),
          ),
          hint: Text('Select your level',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textHint)),
          items: _levels
              .map((l) => DropdownMenuItem(value: l, child: Text(l)))
              .toList(),
          onChanged: (v) => setState(() => _selectedLevel = v),
        ),
        const SizedBox(height: 16),

        _buildLabel('Bio (optional)'),
        TextFormField(
          controller: _bioController,
          maxLines: 3,
          maxLength: 150,
          textCapitalization: TextCapitalization.sentences,
          style: AppTypography.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'Tell the fellowship a little about yourself...',
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: Icon(Icons.edit_outlined),
            ),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Step 3: Review ──
  Widget _buildStep3Review() {
    final authState = context.read<AuthBloc>().state;
    String userName = '';
    String userEmail = '';

    if (authState is AuthNeedsForm) {
      userName = authState.user.name;
      userEmail = authState.user.email;
    } else if (authState is AuthRegistrationSuccess) {
      userName = authState.user.name;
      userEmail = authState.user.email;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Summary card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReviewRow('Name', userName),
              _buildReviewDivider(),
              _buildReviewRow('Email', userEmail),
              if (_phoneController.text.isNotEmpty) ...[
                _buildReviewDivider(),
                _buildReviewRow('Phone', _phoneController.text),
              ],
              if (_departmentController.text.isNotEmpty) ...[
                _buildReviewDivider(),
                _buildReviewRow('Department', _departmentController.text),
              ],
              if (_selectedLevel != null) ...[
                _buildReviewDivider(),
                _buildReviewRow('Level', _selectedLevel!),
              ],
              _buildReviewDivider(),
              _buildReviewRow(
                'Forums',
                _selectedForumIds.isEmpty
                    ? 'None selected'
                    : '${_selectedForumIds.length} forum(s) selected',
              ),
              if (_bioController.text.isNotEmpty) ...[
                _buildReviewDivider(),
                _buildReviewRow('Bio', _bioController.text),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Badge info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.goldLight.withOpacity(0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Text('🏅', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You\'ll get a Grey Tick ✓',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                        )),
                    const SizedBox(height: 4),
                    Text(
                      'Pay your fellowship dues to unlock the Gold Tick 🌕',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Terms note
        Text(
          'By submitting this form, you confirm that you are a student at FUTO and a member of the Seventh-day Adventist church.',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textHint,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: AppTypography.labelMedium),
          ),
          Expanded(
            child: Text(value, style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewDivider() =>
      const Divider(height: 1, color: AppColors.divider);

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTypography.labelLarge),
    );
  }

  // ── Bottom Buttons ──
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 54),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : (_currentStep < 2 ? _nextStep : _onSubmit),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.white,
                          ),
                        )
                      : Text(_currentStep < 2 ? 'Continue' : 'Submit Form'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}