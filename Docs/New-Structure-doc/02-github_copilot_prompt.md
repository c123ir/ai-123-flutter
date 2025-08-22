# GitHub Copilot Development Rules - دستیار هوشمند یک دو سه

## 🎯 مقدمه و هدف

شما در حال کمک به توسعه پروژه **"دستیار هوشمند یک دو سه"** هستید - یک اپلیکیشن Flutter دوگانه که شامل:
1. **Customer App** - اپلیکیشن مشتری (موبایل/تبلت)
2. **Admin Dashboard** - پنل مدیریت (دسکتاپ/وب)

## 🏗️ معماری پروژه

### Clean Architecture Layers
```
📱 Presentation Layer (UI/Widgets/Screens)
    ↕️
🧠 Domain Layer (Business Logic/Use Cases)
    ↕️
💾 Data Layer (APIs/Database/Storage)
```

### Feature-Based Organization
```
features/
├── auth/           # احراز هویت (مشترک)
├── customer/       # ویژگی‌های مشتری
│   ├── dashboard/
│   ├── consultation/
│   └── ai_chat/
├── admin/          # ویژگی‌های مدیریت
│   ├── dashboard/
│   ├── user_management/
│   ├── reports/
│   └── settings/
└── shared/         # کامپوننت‌های مشترک
```

## 📂 CRITICAL: File Structure Rules

### ✅ REQUIRED Directory Structure
```
lib/
├── app/                    # App config, theme, routing
├── shared/                 # Shared components, widgets, utils
├── features/               # Feature-based modules
│   ├── {feature_name}/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── datasources/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── usecases/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── screens/
│   │       ├── widgets/
│   │       └── providers/
├── core/                   # Network, database, services
└── main.dart
```

### 🚫 FORBIDDEN Actions
- **NEVER** create files outside the defined structure
- **NEVER** put widgets directly in lib/ root
- **NEVER** mix presentation logic with business logic
- **NEVER** create files without proper export files
- **NEVER** use hardcoded values without constants

### ✅ REQUIRED Naming Conventions
- **Files**: `snake_case.dart` (login_screen.dart, user_service.dart)
- **Classes**: `PascalCase` (LoginScreen, UserService)
- **Variables**: `camelCase` (userName, isLoggedIn)
- **Constants**: `SCREAMING_SNAKE_CASE` (API_BASE_URL)
- **Folders**: `snake_case` (user_management, ai_chat)

## 🎨 UI/UX Development Rules

### Theme System
```dart
// ✅ ALWAYS use theme system
Container(
  color: Theme.of(context).colorScheme.primary,
  // NOT: color: Colors.blue,
)

// ✅ ALWAYS use app text styles
Text(
  'متن',
  style: Theme.of(context).textTheme.headlineMedium,
  // NOT: style: TextStyle(fontSize: 24),
)
```

### Responsive Design
```dart
// ✅ ALWAYS implement responsive design
Widget build(BuildContext context) {
  return ResponsiveHelper.responsive(
    context,
    mobile: MobileLayout(),
    tablet: TabletLayout(),
    desktop: DesktopLayout(),
  );
}
```

### RTL Support
```dart
// ✅ ALWAYS wrap main app with Directionality
Directionality(
  textDirection: TextDirection.rtl,
  child: MaterialApp(...),
)
```

## 🔒 Authentication & Routing Rules

### Authentication-Based Routing
```dart
// ✅ ALWAYS use AuthWrapper for routing decisions
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthResult>(
      future: AuthService.checkAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.data?.isLoggedIn != true) {
          return LoginScreen();
        }
        
        switch (snapshot.data!.userRole) {
          case UserRole.admin:
            return AdminDashboardScreen();
          case UserRole.customer:
            return CustomerAppScreen();
          default:
            return LoginScreen();
        }
      },
    );
  }
}
```

