import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/liquid_background.dart';
import '../../services/auth_service.dart';

/// Màn hình đăng nhập
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // For registration
  bool _obscurePassword = true;
  bool _isLogin = true; // true = login, false = register

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );

      bool success;
      if (_isLogin) {
        success = await authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        success = await authService.register(
          _emailController.text.trim(),
          _passwordController.text,
          fullName: _nameController.text.trim().isNotEmpty 
              ? _nameController.text.trim() 
              : null,
        );
      }

      if (mounted) {
        Navigator.pop(context); // Close loading
        
        if (success) {
          // Navigate to main screen
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isLogin ? 'Đăng nhập thất bại' : 'Đăng ký thất bại'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    final success = await authService.socialLogin(provider);

    if (mounted) {
      Navigator.pop(context); // Close loading
      
      if (success) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập với $provider thất bại'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlassButton(
                        onPressed: () => Navigator.pop(context),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Skip login
                          Navigator.pushReplacementNamed(context, '/main');
                        },
                        child: Text(
                          'Bỏ qua',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Headline
                  Text(
                    _isLogin ? 'Chào mừng\ntrở lại 👋' : 'Tạo tài khoản\nmới 🎉',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 36,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin
                        ? 'Đăng nhập để cập nhật những tin tức nóng hổi nhất.'
                        : 'Đăng ký để không bỏ lỡ tin tức quan trọng.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Segmented control (Login/Register tabs)
                  _buildSegmentedControl(),

                  const SizedBox(height: 32),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name input (only for register)
                        if (!_isLogin) ...[
                          _buildNameInput(),
                          const SizedBox(height: 20),
                        ],
                        
                        // Email input
                        _buildEmailInput(),
                        const SizedBox(height: 20),

                        // Password input
                        _buildPasswordInput(),
                        const SizedBox(height: 20),

                        // Confirm password (only for register)
                        if (!_isLogin) ...[
                          _buildConfirmPasswordInput(),
                          const SizedBox(height: 20),
                        ],

                        // Forgot password (only for login)
                        if (_isLogin)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                _showForgotPasswordDialog();
                              },
                              child: const Text('Quên mật khẩu?'),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit button
                  _buildSubmitButton(),

                  const SizedBox(height: 32),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.glassBorder,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Hoặc tiếp tục với',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.glassBorder,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Social login buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          'Google',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuB5XJvZd0vuhCrrhiRE-SZswSY2VGEuaVAeuKPa1XZKB0vBnAMlVoefnvWhO8uw2zET8-NWKH6WZIueMM5MuouuYzh6r6iuM1rU8nnvzCYKXh9jrldTSnY387ZlOVab31eQgWebiG_TGsrAR1TnGdISBs_dw6heVUpjVWXk-JSjtmRw8sYLUpzK1WO_ZH3vaPrMBV79RZcGEp8Dh1YWd0iyIWGVexTr5Z5rgYsvoWIRNwf8h8gAIKCBRmofnYYfnFio0qkc2RTLN7AS',
                          () => _handleSocialLogin('Google'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSocialButton(
                          'Facebook',
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDQbRvEQhpf4c0Mx2EhJ-uXWTfc6T53XIQvEFb2AywPM-VA_42hFaEQpQZTZKQMCjDzMvFiXg51tDSyWyT6gQb4yvpnskPJxrEp38kIapa8v1mxPqDqtlPeLdJo3IT_FL91-O_Z0l1iZwNCUiV3EdBSG01YZIZoIPq2IjCp88lBizPOBsze17oFmGnUucKKqNJv4Di59xeC_Gh8Q-JqrEukIgWMvojl9JYuaV-7FfqCCp677VcSrxZ6ry0YnysyP1ByXoD65Hs5kWHU',
                          () => _handleSocialLogin('Facebook'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return GlassContainer(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isLogin) _toggleAuthMode();
              },
              child: AnimatedContainer(
                duration: AppConstants.animationDuration,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isLogin ? AppColors.glassHover : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: _isLogin
                      ? Border.all(color: AppColors.glassBorder)
                      : null,
                ),
                child: Text(
                  'Đăng nhập',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isLogin ? Colors.white : AppColors.textMuted,
                    fontWeight: _isLogin ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_isLogin) _toggleAuthMode();
              },
              child: AnimatedContainer(
                duration: AppConstants.animationDuration,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isLogin ? AppColors.glassHover : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: !_isLogin
                      ? Border.all(color: AppColors.glassBorder)
                      : null,
                ),
                child: Text(
                  'Đăng ký',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isLogin ? Colors.white : AppColors.textMuted,
                    fontWeight: !_isLogin ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.person_outline,
              size: 20,
              color: AppColors.textMuted,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Họ và tên',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (!_isLogin && (value == null || value.trim().isEmpty)) {
                  return 'Vui lòng nhập họ tên';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInput() {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.mail_outline,
              size: 20,
              color: AppColors.textMuted,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Email hoặc Tên người dùng',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInput() {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.lock_outline,
              size: 20,
              color: AppColors.textMuted,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Mật khẩu',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải có ít nhất 6 ký tự';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: AppColors.textMuted,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmPasswordInput() {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.lock_outline,
              size: 20,
              color: AppColors.textMuted,
            ),
          ),
          Expanded(
            child: TextFormField(
              obscureText: _obscurePassword,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Xác nhận mật khẩu',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng xác nhận mật khẩu';
                }
                if (value != _passwordController.text) {
                  return 'Mật khẩu không khớp';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          elevation: 8,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLogin ? 'Đăng nhập' : 'Đăng ký',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String name, String iconUrl, VoidCallback onTap) {
    return GlassContainer(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            iconUrl,
            width: 20,
            height: 20,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.login, size: 20, color: Colors.white);
            },
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Quên mật khẩu',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nhập email của bạn để nhận liên kết đặt lại mật khẩu.',
              style: TextStyle(color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.glassBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Liên kết đặt lại mật khẩu đã được gửi đến email của bạn'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }
}

