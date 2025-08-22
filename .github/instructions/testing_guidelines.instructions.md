---
applyTo: "test_new/**"
---

# Testing Guidelines - راهنمای تست

## 🎯 استراتژی تست

تست شامل سه سطح اصلی:

1. **Unit Tests** - تست واحدهای کوچک کد
2. **Widget Tests** - تست کامپوننت‌های UI
3. **Integration Tests** - تست کل سیستم

## 📂 ساختار الزامی

```
test_new/
├── unit/                    # تست‌های واحد
│   ├── features/           # تست features
│   │   ├── auth/
│   │   ├── customer/
│   │   └── admin/
│   ├── shared/             # تست shared components
│   ├── core/               # تست core services
│   └── unit_test.dart      # Export file
├── widget/                 # تست‌های widget
│   ├── features/
│   ├── shared/
│   └── widget_test.dart    # Export file
├── integration/            # تست‌های یکپارچه
│   ├── auth_flow_test.dart
│   ├── customer_flow_test.dart
│   ├── admin_flow_test.dart
│   └── integration_test.dart # Export file
├── mocks/                  # Mock objects
│   ├── mock_services.dart
│   ├── mock_repositories.dart
│   └── mocks.dart          # Export file
├── fixtures/               # داده‌های تست
│   ├── user_fixture.dart
│   ├── api_response_fixture.dart
│   └── fixtures.dart       # Export file
└── helpers/                # کمکی‌های تست
    ├── test_helpers.dart
    ├── widget_test_helpers.dart
    └── helpers.dart        # Export file
```

## 🧪 Unit Test Templates

### Repository Test Template

```dart
// unit/features/auth/data/repositories/auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ai_123/features/auth/auth.dart';
import 'package:ai_123/core/core.dart';
import '../../../mocks/mocks.dart';
import '../../../fixtures/fixtures.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;
    late MockAuthRemoteDataSource mockRemoteDataSource;
    late MockAuthLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockAuthRemoteDataSource();
      mockLocalDataSource = MockAuthLocalDataSource();
      repository = AuthRepository(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    group('login', () {
      const tEmail = 'test@example.com';
      const tPassword = 'password123';
      final tUserModel = UserFixture.userModel;
      final tUserEntity = UserFixture.userEntity;

      test('should return UserEntity when login is successful', () async {
        // Arrange
        when(mockRemoteDataSource.login(any, any))
            .thenAnswer((_) async => tUserModel);
        when(mockLocalDataSource.cacheUser(any))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.login(tEmail, tPassword);

        // Assert
        expect(result, Right(tUserEntity));
        verify(mockRemoteDataSource.login(tEmail, tPassword));
        verify(mockLocalDataSource.cacheUser(tUserModel));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return ServerFailure when remote call fails', () async {
        // Arrange
        when(mockRemoteDataSource.login(any, any))
            .thenThrow(ServerException('Server error'));

        // Act
        final result = await repository.login(tEmail, tPassword);

        // Assert
        expect(result, Left(ServerFailure('Server error')));
        verify(mockRemoteDataSource.login(tEmail, tPassword));
        verifyZeroInteractions(mockLocalDataSource);
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        when(mockRemoteDataSource.login(any, any))
            .thenThrow(NetworkException('Network error'));

        // Act
        final result = await repository.login(tEmail, tPassword);

        // Assert
        expect(result, Left(NetworkFailure('Network error')));
        verify(mockRemoteDataSource.login(tEmail, tPassword));
        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('logout', () {
      test('should clear local data when logout is called', () async {
        // Arrange
        when(mockRemoteDataSource.logout())
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.clearUserData())
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.logout();

        // Assert
        expect(result, const Right(null));
        verify(mockRemoteDataSource.logout());
        verify(mockLocalDataSource.clearUserData());
      });
    });
  });
}
```

### UseCase Test Template

