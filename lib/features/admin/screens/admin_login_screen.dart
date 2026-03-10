import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/admin_auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final String? initialError;
  const LoginScreen({super.key, this.initialError});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isSignUp = false; // Toggle between login and signup
  bool _didShowInitialError = false;
  String? _lastShownError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final auth = context.read<ClientAuthProvider>();
    setState(() => _isLoading = true);
    await auth.signInWithEmailPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _isLoading = false);

    final err = auth.errorMessage;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleSignUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final auth = context.read<ClientAuthProvider>();
    setState(() => _isLoading = true);
    await auth.signUpWithEmailPassword(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _isLoading = false);

    final err = auth.errorMessage;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialError = widget.initialError;
    if (initialError != null && !_didShowInitialError) {
      _didShowInitialError = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(initialError),
            backgroundColor: AppColors.error,
          ),
        );
      });
    }

    // Listen for auth errors
    final auth = context.watch<ClientAuthProvider>();
    final authError = auth.errorMessage;
    if (authError != null && authError != _lastShownError && !_isLoading) {
      _lastShownError = authError;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authError),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo and Title together
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo3.png',
                      width: 120,
                      height: 100, // Reduced height to crop some whitespace
                      fit: BoxFit.contain,
                    ),
                    Transform.translate(
                      offset: const Offset(0, -15), // Pull text up closer to logo
                      child: const Text(
                        'Holobox',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              Center(
                child: Text(
                  _isSignUp ? 'Create your account' : 'Sign in to continue',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Name Field (only for signup)
              if (_isSignUp) ...[
                _buildInputField(
                  controller: _nameController,
                  label: 'Name',
                  hint: 'Enter your name',
                  icon: CupertinoIcons.person,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
              ],

              // Email Field
              _buildInputField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                icon: CupertinoIcons.mail,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // Password Field
              _buildPasswordField(),

              const SizedBox(height: 12),

              // Forgot Password (only for login)
              if (!_isSignUp)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please contact support for password reset'),
                          backgroundColor: AppColors.info,
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Login/Signup Button
              GestureDetector(
                onTap: _isLoading ? null : (_isSignUp ? _handleSignUp : _handleLogin),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryPurple, AppColors.lightBlue],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CupertinoActivityIndicator(color: AppColors.white)
                        : Text(
                            _isSignUp ? 'Sign Up' : 'Login',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Toggle between Login and Signup
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSignUp ? 'Already have an account? ' : "Don't have an account? ",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                          _emailController.clear();
                          _passwordController.clear();
                          _nameController.clear();
                        });
                      },
                      child: Text(
                        _isSignUp ? 'Login' : 'Sign Up',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                size: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryPurple,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                CupertinoIcons.lock,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryPurple,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Keep old name as alias for compatibility
typedef AdminLoginScreen = LoginScreen;
