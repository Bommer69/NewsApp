# TinTucApp - Ứng dụng Tin Tức Flutter

Ứng dụng đọc tin tức hiện đại với giao diện **Glass Liquid** đẹp mắt, được xây dựng bằng Flutter.

##  Tính năng

###  Trang chủ / Bảng tin
- Hiển thị tin tức mới nhất với carousel featured articles
- Danh mục tin tức có thể lọc (Công nghệ, Kinh doanh, Thể thao, v.v.)
- Card tin tức với hình ảnh và thông tin tác giả
- Glass morphism UI với liquid background effects

###  Chi tiết bài báo
- Hiển thị toàn bộ nội dung bài viết
- Video player tích hợp (placeholder)
- Tin liên quan
- Floating action bar (bookmark, like, share)
- Glass navigation bar

###  Tìm kiếm
- Thanh tìm kiếm với voice search (placeholder)
- Trending topics grid
- Lọc theo danh mục
- Kết quả tìm kiếm real-time

### 👤 Hồ sơ / Cài đặt
- Thông tin người dùng
- Cài đặt chế độ tối
- Cài đặt thông báo
- Cài đặt cỡ chữ
- Trợ giúp & chính sách bảo mật

###  Glass Liquid UI
- Glass morphism effects với backdrop blur
- Animated liquid background với gradient blobs
- Smooth animations và transitions
- Bottom navigation bar với glass effect

## 🚀 Cài đặt và Chạy Dự Án

### Yêu cầu hệ thống

**Frontend (Flutter):**
- Flutter SDK 3.10.1 trở lên
- Dart SDK 3.10.1 trở lên
- Android Studio / VS Code với Flutter extension
- Android SDK hoặc Xcode (cho iOS)

**Backend (Node.js):**
- Node.js 16.x trở lên
- npm hoặc yarn
- MongoDB Atlas account (hoặc MongoDB local)

### Cấu trúc dự án

```
app-tintuc/
├── backend/          # Backend API (Node.js + Express + MongoDB)
│   ├── server.js
│   ├── package.json
│   └── .env
└── lib/              # Flutter App
    ├── config/
    ├── screens/
    └── ...
```

---

## 📦 Bước 1: Cài đặt Backend

1. **Di chuyển vào thư mục backend:**
```bash
cd backend
```

2. **Cài đặt dependencies:**
```bash
npm install
```

3. **Kiểm tra file `.env`:**
Đảm bảo file `.env` có nội dung:
```env
PORT=3000
JWT_SECRET=your-secret-key-change-this-in-production
MONGODB_URI=mongodb+srv://vinhprop2004_db_user:5WYE8nakdPOdDpkB@cluster0.amkwdxh.mongodb.net/tintuc_db?retryWrites=true&w=majority
```

4. **Chạy backend server:**
```bash
# Development mode (với auto-reload)
npm run dev

# Hoặc Production mode
npm start
```

✅ Server sẽ chạy tại: `http://localhost:3000`

**Kiểm tra server hoạt động:**
Mở browser và truy cập: `http://localhost:3000/api/health`

---

## 📱 Bước 2: Cài đặt và Chạy Flutter App

1. **Quay về thư mục gốc:**
```bash
cd ..
```

2. **Cài đặt Flutter dependencies:**
```bash
flutter pub get
```

3. **Cấu hình API URL:**

Mở file `lib/config/api_config.dart` và cập nhật `baseUrl` tùy theo môi trường:

**Cho Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

**Cho iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:3000';
```

**Cho thiết bị thật:**
1. Tìm IP của máy tính:
   - Windows: `ipconfig` (tìm IPv4 Address)
   - Mac/Linux: `ifconfig` hoặc `ip addr`
2. Cập nhật:
```dart
static const String baseUrl = 'http://192.168.1.XXX:3000'; // Thay XXX bằng IP của bạn
```

**Lưu ý:** Đảm bảo máy tính và thiết bị cùng mạng WiFi.

4. **Chạy Flutter app:**
```bash
# Chạy trên thiết bị mặc định
flutter run

# Hoặc chạy trên thiết bị cụ thể
flutter run -d chrome          # Web
flutter run -d windows          # Windows
flutter run -d <device-id>      # Android/iOS device
```

---

## 🔄 Quy trình chạy dự án (Development)

### Terminal 1 - Backend:
```bash
cd backend
npm run dev
```

### Terminal 2 - Frontend:
```bash
flutter run
```

**Lưu ý:** Backend phải chạy trước khi test các chức năng đăng ký/đăng nhập trong Flutter app.

---

## ✅ Kiểm tra kết nối

1. **Backend đang chạy:**
   - Mở `http://localhost:3000/api/health` trên browser
   - Nếu thấy `{"success": true, "message": "Server đang hoạt động"}` → ✅ Backend OK

2. **Flutter app kết nối được:**
   - Mở app và thử đăng ký tài khoản mới
   - Nếu thành công → ✅ Kết nối OK
   - Nếu lỗi "Connection refused" → Kiểm tra lại `baseUrl` trong `api_config.dart`

---

## 🐛 Troubleshooting

### Lỗi: "Connection refused" trong Flutter
- ✅ Đảm bảo backend đang chạy (`npm run dev` trong thư mục `backend`)
- ✅ Kiểm tra `baseUrl` trong `lib/config/api_config.dart` đúng chưa
- ✅ Nếu dùng thiết bị thật, đảm bảo cùng mạng WiFi với máy tính
- ✅ Tắt firewall tạm thời để test