```dart
// unit/features/auth/domain/usecases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ai_123/features/auth/auth.dart';
import 'package:ai_123/core/core.dart';
import '../../../mocks/mocks.dart';
import '../../../fixtures/fixtures.dart';

void main() {
  group('LoginUseCase', () {
    late LoginUseCase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = LoginUseCase(mockRepository);
    });

    final tUser = UserFixture.userEntity;
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('should get user from repository when credentials are valid', () async {
      // Arrange
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Right(tUser));

      // Act
      final result = await usecase(LoginParams(
        email: tEmail,
        password: tPassword,
      ));

      // Assert
      expect(result, Right(tUser));
      verify(mockRepository.login(tEmail, tPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const tFailure = ServerFailure('Server error');
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(LoginParams(
        email: tEmail,
        password: tPassword,
      ));

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.login(tEmail, tPassword));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
```

### Service Test Template

```dart
// unit/core/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:ai_123/core/core.dart';
import '../../mocks/mocks.dart';
import '../../fixtures/fixtures.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockApiClient mockApiClient;
    late MockSecureStorage mockSecureStorage;

    setUp(() {
      mockApiClient = MockApiClient();
      mockSecureStorage = MockSecureStorage();
      authService = AuthService(
        apiClient: mockApiClient,
        secureStorage: mockSecureStorage,
      );
    });

    group('login', () {
      const tEmail = 'test@example.com';
      const tPassword = 'password123';
      const tToken = 'test_token';
      final tApiResponse = ApiResponseFixture.authResponse;

      test('should return AuthResult when login is successful', () async {
        // Arrange
        when(mockApiClient.post(any, body: anyNamed('body')))
            .thenAnswer((_) async => tApiResponse);
        when(mockSecureStorage.write(any, any))
            .thenAnswer((_) async => {});

        // Act
        final result = await authService.login(tEmail, tPassword);

        // Assert
        expect(result.token, tToken);
        expect(result.user.email, tEmail);
        verify(mockApiClient.post(
          ApiEndpoints.login,
          body: {'email': tEmail, 'password': tPassword},
        ));
        verify(mockSecureStorage.write('auth_token', tToken));
        verify(mockApiClient.setAuthToken(tToken));
      });

      test('should throw AuthException when API call fails', () async {
        // Arrange
        when(mockApiClient.post(any, body: anyNamed('body')))
            .thenThrow(ServerException('Server error'));

        // Act & Assert
        expect(
          () => authService.login(tEmail, tPassword),
          throwsA(isA<AuthException>()),
        );
      });
    });
  });
}
```

## 🎨 Widget Test Templates

### Screen Test Template

```dart
// widget/features/auth/presentation/screens/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import 'package:ai_123/features/auth/auth.dart';
import '../../../helpers/helpers.dart';
import '../../../mocks/mocks.dart';

void main() {
  group('LoginScreen', () {
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
    });

    Widget createWidgetUnderTest() {
      return TestApp(
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const LoginScreen(),
        ),
      );
    }

    testWidgets('should display email and password fields', (tester) async {
      // Arrange
      when(mockAuthProvider.isLoading).thenReturn(false);
      when(mockAuthProvider.hasError).thenReturn(false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('ایمیل'), findsOneWidget);
      expect(find.text('رمز عبور'), findsOneWidget);
    });

    testWidgets('should display login button', (tester) async {
      // Arrange
      when(mockAuthProvider.isLoading).thenReturn(false);
      when(mockAuthProvider.hasError).thenReturn(false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('ورود'), findsOneWidget);
    });

    testWidgets('should show loading when isLoading is true', (tester) async {
      // Arrange
      when(mockAuthProvider.isLoading).thenReturn(true);
      when(mockAuthProvider.hasError).thenReturn(false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when hasError is true', (tester) async {
      // Arrange
      when(mockAuthProvider.isLoading).thenReturn(false);
      when(mockAuthProvider.hasError).thenReturn(true);
      when(mockAuthProvider.errorMessage).thenReturn('خطای تست');

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('خطای تست'), findsOneWidget);
    });

    testWidgets('should call login when form is submitted', (tester) async {
      // Arrange
      when(mockAuthProvider.isLoading).thenReturn(false);
      when(mockAuthProvider.hasError).thenReturn(false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockAuthProvider.login('test@example.com', 'password123'));
    });
  });
}
```

