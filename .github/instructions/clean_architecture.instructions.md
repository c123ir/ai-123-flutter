---
applyTo: "lib_new/**"
---

# Clean Architecture Instructions - دستیار هوشمند یک دو سه

## 🎯 مأموریت

شما در حال توسعه پروژه **"دستیار هوشمند یک دو سه"** با معماری Clean Architecture هستید.

## 🏗️ ساختار اجباری

### 📂 CRITICAL: ساختار پوشه‌ها

```
lib_new/
├── app/                    # تنظیمات اصلی اپ
├── shared/                 # کامپوننت‌های مشترک
├── features/               # ویژگی‌های اصلی
│   ├── auth/              # احراز هویت (مشترک)
│   ├── customer/          # ویژگی‌های مشتری
│   └── admin/             # ویژگی‌های مدیریت
└── core/                  # سرویس‌های اساسی
```

### 🚫 FORBIDDEN Actions

- **NEVER** قرار دادن فایل در lib_new/ root (جز main.dart)
- **NEVER** قاطی کردن customer و admin features
- **NEVER** قرار دادن business logic در presentation layer
- **NEVER** فراموش کردن export files
- **NEVER** استفاده از hardcoded values

### ✅ REQUIRED Patterns

#### Feature Structure

```
features/{feature_name}/
├── data/
│   ├── models/           # Data models (JSON serializable)
│   ├── repositories/     # Repository implementations
│   └── datasources/      # Local/Remote data sources
├── domain/
│   ├── entities/         # Business entities
│   ├── usecases/         # Business logic
│   └── repositories/     # Repository interfaces
└── presentation/
    ├── screens/          # UI screens
    ├── widgets/          # UI components
    └── providers/        # State management
```

#### نام‌گذاری الزامی

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Folders**: `snake_case`

## 📱 Customer vs Admin Separation

### Customer Features (موبایل/تبلت)

```
features/customer/
├── dashboard/          # داشبورد مشتری
├── consultation/       # درخواست مشاوره
├── ai_chat/           # چت با AI
├── profile/           # پروفایل کاربری
└── notifications/     # اعلانات
```

### Admin Features (دسکتاپ/وب)

```
features/admin/
├── dashboard/         # داشبورد مدیریت
├── user_management/   # مدیریت کاربران
├── reports/          # گزارش‌ها و آمار
├── settings/         # تنظیمات سیستم
└── sms_management/   # مدیریت پیامک
```

## 🔄 Dependency Rules

1. **Presentation** → Domain ← **Data**
2. **Domain** مستقل از همه
3. **Core** قابل استفاده توسط همه
4. **Shared** قابل استفاده توسط features

## 📝 مثال‌های صحیح

### مدل Data Layer

```dart
// features/admin/user_management/data/models/user_model.dart
@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
```

### Use Case

```dart
// features/admin/user_management/domain/usecases/get_users_usecase.dart
class GetUsersUseCase {
  final UserRepositoryInterface repository;

  GetUsersUseCase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call() async {
    return await repository.getUsers();
  }
}
```

### Screen

```dart
// features/admin/user_management/presentation/screens/users_list_screen.dart
class UsersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت کاربران')),
      body: Consumer<UserManagementProvider>(
        builder: (context, provider, child) {
          // Implementation
        },
      ),
    );
  }
}
```

## 🎨 UI Guidelines

### Theme System

```dart
// ✅ همیشه از theme استفاده کنید
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'متن',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
)
```

### Responsive Design

```dart
// ✅ همیشه responsive design پیاده کنید
ResponsiveHelper.responsive(
  context,
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

## 🔐 Authentication Rules

### AuthWrapper برای مسیریابی

```dart
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthResult>(
      future: AuthService.checkAuthStatus(),
      builder: (context, snapshot) {
        if (!snapshot.data?.isLoggedIn ?? false) {
          return const LoginScreen();
        }

        switch (snapshot.data!.userRole) {
          case UserRole.admin:
            return const AdminDashboardScreen();
          case UserRole.customer:
            return const CustomerAppScreen();
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
```

## 📋 Export File Pattern

### هر پوشه باید export file داشته باشد

```dart
// features/admin/user_management/user_management.dart
export 'data/models/models.dart';
export 'data/repositories/repositories.dart';
export 'data/datasources/datasources.dart';

export 'domain/entities/entities.dart';
export 'domain/usecases/usecases.dart';

export 'presentation/screens/screens.dart';
export 'presentation/widgets/widgets.dart';
export 'presentation/providers/providers.dart';
```

## ⚠️ هشدارهای مهم

### 🚨 CRITICAL ERRORS TO AVOID

1. **قرار دادن UI logic در domain layer**
2. **وابستگی domain به data/presentation**
3. **فراموش کردن responsive design**
4. **عدم جداسازی customer/admin**
5. **استفاده از hardcoded strings**

### ✅ ALWAYS REMEMBER

1. **Persian/RTL support** برای تمام متن‌ها
2. **Error handling** برای تمام async operations
3. **Loading states** برای تمام data fetching
4. **Documentation** برای تمام public methods
5. **Authentication check** قبل از عملیات حساس

## 🎯 موفقیت در صورتی حاصل می‌شود که:

- ✅ ساختار Clean Architecture رعایت شود
- ✅ جداسازی customer/admin محفوظ باشد
- ✅ Responsive design پیاده شود
- ✅ RTL support کامل باشد
- ✅ Error handling جامع باشد
- ✅ Documentation کامل باشد

## 📞 در صورت تردید:

- **File placement** → بررسی section ساختار پوشه‌ها
- **Naming** → بررسی naming conventions
- **Architecture** → بررسی dependency rules
- **UI** → بررسی theme و responsive design rules
