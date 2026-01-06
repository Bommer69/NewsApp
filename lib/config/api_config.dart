/// Cấu hình API cho kết nối backend
class ApiConfig {
  // Thay đổi địa chỉ này tùy theo môi trường:
  // - Local development: http://localhost:3000
  // - Android Emulator: http://10.0.2.2:3000
  // - iOS Simulator: http://localhost:3000
  // - Thiết bị thật: http://YOUR_COMPUTER_IP:3000 (ví dụ: http://192.168.1.100:3000)
  static const String baseUrl = 'http://localhost:3000';
  
  // API Endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String meEndpoint = '/api/auth/me';
  static const String healthEndpoint = '/api/health';
  
  // Timeout cho các request (giây)
  static const int requestTimeout = 15;
}

