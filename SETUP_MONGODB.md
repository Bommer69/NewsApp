# Hướng dẫn kết nối MongoDB với Flutter App

## Tổng quan

Ứng dụng Flutter không thể kết nối trực tiếp với MongoDB. Cần một Backend API (Node.js) để xử lý kết nối và authentication.

## Cấu trúc

```
app-tintuc/
├── backend/              # Backend API (Node.js + Express + MongoDB)
│   ├── server.js
│   ├── package.json
│   └── .env
└── lib/                  # Flutter app
    ├── config/
    │   └── api_config.dart
    └── services/
        └── auth_service.dart
```

## Bước 1: Cài đặt Backend

1. Mở terminal và di chuyển vào thư mục backend:
```bash
cd backend
```

2. Cài đặt dependencies:
```bash
npm install
```

3. Kiểm tra file `.env` đã có connection string MongoDB:
```
MONGODB_URI=mongodb+srv://vinhprop2004_db_user:5WYE8nakdPOdDpkB@cluster0.amkwdxh.mongodb.net/tintuc_db?retryWrites=true&w=majority
```

4. Chạy server:
```bash
npm start
```

Server sẽ chạy tại: `http://localhost:3000`

## Bước 2: Cấu hình Flutter App

1. Cài đặt dependencies:
```bash
flutter pub get
```

2. Cập nhật `lib/config/api_config.dart`:

### Nếu chạy trên Android Emulator:
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

### Nếu chạy trên iOS Simulator:
```dart
static const String baseUrl = 'http://localhost:3000';
```

### Nếu chạy trên thiết bị thật:
1. Tìm IP của máy tính:
   - Windows: `ipconfig` (tìm IPv4 Address)
   - Mac/Linux: `ifconfig` hoặc `ip addr`
2. Cập nhật:
```dart
static const String baseUrl = 'http://192.168.1.XXX:3000'; // Thay XXX bằng IP của bạn
```

**Lưu ý**: Đảm bảo máy tính và thiết bị cùng mạng WiFi.

## Bước 3: Test kết nối

1. Chạy backend server (bước 1)
2. Chạy Flutter app:
```bash
flutter run
```

3. Thử đăng ký tài khoản mới trong app
4. Kiểm tra console của backend để xem logs

## Troubleshooting

### Lỗi: "Connection refused" hoặc "Failed to connect"
- **Nguyên nhân**: Flutter app không thể kết nối đến backend
- **Giải pháp**:
  1. Kiểm tra backend đang chạy: mở `http://localhost:3000/api/health` trên browser
  2. Kiểm tra `baseUrl` trong `api_config.dart` đúng chưa
  3. Nếu dùng thiết bị thật, đảm bảo cùng mạng WiFi
  4. Tắt firewall tạm thời để test

### Lỗi: "MongoDB connection failed"
- **Nguyên nhân**: Không kết nối được MongoDB Atlas
- **Giải pháp**:
  1. Kiểm tra connection string trong `.env`
  2. Kiểm tra IP của bạn đã được whitelist trong MongoDB Atlas
  3. Kiểm tra network connection

### Lỗi: "Email đã được sử dụng"
- **Nguyên nhân**: Email đã tồn tại trong database
- **Giải pháp**: Dùng email khác hoặc đăng nhập với email đó

### Lỗi: "Mật khẩu phải có ít nhất 6 ký tự"
- **Nguyên nhân**: Mật khẩu quá ngắn
- **Giải pháp**: Nhập mật khẩu có ít nhất 6 ký tự

## API Endpoints

- `POST /api/auth/register` - Đăng ký
- `POST /api/auth/login` - Đăng nhập
- `GET /api/auth/me` - Lấy thông tin user (cần token)
- `GET /api/health` - Kiểm tra server

Xem chi tiết trong `backend/README.md`

## Bảo mật

⚠️ **QUAN TRỌNG**: 
- Không commit file `.env` lên Git
- Đổi JWT_SECRET trong production
- Sử dụng HTTPS trong production
- Validate input ở cả client và server

