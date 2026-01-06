# Backend API cho ứng dụng Tin Tức

Backend API sử dụng Node.js, Express và MongoDB để xử lý authentication.

## 🚀 Cài đặt và Chạy

### Bước 1: Cài đặt Dependencies

```bash
npm install
```

### Bước 2: Cấu hình Environment

File `.env` đã có sẵn, chỉ cần kiểm tra nội dung:

```env
PORT=3000
JWT_SECRET=your-secret-key-change-this-in-production
MONGODB_URI=mongodb+srv://vinhprop2004_db_user:5WYE8nakdPOdDpkB@cluster0.amkwdxh.mongodb.net/tintuc_db?retryWrites=true&w=majority
```

**Lưu ý:** Đổi `JWT_SECRET` thành một chuỗi ngẫu nhiên mạnh trong production.

### Bước 3: Chạy Server

**Development mode (với auto-reload khi code thay đổi):**
```bash
npm run dev
```

**Production mode:**
```bash
npm start
```

✅ Server sẽ chạy tại: `http://localhost:3000`

### Kiểm tra Server

Mở browser và truy cập:
```
http://localhost:3000/api/health
```

Nếu thấy response:
```json
{
  "success": true,
  "message": "Server đang hoạt động",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```
→ Server đang chạy thành công! ✅

## API Endpoints

### Health Check
- **GET** `/api/health` - Kiểm tra server có hoạt động không

### Authentication

#### Đăng ký
- **POST** `/api/auth/register`
- Body:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "fullName": "Nguyễn Văn A" // optional
}
```
- Response (201):
```json
{
  "success": true,
  "message": "Đăng ký thành công",
  "data": {
    "token": "jwt_token_here",
    "user": {
      "id": "user_id",
      "email": "user@example.com",
      "fullName": "Nguyễn Văn A"
    }
  }
}
```

#### Đăng nhập
- **POST** `/api/auth/login`
- Body:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
- Response (200):
```json
{
  "success": true,
  "message": "Đăng nhập thành công",
  "data": {
    "token": "jwt_token_here",
    "user": {
      "id": "user_id",
      "email": "user@example.com",
      "fullName": "Nguyễn Văn A"
    }
  }
}
```

#### Lấy thông tin user (cần token)
- **GET** `/api/auth/me`
- Headers:
```
Authorization: Bearer <token>
```
- Response (200):
```json
{
  "success": true,
  "data": {
    "id": "user_id",
    "email": "user@example.com",
    "fullName": "Nguyễn Văn A",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

## 📝 Lưu ý Quan Trọng

1. **Bảo mật:**
   - ⚠️ Đổi `JWT_SECRET` trong file `.env` trước khi deploy production
   - ⚠️ Không commit file `.env` lên Git (đã có trong `.gitignore`)
   - ⚠️ Sử dụng HTTPS trong production

2. **CORS:**
   - Server đã cấu hình CORS để cho phép Flutter app kết nối
   - Có thể cần điều chỉnh trong `server.js` nếu deploy lên domain khác

3. **MongoDB:**
   - Đảm bảo connection string MongoDB đúng
   - IP của bạn phải được whitelist trong MongoDB Atlas
   - Kiểm tra network connection

## 🐛 Troubleshooting

### Lỗi: "Cannot find module 'express'"
**Giải pháp:**
```bash
npm install
```

### Lỗi: "MongoDB connection failed"
**Giải pháp:**
1. Kiểm tra connection string trong `.env`
2. Đảm bảo IP của bạn đã được whitelist trong MongoDB Atlas:
   - Vào MongoDB Atlas → Network Access
   - Thêm IP hiện tại hoặc `0.0.0.0/0` (cho phép tất cả - chỉ dùng cho dev)
3. Kiểm tra network connection
4. Thử ping MongoDB cluster

### Lỗi: "Port 3000 already in use"
**Giải pháp:**
1. Tìm process đang dùng port 3000:
   ```bash
   # Windows
   netstat -ano | findstr :3000
   
   # Mac/Linux
   lsof -i :3000
   ```
2. Kill process đó hoặc đổi PORT trong `.env`

### Lỗi: "JWT_SECRET is not defined"
**Giải pháp:**
- Đảm bảo file `.env` tồn tại trong thư mục `backend/`
- Kiểm tra nội dung file `.env` có `JWT_SECRET=...`

### Lỗi CORS khi Flutter app gọi API
**Giải pháp:**
1. Đảm bảo Flutter app đang gọi đúng địa chỉ server
2. Kiểm tra `baseUrl` trong `lib/config/api_config.dart`
3. Kiểm tra cấu hình CORS trong `server.js` (đã có sẵn `app.use(cors())`)

## 📚 Tài liệu tham khảo

- [Express.js Documentation](https://expressjs.com/)
- [Mongoose Documentation](https://mongoosejs.com/)
- [JWT Documentation](https://jwt.io/)
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)

