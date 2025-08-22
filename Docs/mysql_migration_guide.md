# راهنمای تغییر به MySQL

## ✅ **مزایای استفاده از MySQL:**

### 1. **یکپارچگی کامل**
- یک دیتابیس برای همه پلتفرم‌ها
- همگام‌سازی خودکار داده‌ها
- مدیریت متمرکز

### 2. **مقیاس‌پذیری**
- پشتیبانی از تعداد زیاد کاربر
- بهینه‌سازی query ها
- کش کردن داده‌ها

### 3. **پایداری**
- Backup خودکار
- مقاومت در برابر خرابی
- آمار و گزارش‌گیری دقیق

---

## 🛠️ **مراحل پیاده‌سازی:**

### مرحله 1: نصب Backend
```bash
# ایجاد پوشه backend
mkdir backend
cd backend

# نصب Node.js dependencies
npm init -y
npm install express mysql2 cors

# اجرای سرور
node server.js
```

### مرحله 2: راه‌اندازی MySQL
```sql
-- اجرای schema.sql
mysql -u root -p < schema.sql

-- یا دستی:
CREATE DATABASE ai_123_flutter;
-- (باقی schema.sql)
```

### مرحله 3: بروزرسانی Flutter
```bash
# حذف dependencies قدیمی
flutter pub deps

# نصب dependencies جدید
flutter pub get

# تست
flutter run
```

---

## 🔄 **تغییرات انجام شده:**

### ✅ **فایل‌های تغییر یافته:**
1. `lib/database/mysql_adapter.dart` - آداپتور جدید MySQL
2. `lib/database/database_manager.dart` - استفاده از MySQL
3. `pubspec.yaml` - حذف SQLite dependencies
4. `backend/server.js` - API سرور Node.js
5. `backend/schema.sql` - ساختار MySQL

### ✅ **فایل‌های بدون تغییر:**
- `lib/services/sms_service.dart` - کار می‌کند با آداپتور جدید
- `lib/services/update_history_service.dart` - کار می‌کند
- تمام UI components - بدون تغییر

---

## 🧪 **تست عملکرد:**

### 1. تست Backend
```bash
# صحت عملکرد API
curl http://localhost:3000/api/health

# تست SMS History
curl -X GET http://localhost:3000/api/sms_history
```

### 2. تست Flutter
```dart
// در debug console
await DatabaseManager().getAdapter(); // باید MySQL adapter برگرداند
```

---

## ⚙️ **تنظیمات محیط:**

### Development:
```
Database: localhost:3306
API: http://localhost:3000/api
```

### Production:
```
Database: your-mysql-server
API: https://your-domain.com/api
SSL: Required
```

---

## 🔐 **امنیت:**

### API Security:
- API Key authentication
- Rate limiting
- Input validation
- SQL injection prevention

### Database Security:
- User permissions
- SSL connections
- Regular backups

---

## 📊 **مقایسه قبل و بعد:**

| Feature | قبل (SQLite) | بعد (MySQL) |
|---------|-------------|-------------|
| همگام‌سازی | ❌ | ✅ |
| مقیاس‌پذیری | محدود | بالا |
| وب سازگاری | مشکل‌دار | کامل |
| مدیریت | پیچیده | ساده |
| Performance | متوسط | بالا |

---

## 🚀 **مرحله بعد:**

1. راه‌اندازی MySQL server
2. اجرای backend API
3. تست اتصالات
4. پیاده‌سازی authentication
5. بهینه‌سازی queries

**آیا از این رویکرد راضی هستید؟**
