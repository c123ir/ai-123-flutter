---
mode: create
---

# پرامپت تست‌نویسی - Smart Assistant 123

## Test Writing Prompt for Quality Assurance

---

## 🎯 هدف تست‌نویسی

هنگام نوشتن تست‌ها برای پروژه Smart Assistant 123، از این راهنما پیروی کنید تا تست‌های باکیفیت و قابل اعتماد ایجاد شوند.

---

## 🧪 انواع تست‌ها

### Unit Tests

```dart
group('تست‌های واحد UserService', () {
  test('باید کاربر جدید را با موفقیت ایجاد کند', () async {
    // Arrange - آماده‌سازی
    final user = User(
      id: 1,
      name: 'کاربر تست',
      email: 'test@example.com',
      role: 'user',
      isActive: true,
      createdAt: getCurrentPersianDate(),
      updatedAt: getCurrentPersianDate(),
    );

    // Act - اجرا
    final result = await UserService.create(user);

    // Assert - بررسی
    expect(result, isTrue);
  });

  test('باید خطای مناسب برای ایمیل نامعتبر نمایش دهد', () async {
    // Arrange
    final invalidUser = User(
      id: 2,
      name: 'کاربر نامعتبر',
      email: 'invalid-email',
      role: 'user',
      isActive: true,
      createdAt: getCurrentPersianDate(),
      updatedAt: getCurrentPersianDate(),
    );

    // Act & Assert
    expect(
      () => UserService.create(invalidUser),
      throwsA(isA<ValidationException>()),
    );
  });
});
```

### Widget Tests

```dart
group('تست‌های ویجت DashboardCard', () {
  testWidgets('باید عنوان و مقدار را صحیح نمایش دهد', (WidgetTester tester) async {
    // Arrange
    const title = 'تعداد کاربران';
    const value = '۱۲۵';
    const icon = Icons.people;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardCard(
            title: title,
            value: value,
            icon: icon,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(title), findsOneWidget);
    expect(find.text(value), findsOneWidget);
    expect(find.byIcon(icon), findsOneWidget);
  });

  testWidgets('باید به کلیک واکنش نشان دهد', (WidgetTester tester) async {
    // Arrange
    bool wasClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardCard(
            title: 'تست کلیک',
            value: '۱',
            icon: Icons.touch_app,
            onTap: () => wasClicked = true,
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.byType(DashboardCard));
    await tester.pump();

    // Assert
    expect(wasClicked, isTrue);
  });
});
```

### Integration Tests

```dart
group('تست‌های یکپارچگی جریان احراز هویت', () {
  testWidgets('جریان کامل ورود کاربر', (WidgetTester tester) async {
    // Arrange - راه‌اندازی mock services
    when(mockAuthService.login(any, any))
        .thenAnswer((_) async => AuthResult.success('test-token'));

    // Act - شبیه‌سازی جریان ورود
    await tester.pumpWidget(MyApp());

    // ورود به صفحه لاگین
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    // پر کردن فرم
    await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password_field')), 'password123');

    // کلیک ورود
    await tester.tap(find.byKey(Key('submit_button')));
    await tester.pumpAndSettle();

    // Assert - بررسی انتقال به داشبورد
    expect(find.byType(AdminDashboard), findsOneWidget);
    expect(find.text('خوش آمدید'), findsOneWidget);
  });
});
```

---

## 📝 قوانین نام‌گذاری تست‌ها

### ساختار نام تست

```dart
test('باید [عملکرد مورد انتظار] هنگام [شرایط]', () async {
  // کد تست
});
```

### مثال‌های خوب

- `'باید کاربر را با موفقیت ایجاد کند'`
- `'باید خطای ۴۰۴ را هنگام عدم وجود کاربر برگرداند'`
- `'باید لیست محصولات را مرتب‌شده نمایش دهد'`

### مثال‌های بد

- `'تست کاربر'`
- `'بررسی API'`
- `'test_user_creation'`

---

## 🔧 ابزارهای تست

### Mock Data

