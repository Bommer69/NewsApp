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

##  Cài đặt

### Yêu cầu
- Flutter SDK 3.10.1 trở lên
- Dart SDK 3.10.1 trở lên

### Các bước cài đặt

1. **Clone repository**
```bash
git clone <repository-url>
cd TinTucApp
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Chạy ứng dụng**
```bash
flutter run
```

##  Dependencies

```yaml
dependencies:
  # UI Components
  google_fonts: ^6.1.0
  
  # State Management
  provider: ^6.1.1
  
  # Navigation
  go_router: ^14.6.2
  
  # Networking
  http: ^1.2.0
  
  # Image & Media
  cached_network_image: ^3.3.1
  video_player: ^2.8.2
  
  # UI Helpers
  flutter_animate: ^4.5.0
  shimmer: ^3.0.0
  
  # Utils
  intl: ^0.19.0
  timeago: ^3.6.1
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

##  Tính năng nâng cao (TODO)

- [ ] Tích hợp API backend thực tế
- [ ] Video player thực sự với controls
- [ ] Voice search functionality
- [ ] Push notifications
- [ ] Offline reading mode
- [ ] Social sharing
- [ ] User authentication
- [ ] Bookmark sync
- [ ] Dark/Light theme toggle thực tế
- [ ] Font size adjustment

## Ghi chú

- Mock data được sử dụng cho demo
- Video player là placeholder (chưa implement playback)
- Voice search là placeholder (chưa implement)
- Không có backend API (sử dụng mock data)

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