### Route Protection
```dart
// ✅ ALWAYS protect routes with AuthGuard
class AuthGuard extends StatelessWidget {
  final Widget child;
  final List<UserRole> allowedRoles;

  const AuthGuard({
    required this.child,
    required this.allowedRoles,
  });

  @override
  Widget build(BuildContext context) {
    // Implementation with role checking
  }
}
```

## 💾 Data Management Rules

### Model Structure
```dart
// ✅ ALWAYS follow this model pattern
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

### Repository Pattern
```dart
// ✅ ALWAYS implement repository pattern
abstract class UserRepositoryInterface {
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> getUserById(int id);
}

class UserRepository implements UserRepositoryInterface {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  // Implementation
}
```

### Use Cases
```dart
// ✅ ALWAYS create use cases for business logic
class GetUsersUseCase {
  final UserRepositoryInterface repository;

  GetUsersUseCase(this.repository);

  Future<Either<Failure, List<User>>> call() async {
    return await repository.getUsers();
  }
}
```

## 🧪 Testing Requirements

### Test Structure
```dart
// ✅ ALWAYS write tests with this structure
group('UserService', () {
  late MockUserRepository mockRepository;
  late UserService userService;

  setUp(() {
    mockRepository = MockUserRepository();
    userService = UserService(mockRepository);
  });

  test('should return users when call is successful', () async {
    // Arrange
    when(mockRepository.getUsers())
        .thenAnswer((_) async => Right(tUsers));

    // Act
    final result = await userService.getUsers();

    // Assert
    expect(result, Right(tUsers));
  });
});
```

## 🌐 Localization Rules

### Persian Support
```dart
// ✅ ALWAYS use Persian utilities
import 'package:persian_number_utility/persian_number_utility.dart';

// Convert numbers
final persianNumber = '۱۲۳'.toPersianDigit();

// Format dates
final persianDate = Jalali.now().formatter.wN;
```

### Multi-language
```dart
// ✅ ALWAYS use localization system
Text(AppLocalizations.of(context)!.welcome)
// NOT: Text('خوش آمدید')
```

## 📱 Platform-Specific Rules

### Customer App (Mobile/Tablet)
```dart
// ✅ Features for customer app
features/customer/
├── dashboard/          # Customer dashboard
├── consultation/       # Request consultation
├── ai_chat/           # AI chatbot
├── profile/           # User profile
└── notifications/     # Push notifications
```

### Admin Dashboard (Desktop/Web)
```dart
// ✅ Features for admin dashboard
features/admin/
├── dashboard/         # Admin overview
├── user_management/   # Manage users
├── consultation_management/ # Handle consultations
├── reports/          # Analytics & reports
├── settings/         # System settings
└── ai_management/    # AI configuration
```

## 🔧 Service Layer Rules

### API Service
```dart
// ✅ ALWAYS use standardized API service
class ApiService {
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
```

### Error Handling
```dart
// ✅ ALWAYS implement proper error handling
try {
  final result = await apiCall();
  return Right(result);
} on ApiException catch (e) {
  return Left(ServerFailure(e.message));
} on NetworkException catch (e) {
  return Left(NetworkFailure(e.message));
} catch (e) {
  return Left(UnknownFailure(e.toString()));
}
```

## 🎯 State Management Rules

### Provider Pattern
```dart
// ✅ ALWAYS use Provider for state management
class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<User> _users = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<User> get users => List.unmodifiable(_users);
  String? get errorMessage => _errorMessage;

