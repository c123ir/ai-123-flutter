# سوالات متداول (FAQ)
## دستیار هوشمند یک دو سه

---

## 📋 فهرست مطالب

1. [سوالات عمومی](#سوالات-عمومی)
2. [نصب و راه‌اندازی](#نصب-و-راه‌اندازی)
3. [توسعه و برنامه‌نویسی](#توسعه-و-برنامه‌نویسی)
4. [بانک اطلاعاتی](#بانک-اطلاعاتی)
5. [UI/UX](#uiux)
6. [API](#api)
7. [امنیت](#امنیت)
8. [عملکرد](#عملکرد)
9. [خطایابی](#خطایابی)
10. [لایسنس و قانونی](#لایسنس-و-قانونی)

---

## 🎯 سوالات عمومی

### **❓ دستیار هوشمند یک دو سه چیست؟**
دستیار هوشمند یک دو سه یک سیستم جامع مدیریت کسب و کار است که با Flutter ساخته شده و شامل:
- پنل مدیریت (دسکتاپ/وب)
- اپلیکیشن مشتری (موبایل)
- سیستم چت هوشمند با AI
- ابزارهای CRM و فرم‌ساز

### **❓ چه پلتفرم‌هایی پشتیبانی می‌شود؟**
- **موبایل:** Android, iOS
- **دسکتاپ:** Windows, macOS, Linux
- **وب:** تمامی مرورگرهای مدرن
- **سرور:** PHP/Laravel, Node.js, Python

### **❓ آیا کد منبع آزاد است؟**
بله، این پروژه تحت لایسنس MIT منتشر شده و کاملاً رایگان و آزاد است.

### **❓ چه زبان‌های برنامه‌نویسی استفاده شده؟**
- **Frontend:** Dart/Flutter
- **Backend:** PHP (Laravel), MySQL
- **AI Services:** Python (اختیاری)

---

## 🚀 نصب و راه‌اندازی

### **❓ چطور پروژه را نصب کنم؟**
```bash
# 1. کلون کردن پروژه
git clone https://github.com/yourusername/ai-123-flutter.git

# 2. ورود به پوشه پروژه
cd ai-123-flutter

# 3. نصب وابستگی‌ها
flutter pub get

# 4. اجرای پروژه
flutter run
```

### **❓ چه پیش‌نیازهایی لازم است؟**
- Flutter SDK 3.8.1+
- Dart SDK 3.0.0+
- Android Studio یا VS Code
- Git
- MySQL (برای سرور)

### **❓ چطور Flutter را نصب کنم؟**
1. از [سایت رسمی Flutter](https://flutter.dev) دانلود کنید
2. فایل ZIP را استخراج کنید
3. مسیر `flutter/bin` را به PATH اضافه کنید
4. `flutter doctor` را اجرا کنید

### **❓ خطای "Flutter not found" می‌گیرم**
این خطا معمولاً به دلیل عدم اضافه شدن Flutter به PATH است:

**Windows:**
```bash
set PATH=%PATH%;C:\flutter\bin
```

**macOS/Linux:**
```bash
export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"
```

### **❓ چطور فونت فارسی را تنظیم کنم؟**
فونت Vazirmatn در پوشه `fonts/` موجود است و در `pubspec.yaml` تعریف شده:

```yaml
flutter:
  fonts:
    - family: Vazirmatn
      fonts:
        - asset: fonts/Vazirmatn-Regular.ttf
```

---

## 💻 توسعه و برنامه‌نویسی

### **❓ چطور یک Model جدید اضافه کنم؟**
```dart
// 1. فایل جدید در lib/models/
class NewModel {
  final int? id;
  final String name;
  
  NewModel({this.id, required this.name});
  
  factory NewModel.fromJson(Map<String, dynamic> json) {
    return NewModel(
      id: json['id'],
      name: json['name'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// 2. اضافه کردن به models.dart
export 'new_model.dart';
```

### **❓ چطور یک Service جدید بسازم؟**
```dart
// lib/services/new_service.dart
class NewService {
  static Future<List<NewModel>> getAll() async {
    // Implementation
  }
  
  static Future<NewModel> create(NewModel model) async {
    // Implementation
  }
}
```

### **❓ چطور یک Widget سفارشی بسازم؟**
```dart
class CustomWidget extends StatelessWidget {
  final String title;
  
  const CustomWidget({Key? key, required this.title}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title),
    );
  }
}
```

### **❓ چطور State Management کنم؟**
فعلاً از `setState` استفاده می‌شود، اما برای پروژه‌های بزرگ‌تر توصیه می‌شود:
- **Provider:** برای state management متوسط
- **Bloc:** برای پروژه‌های پیچیده
- **Riverpod:** جایگزین مدرن Provider

### **❓ چطور Navigation کنم؟**
```dart
// رفتن به صفحه جدید
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewPage()),
);

// برگشت
Navigator.pop(context);

// جایگزین کردن صفحه
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewPage()),
);
```

---

## 🗄️ بانک اطلاعاتی

### **❓ چطور بانک اطلاعاتی محلی کار می‌کند؟**
از SQLite برای ذخیره محلی استفاده می‌شود:
```dart
// دسترسی به دیتابیس
final db = await DatabaseHelper.instance.database;

// درج داده
await db.insert('users', user.toJson());

// خواندن داده‌ها
final List<Map<String, dynamic>> maps = await db.query('users');
```

### **❓ چطور داده‌ها را همگام‌سازی کنم؟**
```dart
// همگام‌سازی با سرور
await SyncService.syncToServer();
await SyncService.syncFromServer();
```

### **❓ چطور Backup بگیرم؟**
```bash
# MySQL backup
mysqldump -u username -p database_name > backup.sql

# SQLite backup
cp database.db backup_database.db
```

### **❓ چطور Migration اجرا کنم؟**
```sql
-- جدول جدید
CREATE TABLE new_table (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- اضافه کردن ستون
ALTER TABLE existing_table ADD COLUMN new_column TEXT;
```

### **❓ چطور Performance دیتابیس را بهبود دهم؟**
- استفاده از Index روی ستون‌های پرجستجو
- محدود کردن تعداد رکوردها با LIMIT
- استفاده از Prepared Statements
- بهینه‌سازی Query ها

---

## 🎨 UI/UX

### **❓ چطور Theme تغییر دهم؟**
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  home: MyHomePage(),
)
```

### **❓ چطور رنگ‌ها را شخصی‌سازی کنم؟**
```dart
// در lib/constants/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFF667eea);
  static const Color secondary = Color(0xFF43cea2);
  // سایر رنگ‌ها...
}
```

### **❓ چطور فونت تغییر دهم؟**
1. فونت جدید در پوشه `fonts/` قرار دهید
2. در `pubspec.yaml` تعریف کنید:
```yaml
fonts:
  - family: NewFont
    fonts:
      - asset: fonts/NewFont-Regular.ttf
```
3. در Theme اعمال کنید:
```dart
ThemeData(
  fontFamily: 'NewFont',
)
```

### **❓ چطور Responsive Design پیاده‌سازی کنم؟**
```dart
// استفاده از LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 800) {
      return DesktopLayout();
    } else {
      return MobileLayout();
    }
  },
)

// یا استفاده از ResponsiveHelper
final padding = ResponsiveHelper.getResponsiveSize(
  context,
  mobile: 16,
  tablet: 24,
  desktop: 32,
);
```

### **❓ چطور Animation اضافه کنم؟**
```dart
// Fade animation
AnimatedOpacity(
  opacity: isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  child: MyWidget(),
)

// Slide animation
SlideTransition(
  position: Tween<Offset>(
    begin: Offset(1.0, 0.0),
    end: Offset.zero,
  ).animate(animation),
  child: MyWidget(),
)
```

---

## 🔌 API

### **❓ چطور API call کنم؟**
```dart
// GET request
final response = await ApiService.get('users');

// POST request
final response = await ApiService.post('users', {
  'name': 'نام کاربر',
  'email': 'user@example.com',
});
```

### **❓ چطور Authentication کنم؟**
```dart
// Login
final loginResponse = await ApiService.post('auth/login', {
  'email': 'user@example.com',
  'password': 'password123',
});

final token = loginResponse['data']['token'];

// Use token in subsequent requests
final response = await ApiService.get('profile', 
  headers: {'Authorization': 'Bearer $token'}
);
```

### **❓ چطور Error Handling کنم؟**
```dart
try {
  final response = await ApiService.get('users');
  // Success handling
} on ApiException catch (e) {
  // API specific errors
  print('API Error: ${e.message}');
} catch (e) {
  // General errors
  print('General Error: $e');
}
```

### **❓ Base URL را چطور تغییر دهم؟**
```dart
// در lib/services/api_service.dart
static const String baseUrl = 'https://your-api-domain.com/api/v1';
```

---

## 🔒 امنیت

### **❓ چطور داده‌ها را رمزگذاری کنم؟**
```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

// Hash password
String hashPassword(String password) {
  final bytes = utf8.encode(password + 'salt');
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```

### **❓ چطور Token را ذخیره کنم؟**
```dart
import 'package:shared_preferences/shared_preferences.dart';

// Save token
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', token);

// Get token
final token = prefs.getString('auth_token');
```

### **❓ چطور Input Validation کنم؟**
```dart
String? validateEmail(String? value) {
  if (value?.isEmpty ?? true) {
    return 'ایمیل الزامی است';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
    return 'فرمت ایمیل صحیح نیست';
  }
  return null;
}
```

### **❓ چطور از SQL Injection جلوگیری کنم؟**
```dart
// استفاده از Prepared Statements
await db.query(
  'users',
  where: 'email = ?',
  whereArgs: [email],
);

// نه این کار:
// await db.rawQuery('SELECT * FROM users WHERE email = "$email"');
```

---

## ⚡ عملکرد

### **❓ چطور Performance بهبود دهم؟**
- استفاده از `const` constructors
- پیاده‌سازی `ListView.builder` برای لیست‌های طولانی
- Cache کردن تصاویر
- استفاده از `FutureBuilder` و `StreamBuilder`

### **❓ چطور Memory Leak جلوگیری کنم؟**
```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }
  
  @override
  void dispose() {
    _controller.dispose(); // مهم: dispose کردن resources
    super.dispose();
  }
}
```

### **❓ چطور Build Size کم کنم؟**
```bash
# Build release با حداقل سایز
flutter build apk --release --shrink

# حذف debug info
flutter build apk --release --split-debug-info=debug-info

# Obfuscation
flutter build apk --release --obfuscate --split-debug-info=debug-info
```

### **❓ چطور Lazy Loading پیاده‌سازی کنم؟**
```dart
ListView.builder(
  itemCount: items.length + 1,
  itemBuilder: (context, index) {
    if (index == items.length) {
      // Load more items
      _loadMoreItems();
      return CircularProgressIndicator();
    }
    return ListTile(title: Text(items[index]));
  },
)
```

---

## 🐛 خطایابی

### **❓ خطای "RenderFlex overflowed" چیست؟**
این خطا زمانی رخ می‌دهد که فضای در دسترس کافی نیست:
```dart
// حل: استفاده از Flexible یا Expanded
Row(
  children: [
    Expanded(child: Text('Long text here')),
    Icon(Icons.star),
  ],
)

// یا استفاده از Wrap
Wrap(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)
```

### **❓ خطای "setState called after dispose" چیست؟**
```dart
// حل: چک کردن mounted قبل از setState
if (mounted) {
  setState(() {
    // State update
  });
}
```

### **❓ چطور Debug کنم؟**
```dart
// Console logging
print('Debug message: $variable');

// Debug mode check
if (kDebugMode) {
  print('Debug only message');
}

// Debugging with debugger
debugger(); // Breakpoint
```

### **❓ چطور Hot Reload کار نمی‌کند؟**
- فایل را Save کنید
- Terminal را چک کنید
- Android Studio را restart کنید
- `flutter clean` و `flutter pub get` اجرا کنید

### **❓ چطور Performance مشکلات را بررسی کنم؟**
```bash
# Performance profiling
flutter run --profile

# Memory profiling
flutter run --profile --enable-dart-profiling
```

---

## 📜 لایسنس و قانونی

### **❓ چه لایسنسی دارد؟**
این پروژه تحت لایسنس MIT منتشر شده است که به معنای:
- استفاده تجاری آزاد
- تغییر و توزیع آزاد
- بدون ضمانت

### **❓ می‌توانم تجاری استفاده کنم؟**
بله، کاملاً آزاد و بدون محدودیت.

### **❓ باید منبع اصلی را ذکر کنم؟**
طبق لایسنس MIT، ذکر منبع الزامی نیست اما توصیه می‌شود.

### **❓ می‌توانم فروش کنم؟**
بله، می‌توانید محصول نهایی را فروش کنید.

### **❓ چطور مشارکت کنم؟**
1. پروژه را Fork کنید
2. تغییرات خود را اعمال کنید
3. Pull Request ایجاد کنید
4. منتظر بررسی باشید

---

## 🆘 راهنمای حل مشکلات سریع

### **مشکل:** Flutter command not found
**حل:** PATH را تنظیم کنید و `flutter doctor` اجرا کنید

### **مشکل:** Gradle build failed
**حل:** 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### **مشکل:** iOS build failed
**حل:**
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

### **مشکل:** Database locked error
**حل:** تمام connection ها را ببندید و دوباره باز کنید

### **مشکل:** Network request failed
**حل:** 
- اتصال اینترنت را چک کنید
- Base URL را بررسی کنید
- CORS settings را چک کنید

---

## 📞 پشتیبانی و کمک

### **کجا کمک بگیرم؟**
- **GitHub Issues:** [لینک Issues](https://github.com/yourusername/ai-123-flutter/issues)
- **ایمیل:** support@smartassistant123.com
- **تلگرام:** @SmartAssistant123Support
- **مستندات:** [لینک Docs](https://docs.smartassistant123.com)

### **چطور Bug Report کنم؟**
1. مشکل را دقیق توضیح دهید
2. گام‌های بازتولید مشکل
3. Screenshot یا log های خطا
4. اطلاعات دستگاه و نسخه Flutter

### **چطور Feature Request کنم؟**
1. GitHub Issues میں جدید issue ایجاد کنید
2. Label "enhancement" اضافه کنید
3. دلیل نیاز به این ویژگی را بنویسید
4. مثال‌هایی از استفاده ارائه دهید

---

**نسخه FAQ:** 1.0.0  
**آخرین به‌روزرسانی:** ۳۰ مرداد ۱۴۰۴  
**تیم پشتیبانی:** دستیار هوشمند یک دو سه

> 💡 **نکته:** اگر سوال شما در این لیست نیست، لطفاً با تیم پشتیبانی تماس بگیرید.
