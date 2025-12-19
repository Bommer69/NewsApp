import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../widgets/liquid_background.dart';
import '../../widgets/glass_container.dart';
import '../../services/auth_service.dart';
import '../../services/preferences_service.dart';

/// Màn hình hồ sơ và cài đặt
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Profile card
                    _buildProfileCard(),
                    const SizedBox(height: 24),
                    
                    // Account section  
                    Consumer2<AuthService, PreferencesService>(
                      builder: (context, authService, prefsService, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    _buildMenuItem(
                      icon: Icons.security,
                      iconColor: AppColors.primary,
                      title: 'Bảo mật tài khoản',
                      onTap: () {
                        _showSecurityDialog();
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.bookmark,
                      iconColor: const Color(0xFFA855F7),
                      title: 'Tin đã lưu',
                      onTap: () {
                        // Navigate to bookmarks tab
                        Navigator.pop(context);
                        // TODO: Switch to bookmarks tab (index 2)
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Interface section
                    _buildSectionTitle('GIAO DIỆN & TRẢI NGHIỆM'),
                    const SizedBox(height: 12),
                    // Dark mode toggle removed - app uses Glass Liquid design (dark only)
                    _buildMenuItem(
                      icon: Icons.dark_mode,
                      iconColor: const Color(0xFFEAB308),
                      title: 'Giao diện',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.nights_stay, size: 14, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text(
                              'Dark',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('App sử dụng Glass Liquid design (Dark theme)'),
                            backgroundColor: AppColors.primary,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSwitchMenuItem(
                      icon: Icons.notifications,
                      iconColor: const Color(0xFFEF4444),
                      title: 'Thông báo',
                      subtitle: 'Tin nóng, cập nhật mới',
                      value: prefsService.notificationsEnabled,
                      onChanged: (value) {
                        prefsService.setNotifications(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.text_fields,
                      iconColor: const Color(0xFF10B981),
                      title: 'Cỡ chữ',
                      trailing: Text(
                        _getFontSizeLabel(prefsService.fontSize),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        _showFontSizeDialog(prefsService);
                      },
                    ),
                          ],
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Support section
                    _buildSectionTitle('HỖ TRỢ'),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.help,
                      iconColor: const Color(0xFF3B82F6),
                      title: 'Trung tâm trợ giúp',
                      onTap: () {
                        _showHelpDialog();
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.policy,
                      iconColor: const Color(0xFFF97316),
                      title: 'Chính sách bảo mật',
                      onTap: () {
                        _showPrivacyDialog();
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Logout button
                    _buildLogoutButton(),
                    
                    // Version info
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'NewsApp v${AppConstants.appVersion} (Build ${AppConstants.buildNumber})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 0,
      child: Row(
        children: [
          GlassButton(
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.white),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Cài đặt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 50), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Avatar with edit button
              Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (authService.userName ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showEditAvatarDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.backgroundDark,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // User info
              Text(
                authService.userName ?? 'Người dùng',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                authService.userEmail ?? 'email@example.com',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              
              // Premium button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showEditProfileDialog(authService);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    elevation: 8,
                    shadowColor: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  child: const Text(
                    'Chỉnh sửa hồ sơ',
                    style: TextStyle(
                      inherit: true,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          trailing ?? const Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return null;
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary.withValues(alpha: 0.5);
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 14),
      borderColor: AppColors.error.withOpacity(0.3),
      backgroundColor: AppColors.error.withOpacity(0.1),
      onTap: () {
        _showLogoutDialog();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.logout,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Đăng xuất',
            style: TextStyle(
              color: AppColors.error,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất?',
          style: TextStyle(color: AppColors.textTertiary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final authService = Provider.of<AuthService>(context, listen: false);
              await authService.logout();
              
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            child: Text(
              'Đăng xuất',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _getFontSizeLabel(String size) {
    switch (size) {
      case 'small':
        return 'Nhỏ';
      case 'large':
        return 'Lớn';
      default:
        return 'Vừa';
    }
  }

  void _showFontSizeDialog(PreferencesService prefsService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Chọn cỡ chữ',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFontSizeOption('Nhỏ', 'small', prefsService),
            _buildFontSizeOption('Vừa', 'medium', prefsService),
            _buildFontSizeOption('Lớn', 'large', prefsService),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeOption(String label, String value, PreferencesService prefsService) {
    final isSelected = prefsService.fontSize == value;
    return RadioListTile<String>(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : Colors.white,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      value: value,
      groupValue: prefsService.fontSize,
      activeColor: AppColors.primary,
      onChanged: (val) {
        if (val != null) {
          prefsService.setFontSize(val);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Bảo mật tài khoản',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Các tùy chọn bảo mật:',
              style: TextStyle(color: AppColors.textTertiary),
            ),
            SizedBox(height: 16),
            Text('• Đổi mật khẩu', style: TextStyle(color: Colors.white)),
            SizedBox(height: 8),
            Text('• Xác thực 2 bước', style: TextStyle(color: Colors.white)),
            SizedBox(height: 8),
            Text('• Thiết bị đã đăng nhập', style: TextStyle(color: Colors.white)),
            SizedBox(height: 8),
            Text('• Lịch sử hoạt động', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Trung tâm trợ giúp',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cần hỗ trợ? Liên hệ chúng tôi:',
              style: TextStyle(color: AppColors.textTertiary),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('support@tintucapp.com', style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('1900 xxxx', style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('8:00 - 22:00 hàng ngày', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Chính sách bảo mật',
          style: TextStyle(color: Colors.white),
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TinTucApp cam kết bảo vệ quyền riêng tư của bạn:',
                style: TextStyle(color: AppColors.textTertiary),
              ),
              SizedBox(height: 16),
              Text(
                '1. Thu thập thông tin',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Chúng tôi chỉ thu thập thông tin cần thiết để cung cấp dịch vụ.',
                style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
              ),
              SizedBox(height: 12),
              Text(
                '2. Sử dụng thông tin',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Thông tin được sử dụng để cải thiện trải nghiệm người dùng.',
                style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
              ),
              SizedBox(height: 12),
              Text(
                '3. Bảo mật dữ liệu',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Dữ liệu được mã hóa và bảo vệ an toàn.',
                style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showEditAvatarDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Thay đổi ảnh đại diện',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: AppColors.primary),
              title: const Text('Chụp ảnh', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng đang phát triển'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Chọn từ thư viện', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng đang phát triển'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(AuthService authService) {
    final nameController = TextEditingController(text: authService.userName);
    final emailController = TextEditingController(text: authService.userEmail);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                labelStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.glassBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.glassBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
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
              // TODO: Update user profile in backend
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cập nhật thành công'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}