### Widget Component Test Template

```dart
// widget/shared/widgets/buttons/custom_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_123/shared/shared.dart';
import '../../../helpers/helpers.dart';

void main() {
  group('CustomButton', () {
    testWidgets('should display text correctly', (tester) async {
      // Act
      await tester.pumpWidget(
        TestApp(
          child: CustomButton(
            text: 'Test Button',
            onPressed: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should display icon when provided', (tester) async {
      // Act
      await tester.pumpWidget(
        TestApp(
          child: CustomButton(
            text: 'Test Button',
            icon: Icons.add,
            onPressed: () {},
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true', (tester) async {
      // Act
      await tester.pumpWidget(
        TestApp(
          child: CustomButton(
            text: 'Test Button',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      // Act
      await tester.pumpWidget(
        TestApp(
          child: CustomButton(
            text: 'Test Button',
            onPressed: null,
          ),
        ),
      );

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      bool wasCalled = false;

      // Act
      await tester.pumpWidget(
        TestApp(
          child: CustomButton(
            text: 'Test Button',
            onPressed: () => wasCalled = true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));

      // Assert
      expect(wasCalled, isTrue);
    });
  });
}
```

## 🔧 Integration Test Template

```dart
// integration/auth_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ai_123/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('complete login flow should work', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Should show login screen initially
      expect(find.text('ورود'), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byType(TextFormField).first,
        'admin@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should navigate to dashboard
      expect(find.text('داشبورد'), findsOneWidget);
    });

    testWidgets('logout flow should work', (tester) async {
      // Assuming user is already logged in
      app.main();
      await tester.pumpAndSettle();

      // Find and tap logout button
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Should show confirmation dialog
      expect(find.text('خروج از حساب'), findsOneWidget);

      // Confirm logout
      await tester.tap(find.text('تایید'));
      await tester.pumpAndSettle();

      // Should return to login screen
      expect(find.text('ورود'), findsOneWidget);
    });
  });
}
```

## 🎭 Mock Templates

### Mock Services

```dart
// mocks/mock_services.dart
import 'package:mockito/mockito.dart';
import 'package:ai_123/core/core.dart';

class MockAuthService extends Mock implements AuthService {}
class MockApiClient extends Mock implements ApiClient {}
class MockSecureStorage extends Mock implements SecureStorage {}
class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockNotificationService extends Mock implements NotificationService {}
```

### Mock Repositories

```dart
// mocks/mock_repositories.dart
import 'package:mockito/mockito.dart';
import 'package:ai_123/features/auth/auth.dart';

class MockAuthRepository extends Mock implements AuthRepositoryInterface {}
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
```

## 📋 Test Helpers

### Test App Wrapper

```dart
// helpers/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Wrapper برای تست‌های widget
class TestApp extends StatelessWidget {
  final Widget child;
  final ThemeData? theme;

  const TestApp({
    super.key,
    required this.child,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
      theme: theme ?? ThemeData.light(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
    );
  }
}
```

## 📊 Test Coverage Rules

### Coverage Targets:

- **Unit Tests**: >90%
- **Widget Tests**: >80%
- **Integration Tests**: Major flows

### قبل از commit:

- [ ] همه تست‌ها سبز
- [ ] Coverage requirements برآورده شده
- [ ] Integration tests اجرا شده
- [ ] Performance tests پاس شده

## 🎯 نکات مهم

1. **AAA Pattern**: Arrange, Act, Assert
2. **Descriptive names**: نام‌های واضح برای تست‌ها
3. **One assertion per test**: هر تست یک چیز را بررسی کند
4. **Mock external dependencies**: وابستگی‌های خارجی را mock کنید
5. **Test edge cases**: موارد استثنایی را تست کنید
6. **Keep tests fast**: تست‌ها باید سریع باشند