  // Methods
  Future<void> loadUsers() async {
    _setLoading(true);
    try {
      final result = await _getUsersUseCase();
      _setUsers(result);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
```

## 📋 Code Quality Rules

### Documentation
```dart
/// سرویس مدیریت کاربران
/// 
/// این کلاس عملیات CRUD مربوط به کاربران را مدیریت می‌کند
/// و با API و دیتابیس محلی ارتباط برقرار می‌کند.
/// 
/// Example:
/// ```dart
/// final users = await UserService.getAllUsers();
/// ```
class UserService {
  /// دریافت تمام کاربران فعال سیستم
  /// 
  /// Returns [List<User>] در صورت موفقیت
  /// Throws [ApiException] در صورت خطا
  static Future<List<User>> getAllUsers() async {
    // Implementation
  }
}
```

### Import Organization
```dart
// ✅ ALWAYS organize imports in this order:
// 1. Dart imports
import 'dart:convert';
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// 4. Local imports
import '../../../core/core.dart';
import '../../../shared/shared.dart';
import '../models/models.dart';
```

## 🚨 CRITICAL VALIDATION RULES

### Before Creating Any File
1. ✅ Verify correct directory structure
2. ✅ Check naming conventions
3. ✅ Ensure proper imports/exports
4. ✅ Validate architecture layer compliance
5. ✅ Confirm responsive design implementation

### Before Writing Any Widget
1. ✅ Use theme system (no hardcoded colors/fonts)
2. ✅ Implement responsive behavior
3. ✅ Add proper documentation
4. ✅ Include error states and loading states
5. ✅ Ensure RTL support

### Before Creating Any Service
1. ✅ Follow repository pattern
2. ✅ Implement proper error handling
3. ✅ Add comprehensive documentation
4. ✅ Include unit tests
5. ✅ Use dependency injection

## 🎮 Development Workflow

### Feature Development Process
1. **Create Feature Structure**: Use defined directory structure
2. **Define Domain Layer**: Entities → Use Cases → Repository Interfaces
3. **Implement Data Layer**: Models → Data Sources → Repositories
4. **Build Presentation Layer**: Providers → Widgets → Screens
5. **Add Tests**: Unit → Widget → Integration
6. **Update Documentation**: Update relevant docs

### Code Review Checklist
- [ ] Follows project structure
- [ ] Proper naming conventions
- [ ] Clean architecture compliance
- [ ] Theme system usage
- [ ] Responsive design
- [ ] Error handling
- [ ] Documentation
- [ ] Tests included
- [ ] RTL support
- [ ] Performance considerations

## 🔥 EMERGENCY RULES - NEVER BREAK THESE

### 🚫 ABSOLUTELY FORBIDDEN
1. **Direct file creation in lib/ root** (except main.dart)
2. **Hardcoded UI values** (colors, sizes, texts)
3. **Business logic in presentation layer**
4. **Direct API calls from widgets**
5. **Missing error handling**
6. **Non-responsive designs**
7. **Breaking authentication flow**
8. **Mixing customer and admin features**

### ✅ ALWAYS REQUIRED
1. **Authentication check before any sensitive operation**
2. **Responsive design for all UI components**
3. **Persian/RTL support for all text**
4. **Error states for all async operations**
5. **Loading states for all data fetching**
6. **Proper documentation for all public methods**
7. **Export files for all feature modules**
8. **Clean architecture layer separation**

## 🎯 Success Metrics

Your code is successful when:
- ✅ Follows exact directory structure
- ✅ Maintains clean architecture
- ✅ Implements responsive design
- ✅ Supports RTL properly
- ✅ Handles all error cases
- ✅ Includes comprehensive documentation
- ✅ Works for both customer and admin flows
- ✅ Passes all defined validation rules

## 🚀 Final Instructions

1. **ALWAYS** reference this prompt before creating any file
2. **ALWAYS** validate your code against these rules
3. **ALWAYS** ask for clarification if unsure about structure
4. **NEVER** deviate from the defined architecture
5. **NEVER** compromise on authentication security
6. **NEVER** create non-responsive UI components

Remember: This is a professional, production-ready application. Every line of code must meet enterprise standards for security, maintainability, and user experience.

## 📞 When in Doubt

If you're unsure about:
- File placement → Check directory structure section
- Naming → Check naming conventions section
- Architecture → Check clean architecture rules
- UI → Check theme and responsive design rules
- Authentication → Check authentication rules section

**The goal is to build a robust, scalable, maintainable application that serves both customer and admin needs effectively while maintaining the highest code quality standards.**