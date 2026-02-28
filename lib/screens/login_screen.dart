import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../widgets/app_text_field.dart';
import 'tutorial_screen.dart';
import 'home_feed_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  /// Facebook brand blue per design
  static const Color _facebookBlue = Color(0xFF1877F2);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu tối thiểu 6 ký tự';
    }
    return null;
  }

  /// Đi vào app: hiện Tutorial rồi chuyển sang Home Feed (dùng cho Login và Bỏ qua).
  Future<void> _goToHomeAfterTutorial() async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => const TutorialScreen(),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeFeedScreen()),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    await _goToHomeAfterTutorial();
  }

  /// Chế độ ẩn danh: vào news feed như bình thường (không đăng nhập).
  void _handleSkip() {
    _goToHomeAfterTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryOrange,
      body: Column(
        children: [
          // ─── Orange header (logo + Foonfood + tagline) ───────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppTheme.spacing2xl,
                left: AppTheme.spacingLg,
                right: AppTheme.spacingLg,
                bottom: AppTheme.spacing3xl,
              ),
              child: Column(
                children: [
                  // Logo: white square, rounded, hamburger icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.menu_rounded,
                      size: 36,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  Text(
                    'Foonfood',
                    style: AppTheme.heading1.copyWith(
                      color: AppTheme.white,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    'Khám phá Ẩm thực qua Video',
                    style: AppTheme.body.copyWith(
                      color: AppTheme.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── White card (form) ───────────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusXl),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingLg,
                  AppTheme.spacing2xl,
                  AppTheme.spacingLg,
                  AppTheme.spacing3xl,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Chào mừng trở lại!
                      Text(
                        'Chào mừng trở lại!',
                        textAlign: TextAlign.center,
                        style: AppTheme.heading3.copyWith(
                          color: AppTheme.gray900,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing2xl),

                      // Continue with Facebook (blue)
                      _SocialButton(
                        label: 'Continue with Facebook',
                        backgroundColor: _facebookBlue,
                        textColor: AppTheme.white,
                        icon: const Icon(
                          Icons.facebook_rounded,
                          size: 24,
                          color: AppTheme.white,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppTheme.spacingMd),

                      // Continue with Google (white, border)
                      SecondaryButton(
                        label: 'Continue with Google',
                        onPressed: () {},
                        icon: Icon(
                          Icons.mail_outline,
                          size: 22,
                          color: AppTheme.gray900,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing2xl),

                      // or
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppTheme.gray200),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                            ),
                            child: Text(
                              'or',
                              style: AppTheme.body.copyWith(
                                color: AppTheme.gray400,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppTheme.gray200),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing2xl),

                      // Email
                      AppTextField(
                        controller: _emailController,
                        placeholder: 'Email',
                        leadingIcon: Icon(
                          Icons.mail_outline,
                          size: 22,
                          color: AppTheme.gray400,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                        autofillHints: const [AutofillHints.email],
                      ),
                      const SizedBox(height: AppTheme.spacingLg),

                      // Password
                      AppTextField(
                        controller: _passwordController,
                        placeholder: 'Password',
                        leadingIcon: Icon(
                          Icons.lock_outline,
                          size: 22,
                          color: AppTheme.gray400,
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: _validatePassword,
                        autofillHints: const [AutofillHints.password],
                      ),
                      const SizedBox(height: AppTheme.spacing2xl),

                      // Login button
                      PrimaryButton(
                        label: 'Login',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: AppTheme.spacingLg),

                      // Create account
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Create account',
                            style: AppTheme.body.copyWith(
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing2xl),

                      // Skip separator
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppTheme.gray200),
                          ),
                          GestureDetector(
                            onTap: _handleSkip,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingMd,
                              ),
                              child: Text(
                                'Tạm thời bỏ qua →',
                                style: AppTheme.body.copyWith(
                                  color: AppTheme.gray400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppTheme.gray200),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      GestureDetector(
                        onTap: _handleSkip,
                        child: Center(
                          child: Text(
                            'Khám phá ngay mà không cần đăng nhập',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.gray400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width social button with custom background (e.g. Facebook blue).
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                label,
                style: AppTheme.buttonText.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