```dart
// test/mocks/mock_data.dart
// داده‌های تست برای شبیه‌سازی

class MockData {
  static User get sampleUser => User(
    id: 1,
    name: 'علی احمدی',
    email: 'ali@example.com',
    role: 'admin',
    isActive: true,
    createdAt: '۱۴۰۴/۰۵/۳۰',
    updatedAt: '۱۴۰۴/۰۵/۳۰',
  );

  static List<Product> get sampleProducts => [
    Product(
      id: 1,
      title: 'محصول تست ۱',
      description: 'توضیحات محصول تست',
      price: 100000,
      imageUrl: 'https://example.com/image1.jpg',
      isAvailable: true,
      categoryId: '1',
      createdAt: '۱۴۰۴/۰۵/۳۰',
      updatedAt: '۱۴۰۴/۰۵/۳۰',
    ),
  ];
}
```

### Test Helpers

```dart
// test/helpers/test_helpers.dart
// توابع کمکی برای تست‌ها

class TestHelpers {
  /// ایجاد MaterialApp برای تست ویجت‌ها
  static Widget wrapWidget(Widget widget) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('fa', 'IR')],
      home: Scaffold(body: widget),
    );
  }

  /// انتظار برای اتمام انیمیشن‌ها
  static Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle(Duration(seconds: 2));
  }

  /// شبیه‌سازی کلیک با انتظار
  static Future<void> tapAndSettle(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
```

---

## 🎯 راهنمای تست‌نویسی

### Arrange-Act-Assert Pattern

```dart
test('توضیح تست', () async {
  // Arrange - آماده‌سازی داده‌ها و محیط
  final inputData = createTestData();

  // Act - اجرای عملیات مورد تست
  final result = await serviceUnderTest.performAction(inputData);

  // Assert - بررسی نتایج
  expect(result.isSuccess, isTrue);
  expect(result.data, isNotNull);
});
```

### تست خطاها

```dart
test('باید خطای مناسب برای ورودی نامعتبر تولید کند', () async {
  // Arrange
  final invalidInput = '';

  // Act & Assert
  expect(
    () => service.processInput(invalidInput),
    throwsA(isA<InvalidInputException>()),
  );
});
```

### تست Async Operations

```dart
test('باید داده‌ها را به‌صورت async دریافت کند', () async {
  // Arrange
  when(mockApiService.getData()).thenAnswer(
    (_) async => Future.delayed(Duration(seconds: 1), () => mockData),
  );

  // Act
  final result = await dataService.fetchData();

  // Assert
  expect(result, equals(mockData));
  verify(mockApiService.getData()).called(1);
});
```

---

## ⚡ بهترین روش‌ها

### سازماندهی تست‌ها

```
test/
├── unit/               # تست‌های واحد
│   ├── models/
│   ├── services/
│   └── utils/
├── widget/             # تست‌های ویجت
│   ├── screens/
│   └── widgets/
├── integration/        # تست‌های یکپارچگی
├── mocks/             # Mock classes
├── helpers/           # توابع کمکی
└── fixtures/          # داده‌های ثابت تست
```

### تست Performance

```dart
test('باید در کمتر از ۵۰۰ میلی‌ثانیه اجرا شود', () async {
  final stopwatch = Stopwatch()..start();

  await serviceUnderTest.heavyOperation();

  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(500));
});
```

### تست Memory Leaks

```dart
testWidgets('باید منابع را به درستی آزاد کند', (WidgetTester tester) async {
  await tester.pumpWidget(TestHelpers.wrapWidget(MyStatefulWidget()));

  // شبیه‌سازی dispose
  await tester.pumpWidget(Container());

  // بررسی آزادسازی منابع
  expect(MyStatefulWidget.instanceCount, equals(0));
});
```

---

## 🚨 نکات مهم

### چه چیزی را تست کنیم

- ✅ منطق کسب‌وکار
- ✅ مدیریت خطاها
- ✅ تعامل با API
- ✅ UI flows
- ✅ Edge cases

### چه چیزی را تست نکنیم

- ❌ Third-party libraries
- ❌ Framework code
- ❌ Simple getters/setters
- ❌ Private methods مستقیماً

### تست مستقل

هر تست باید:

- مستقل از سایر تست‌ها باشد
- منابع خود را تمیز کند
- نتیجه قابل پیش‌بینی داشته باشد

---

**یادآوری:** تست‌های خوب باعث اعتماد در refactoring و توسعه آینده می‌شوند.