### Lỗi: "MongoDB connection failed"
- ✅ Kiểm tra connection string trong `backend/.env`
- ✅ Đảm bảo IP của bạn đã được whitelist trong MongoDB Atlas
- ✅ Kiểm tra network connection

### Lỗi: "npm: command not found"
- ✅ Cài đặt Node.js từ [nodejs.org](https://nodejs.org/)
- ✅ Khởi động lại terminal sau khi cài đặt

### Lỗi: "flutter: command not found"
- ✅ Cài đặt Flutter SDK và thêm vào PATH
- ✅ Chạy `flutter doctor` để kiểm tra cài đặt

## 📚 Dependencies

### Flutter Dependencies

```yaml
dependencies:
  # UI Components
  google_fonts: ^6.1.0
  
  # State Management
  provider: ^6.1.1
  
  # Navigation
  go_router: ^14.6.2
  
  # Networking
  http: ^1.2.2
  
  # Image & Media
  cached_network_image: ^3.3.1
  video_player: ^2.8.2
  
  # UI Helpers
  flutter_animate: ^4.5.0
  shimmer: ^3.0.0
  
  # Utils
  intl: ^0.19.0
  timeago: ^3.6.1
  shared_preferences: ^2.2.2  # Lưu token authentication
```

### Backend Dependencies

```json
{
  "express": "^4.18.2",
  "mongoose": "^8.0.0",
  "cors": "^2.8.5",
  "bcryptjs": "^2.4.3",
  "dotenv": "^16.3.1",
  "jsonwebtoken": "^9.0.2"
}
```

## 📁 Cấu trúc dự án

```
lib/
├── config/
│   ├── app_colors.dart        # Màu sắc
│   ├── app_theme.dart          # Theme configuration
│   └── app_constants.dart      # Constants
├── data/
│   └── mock_data.dart          # Mock data
├── models/
│   ├── news_article.dart       # Model bài viết
│   └── category.dart           # Model danh mục
├── screens/
│   ├── home/
│   │   └── home_screen.dart    # Màn hình trang chủ
│   ├── detail/
│   │   └── detail_screen.dart  # Màn hình chi tiết
│   ├── search/
│   │   └── search_screen.dart  # Màn hình tìm kiếm
│   └── profile/
│       └── profile_screen.dart # Màn hình hồ sơ
├── widgets/
│   ├── glass_container.dart    # Glass effect containers
│   ├── liquid_background.dart  # Liquid background effect
│   ├── category_chip.dart      # Category chips
│   ├── news_card.dart          # News card widgets
│   └── bottom_nav_bar.dart     # Bottom navigation
└── main.dart                   # Entry point
```

## Thiết kế

Ứng dụng sử dụng **Glass Liquid Design System** với:

### Colors
- **Primary**: `#137FEC` (Blue)
- **Background Dark**: `#101922`
- **Surface Dark**: `#1C2630`
- **Glass effects**: Transparent overlays với backdrop blur

### Typography
- **Font Family**: Work Sans
- **Display**: Bold, 28-32px
- **Headline**: Bold, 18-24px
- **Body**: Regular/Light, 14-18px

### Effects
- **Glass Morphism**: `blur(12px)` với `rgba(255, 255, 255, 0.08)` border
- **Liquid Blobs**: Animated gradient circles với blur
- **Shadows**: Soft shadows cho depth

##  Luồng Navigation

```
MainScreen (Bottom Nav)
├── Home Screen
│   └── Detail Screen
├── Search Screen
│   └── Detail Screen
├── Bookmarked Screen
└── Profile Screen
```

##  Screenshots

### Màn hình chính
- Trang chủ với featured carousel
- Glass navigation bar
- Liquid background effects

### Chi tiết bài báo
- Hero image với gradient overlay
- Video player
- Floating action bar

### Tìm kiếm
- Trending topics grid
- Search bar với voice input
- Category filters

### Hồ sơ
- User profile card
- Settings với switches
- Glass panels

## 🔐 Authentication với MongoDB

Ứng dụng đã tích hợp đầy đủ authentication với MongoDB:

- ✅ **Đăng ký người dùng** - Lưu vào MongoDB với mật khẩu được mã hóa
- ✅ **Đăng nhập** - Xác thực với MongoDB
- ✅ **JWT Token** - Lưu token vào SharedPreferences
- ✅ **Auto-login** - Tự động đăng nhập khi mở app lại
- ✅ **Session management** - Quản lý session an toàn

Xem chi tiết trong `SETUP_MONGODB.md` và `backend/README.md`

##  Tính năng nâng cao (TODO)

- [ ] Video player thực sự với controls
- [ ] Voice search functionality
- [ ] Push notifications
- [ ] Offline reading mode
- [ ] Social sharing (Google, Facebook)
- [ ] Bookmark sync với MongoDB
- [ ] Dark/Light theme toggle thực tế
- [ ] Font size adjustment
- [ ] Quên mật khẩu với email

##  Phát triển

### Code Style
- Tuân theo Flutter/Dart conventions
- Comments bằng tiếng Việt cho UI/UX
- Code và variables bằng tiếng Anh
- Clean architecture với separation of concerns

### Testing
```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

### Build
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release
```

## 📄 License

Copyright © 2025. All rights reserved.




---

**Version**: 2.4.0 (Build 102)


