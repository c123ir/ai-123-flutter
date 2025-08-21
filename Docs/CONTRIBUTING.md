# Contributing Guide
## دستیار هوشمند یک دو سه

از علاقه شما به مشارکت در پروژه دستیار هوشمند یک دو سه متشکریم! این راهنما تمامی اطلاعات لازم برای مشارکت موثر را ارائه می‌دهد.

---

## 📋 فهرست مطالب

1. [قوانین مشارکت](#قوانین-مشارکت)
2. [نحوه شروع](#نحوه-شروع)
3. [استانداردهای کد](#استانداردهای-کد)
4. [فرآیند توسعه](#فرآیند-توسعه)
5. [نحوه گزارش باگ](#نحوه-گزارش-باگ)
6. [درخواست ویژگی](#درخواست-ویژگی)
7. [Pull Request Guidelines](#pull-request-guidelines)
8. [Testing](#testing)
9. [Documentation](#documentation)

---

## 🤝 قوانین مشارکت

### Code of Conduct
- احترام به همه مشارکت‌کنندگان
- استفاده از زبان مودبانه و سازنده
- پذیرش نقد سازنده
- تمرکز روی بهترین راه‌حل برای جامعه

### انواع مشارکت
- 🐛 **گزارش و رفع باگ**
- ✨ **پیشنهاد ویژگی جدید**
- 📝 **بهبود مستندات**
- 🎨 **بهبود UI/UX**
- ⚡ **بهینه‌سازی Performance**
- 🧪 **نوشتن Test**

---

## 🚀 نحوه شروع

### 1. Setup محیط توسعه

#### پیش‌نیازها:
```bash
# Flutter SDK
flutter --version  # باید 3.8.1+ باشد

# Git
git --version

# IDE
# Android Studio یا VS Code
```

#### کلون کردن پروژه:
```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/ai-123-flutter.git
cd ai-123-flutter

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/ai-123-flutter.git
```

#### نصب dependencies:
```bash
flutter pub get
flutter pub run build_runner build
```

#### تست اولیه:
```bash
flutter analyze
flutter test
flutter run -d chrome  # یا device دلخواه
```

### 2. ساختار پروژه آشنایی

```
lib/
├── 📁 components/          # کامپوننت‌های قابل استفاده مجدد
├── 📁 database/           # SQLite helper و schema
├── 📁 models/             # Data models
├── 📁 screens/            # صفحات اصلی اپلیکیشن
├── 📁 services/           # Business logic و API calls
├── 📁 widgets/            # Custom widgets
├── 📁 constants/          # ثابت‌ها (colors, strings, etc.)
├── 📁 utils/              # Helper functions
└── main.dart              # Entry point
```

---

## 📝 استانداردهای کد

### 1. Dart/Flutter Standards

#### نام‌گذاری:
```dart
// ✅ درست
class UserService { }          // PascalCase for classes
final userName = 'احمد';        // camelCase for variables
const apiBaseUrl = 'https://'; // camelCase for constants
enum UserRole { admin, user }  // camelCase for enums

// ❌ غلط
class user_service { }
final user_name = 'احمد';
const API_BASE_URL = 'https://';
```

#### فایل‌ها و پوشه‌ها:
```bash
# ✅ درست
user_service.dart
admin_dashboard.dart
models/user.dart

# ❌ غلط
UserService.dart
AdminDashboard.dart
Models/User.dart
```

#### Comments و Documentation:
```dart
/// سرویس مدیریت کاربران سیستم
/// 
/// این کلاس تمامی عملیات مربوط به کاربران را مدیریت می‌کند
/// شامل CRUD operations و authentication
/// 
/// Example:
/// ```dart
/// final users = await UserService.getAllUsers();
/// ```
class UserService {
  /// دریافت لیست تمام کاربران فعال
  /// 
  /// Returns [List<User>] of active users
  /// Throws [ApiException] if request fails
  static Future<List<User>> getAllUsers() async {
    // Implementation
  }
}
```

### 2. کیفیت کد

#### Linting:
```bash
# اجرای lint
flutter analyze

# فرمت کردن کد
dart format .

# بررسی import های اضافی
dart fix --dry-run
dart fix --apply
```

#### Best Practices:
```dart
// ✅ استفاده از const برای widgets
const Text('سلام دنیا')

// ✅ استفاده از final برای متغیرهای غیرقابل تغییر
final String userName = 'احمد';

// ✅ Null safety
String? getUserName() => user?.name;

// ✅ Proper error handling
try {
  final result = await apiCall();
  return result;
} on ApiException catch (e) {
  logger.error('API Error: ${e.message}');
  rethrow;
} catch (e) {
  logger.error('Unexpected error: $e');
  throw UnexpectedError(e.toString());
}
```

### 3. UI/UX Standards

#### Color Usage:
```dart
// ✅ استفاده از AppColors
Container(
  color: AppColors.primary,
  child: Text(
    'متن',
    style: TextStyle(color: AppColors.onPrimary),
  ),
)

// ❌ hardcode کردن رنگ
Container(
  color: Color(0xFF667eea),
  child: Text('متن'),
)
```

#### Responsive Design:
```dart
// ✅ استفاده از ResponsiveHelper
final padding = ResponsiveHelper.getResponsiveSize(
  context,
  mobile: 16,
  tablet: 24,
  desktop: 32,
);

// ✅ استفاده از MediaQuery
final isLargeScreen = MediaQuery.of(context).size.width > 800;
```

---

## 🔄 فرآیند توسعه

### 1. Git Workflow

#### Branch Strategy:
```bash
main                    # Production ready code
├── develop            # Development branch
├── feature/user-auth  # Feature branches
├── bugfix/login-issue # Bug fix branches
└── hotfix/security   # Critical fixes
```

#### نامگذاری Branch:
```bash
# Features
feature/add-ai-chat
feature/improve-dashboard
feature/user-management

# Bug fixes  
bugfix/fix-login-error
bugfix/resolve-memory-leak

# Hotfix
hotfix/security-patch
hotfix/critical-bug
```

#### Commit Messages:
```bash
# Format: type(scope): description
# Types: feat, fix, docs, style, refactor, test, chore

# ✅ Good examples
feat(auth): add user authentication system
fix(dashboard): resolve chart rendering issue
docs(api): update API documentation
style(ui): improve button spacing
refactor(services): simplify user service logic
test(models): add user model unit tests
chore(deps): update flutter dependencies

# ❌ Bad examples
fix bug
update code
changes
```

### 2. Development Process

#### شروع کار روی feature جدید:
```bash
# 1. Update main branch
git checkout main
git pull upstream main

# 2. Create feature branch
git checkout -b feature/my-awesome-feature

# 3. Make changes and commit
git add .
git commit -m "feat(feature): add awesome functionality"

# 4. Push to your fork
git push origin feature/my-awesome-feature

# 5. Create Pull Request on GitHub
```

#### در طول توسعه:
```bash
# Regular commits
git add .
git commit -m "feat(auth): implement login form validation"

# Keep branch updated with main
git fetch upstream
git rebase upstream/main

# Run tests
flutter test
flutter analyze
```

---

## 🐛 نحوه گزارش باگ

### Template گزارش باگ:

```markdown
**توضیح باگ**
توضیح واضح و مختصر از مشکل.

**مراحل بازتولید**
1. برو به '...'
2. کلیک روی '....'
3. اسکرول پایین به '....'
4. مشاهده خطا

**رفتار مورد انتظار**
توضیح واضح از آنچه انتظار داشتید اتفاق بیفتد.

**Screenshots**
اگر امکان دارد، screenshot اضافه کنید.

**اطلاعات محیط:**
 - OS: [e.g. iOS, Android, Windows]
 - Flutter version: [e.g. 3.8.1]
 - Device: [e.g. iPhone 14, Samsung Galaxy S21]
 - App version: [e.g. 1.0.0]

**لاگ خطا**
```
خطاهای کنسول یا log files را اینجا قرار دهید
```

**اطلاعات اضافی**
هر توضیح اضافی درباره مشکل.
```

### مثال گزارش باگ خوب:

```markdown
**باگ: صفحه dashboard در حالت landscape نمایش داده نمی‌شود**

**توضیح:**
وقتی دستگاه را به حالت landscape می‌چرخانم، صفحه dashboard به درستی نمایش داده نمی‌شود و sidebar روی محتوا قرار می‌گیرد.

**مراحل بازتولید:**
1. اپ را باز کن
2. وارد پنل مدیریت شو
3. دستگاه را به landscape بچرخان
4. sidebar روی محتوای اصلی قرار می‌گیرد

**رفتار مورد انتظار:**
sidebar باید به صورت مناسب تنظیم شده و محتوای اصلی قابل مشاهده باشد.

**Screenshots:**
[تصویر ضمیمه شده]

**محیط:**
- OS: Android 12
- Flutter: 3.8.1
- Device: Samsung Galaxy S21
- App version: 1.0.0
```

---

## ✨ درخواست ویژگی

### Template درخواست ویژگی:

```markdown
**مشکل مرتبط**
آیا درخواست شما مرتبط با مشکلی است؟ لطفاً توضیح دهید.

**راه‌حل پیشنهادی**
توضیح واضح از آنچه می‌خواهید اتفاق بیفتد.

**جایگزین‌های در نظر گرفته شده**
توضیح راه‌حل‌های جایگزین که در نظر گرفته‌اید.

**اطلاعات اضافی**
هر اطلاعات اضافی یا screenshot درباره درخواست.

**پیاده‌سازی**
آیا مایل به کمک در پیاده‌سازی هستید؟
```

---

## 📤 Pull Request Guidelines

### 1. قبل از ایجاد PR

#### Checklist:
- [ ] کد با استانداردهای پروژه مطابقت دارد
- [ ] تست‌های مربوطه نوشته/به‌روزرسانی شده
- [ ] مستندات به‌روزرسانی شده
- [ ] `flutter analyze` بدون خطا اجرا می‌شود
- [ ] `flutter test` همه تست‌ها pass می‌کنند
- [ ] Screenshots برای تغییرات UI اضافه شده

### 2. Template Pull Request:

```markdown
## توضیح تغییرات
مختصری از تغییرات و دلیل آن‌ها.

## نوع تغییر
- [ ] Bug fix (تغییری که مشکل موجود را حل می‌کند)
- [ ] New feature (تغییری که ویژگی جدید اضافه می‌کند)
- [ ] Breaking change (تغییری که functionality موجود را تغییر می‌دهد)
- [ ] Documentation update

## تست
توضیح دهید که چگونه تغییرات خود را تست کرده‌اید.

- [ ] Unit tests
- [ ] Integration tests  
- [ ] Manual testing

## Checklist
- [ ] کد از style guidelines پیروی می‌کند
- [ ] خود-بررسی کد انجام شده
- [ ] کد کامنت‌گذاری شده (خصوصاً در قسمت‌های پیچیده)
- [ ] مستندات متناظر تغییر کرده
- [ ] تغییرات هیچ warning جدیدی تولید نمی‌کند
- [ ] تست‌های جدید اضافه شده یا موجودی به‌روزرسانی شده
- [ ] همه تست‌ها pass می‌کنند

## Screenshots (اگر مربوطه)
قبل/بعد screenshots برای تغییرات UI
```

### 3. Review Process

#### مراحل بررسی:
1. **Automated checks**: CI/CD pipeline
2. **Code review**: حداقل یک maintainer
3. **Testing**: تست دستی اگر نیاز باشد
4. **Merge**: پس از تایید نهایی

#### معیارهای تایید:
- کد با استانداردها مطابقت دارد
- تست‌ها کافی و pass هستند
- مستندات به‌روز است
- Performance regression وجود ندارد

---

## 🧪 Testing

### 1. انواع تست

#### Unit Tests:
```dart
// test/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_123/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('should create user from JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'name': 'احمد احمدی',
        'email': 'ahmad@example.com',
      };
      
      // Act
      final user = User.fromJson(json);
      
      // Assert
      expect(user.id, 1);
      expect(user.name, 'احمد احمدی');
      expect(user.email, 'ahmad@example.com');
    });
  });
}
```

#### Widget Tests:
```dart
// test/widgets/dashboard_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_123/widgets/dashboard_card.dart';

void main() {
  testWidgets('DashboardCard displays correctly', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardCard(
          title: 'Test Title',
          icon: Icons.star,
          color: Colors.blue,
          value: '100',
          subtitle: 'Test Subtitle',
        ),
      ),
    );
    
    // Verify
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
```

### 2. اجرای تست‌ها

```bash
# همه تست‌ها
flutter test

# تست خاص
flutter test test/models/user_test.dart

# تست با coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 3. Test Guidelines

- هر model باید unit test داشته باشد
- Widget های سفارشی باید widget test داشته باشند
- Business logic در services باید تست شود
- تست‌ها باید سریع و قابل اعتماد باشند

---

## 📚 Documentation

### 1. انواع مستندات

#### Code Documentation:
```dart
/// Service برای مدیریت عملیات کاربران
/// 
/// این service تمامی عملیات CRUD مربوط به کاربران را
/// مدیریت می‌کند و با local database و remote API ارتباط برقرار می‌کند.
/// 
/// Example:
/// ```dart
/// final users = await UserService.getAllUsers();
/// final newUser = await UserService.createUser(userData);
/// ```
class UserService {
  /// دریافت لیست همه کاربران
  /// 
  /// [includeInactive] اگر true باشد کاربران غیرفعال هم برگردانده می‌شوند
  /// 
  /// Returns [Future<List<User>>] لیست کاربران
  /// Throws [ApiException] در صورت خطای API
  /// Throws [DatabaseException] در صورت خطای دیتابیس
  static Future<List<User>> getAllUsers({bool includeInactive = false}) async {
    // Implementation
  }
}
```

#### README Updates:
هر feature جدید باید در README مستند شود:

```markdown
## ویژگی‌های جدید
- ✅ **مدیریت کاربران:** افزودن، ویرایش، حذف کاربران
- ✅ **احراز هویت:** ورود/خروج با JWT token
```

### 2. API Documentation

```dart
/// POST /api/users
/// 
/// ایجاد کاربر جدید در سیستم
/// 
/// **Request Body:**
/// ```json
/// {
///   "name": "نام کاربر",
///   "email": "user@example.com", 
///   "password": "password123"
/// }
/// ```
/// 
/// **Response:**
/// ```json
/// {
///   "success": true,
///   "data": {
///     "id": 1,
///     "name": "نام کاربر",
///     "email": "user@example.com"
///   }
/// }
/// ```
Future<User> createUser(Map<String, dynamic> userData) async {
  // Implementation
}
```

---

## 🏆 Recognition

### نحوه قدردانی از مشارکت‌کنندگان:

#### Contributors List:
تمامی مشارکت‌کنندگان در README.md لیست می‌شوند:

```markdown
## مشارکت‌کنندگان 🙏

- **احمد احمدی** - [GitHub](https://github.com/ahmad) - تحلیل‌گر سیستم
- **فاطمه فاطمی** - [GitHub](https://github.com/fateme) - توسعه‌دهنده UI/UX  
- **علی علوی** - [GitHub](https://github.com/ali) - توسعه‌دهنده Backend
```

#### GitHub Profile:
مشارکت‌های شما در profile GitHub شما نمایش داده می‌شود.

#### Special Recognition:
مشارکت‌کنندگان فعال ممکن است عنوان‌های خاصی دریافت کنند:
- 🌟 **Core Contributor**
- 🎨 **UI/UX Expert** 
- 🔧 **Technical Lead**
- 📚 **Documentation Master**

---

## 📞 ارتباط و پشتیبانی

### کانال‌های ارتباطی:

- **GitHub Issues:** برای باگ‌ها و feature requests
- **GitHub Discussions:** برای سوالات عمومی
- **Email:** contribute@smartassistant123.com
- **Telegram:** @SmartAssistant123Dev

### ساعات پشتیبانی:
- **روزهای کاری:** 9:00 تا 17:00 (وقت تهران)
- **پاسخ به Issues:** حداکثر 48 ساعت
- **بررسی Pull Requests:** حداکثر 72 ساعت

### زبان‌های پشتیبانی:
- **فارسی:** زبان اصلی پروژه
- **انگلیسی:** برای مشارکت‌کنندگان بین‌المللی

---

## ⚖️ لایسنس

این پروژه تحت لایسنس MIT منتشر شده است. با مشارکت در این پروژه، شما موافقت می‌کنید که مشارکت‌تان تحت همین لایسنس منتشر شود.

---

**تشکر از مشارکت شما! 🙏**

تیم دستیار هوشمند یک دو سه از تمامی مشارکت‌کنندگان تشکر می‌کند. مشارکت شما، هر چقدر هم کوچک، ارزشمند است و به بهبود این پروژه کمک می‌کند.

---

**نسخه:** 1.0.0  
**آخرین به‌روزرسانی:** ۳۰ مرداد ۱۴۰۴  
**نگهداری:** تیم توسعه دستیار هوشمند یک دو سه
