---
applyTo: "lib_new/features/**"
---

# Feature Development Instructions - توسعه ویژگی‌ها

## 🎯 قوانین توسعه Feature

### 📂 ساختار اجباری هر Feature

```
features/{feature_type}/{feature_name}/
├── data/
│   ├── models/           # مدل‌های داده + JSON serialization
│   ├── repositories/     # پیاده‌سازی repository ها
│   ├── datasources/      # منابع داده (API, SQLite, etc.)
│   └── data.dart        # Export file
├── domain/
│   ├── entities/         # موجودیت‌های کسب‌وکار
│   ├── usecases/         # منطق کسب‌وکار
│   ├── repositories/     # interface های repository
│   └── domain.dart      # Export file
├── presentation/
│   ├── screens/          # صفحات UI
│   ├── widgets/          # کامپوننت‌های UI
│   ├── providers/        # مدیریت state
│   └── presentation.dart # Export file
└── {feature_name}.dart  # Main export file
```

## 🔐 Feature Types

### Customer Features (`features/customer/`)

- `dashboard/` - داشبورد مشتری
- `consultation/` - درخواست مشاوره
- `ai_chat/` - چت با هوش مصنوعی
- `profile/` - مدیریت پروفایل
- `notifications/` - اعلانات

### Admin Features (`features/admin/`)

- `dashboard/` - داشبورد مدیریت
- `user_management/` - مدیریت کاربران
- `reports/` - گزارش‌ها و آمار
- `settings/` - تنظیمات سیستم
- `sms_management/` - مدیریت پیامک

### Shared Features (`features/auth/`)

- `auth/` - احراز هویت (مشترک)

## 📝 Template های الزامی

### Entity Template

```dart
// domain/entities/{entity_name}_entity.dart
import 'package:equatable/equatable.dart';

/// موجودیت {EntityName}
///
/// نمایش {EntityName} در لایه domain
abstract class {EntityName}Entity extends Equatable {
  final int id;
  final String name;
  final DateTime createdAt;

  const {EntityName}Entity({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, createdAt];
}
```

### Model Template

```dart
// data/models/{entity_name}_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/{entity_name}_entity.dart';

part '{entity_name}_model.g.dart';

/// مدل {EntityName} برای لایه داده
///
/// تبدیل داده‌های API به فرمت قابل استفاده در domain
@JsonSerializable()
class {EntityName}Model extends {EntityName}Entity {
  const {EntityName}Model({
    required super.id,
    required super.name,
    required super.createdAt,
  });

  factory {EntityName}Model.fromJson(Map<String, dynamic> json) =>
      _${EntityName}ModelFromJson(json);

  Map<String, dynamic> toJson() => _${EntityName}ModelToJson(this);

  /// تبدیل به Entity
  {EntityName}Entity toEntity() {
    return {EntityName}Entity(
      id: id,
      name: name,
      createdAt: createdAt,
    );
  }
}
```

### UseCase Template

```dart
// domain/usecases/get_{entity_name}_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../entities/{entity_name}_entity.dart';
import '../repositories/{entity_name}_repository_interface.dart';

/// Use case برای دریافت {EntityName}
///
/// مسئول اجرای منطق کسب‌وکار مربوط به دریافت {EntityName}
class Get{EntityName}UseCase {
  final {EntityName}RepositoryInterface repository;

  Get{EntityName}UseCase(this.repository);

  Future<Either<Failure, List<{EntityName}Entity>>> call() async {
    try {
      return await repository.get{EntityName}s();
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

### Repository Interface Template

```dart
// domain/repositories/{entity_name}_repository_interface.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../entities/{entity_name}_entity.dart';

/// رابط Repository برای {EntityName}
///
/// تعریف عملیات CRUD برای {EntityName}
abstract class {EntityName}RepositoryInterface {
  Future<Either<Failure, List<{EntityName}Entity>>> get{EntityName}s();
  Future<Either<Failure, {EntityName}Entity>> get{EntityName}ById(int id);
  Future<Either<Failure, {EntityName}Entity>> create{EntityName}({EntityName}Entity entity);
  Future<Either<Failure, {EntityName}Entity>> update{EntityName}({EntityName}Entity entity);
  Future<Either<Failure, void>> delete{EntityName}(int id);
}
```

### Repository Implementation Template

```dart
// data/repositories/{entity_name}_repository.dart
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';
import '../../domain/entities/{entity_name}_entity.dart';
import '../../domain/repositories/{entity_name}_repository_interface.dart';
import '../datasources/{entity_name}_local_datasource.dart';
import '../datasources/{entity_name}_remote_datasource.dart';

/// پیاده‌سازی Repository برای {EntityName}
class {EntityName}Repository implements {EntityName}RepositoryInterface {
  final {EntityName}RemoteDataSource remoteDataSource;
  final {EntityName}LocalDataSource localDataSource;

  {EntityName}Repository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<{EntityName}Entity>>> get{EntityName}s() async {
    try {
      final models = await remoteDataSource.get{EntityName}s();
      final entities = models.map((model) => model.toEntity()).toList();

      // Cache locally
      await localDataSource.cache{EntityName}s(models);

      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try to get from local cache
      try {
        final cachedModels = await localDataSource.getCached{EntityName}s();
        final entities = cachedModels.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (_) {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // سایر متدها...
}
```

### Screen Template

```dart
// presentation/screens/{screen_name}_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../providers/{feature_name}_provider.dart';
import '../widgets/widgets.dart';

/// صفحه {ScreenName}
///
/// نمایش {توضیح صفحه}
class {ScreenName}Screen extends StatefulWidget {
  const {ScreenName}Screen({super.key});

  @override
  State<{ScreenName}Screen> createState() => _{ScreenName}ScreenState();
}

class _{ScreenName}ScreenState extends State<{ScreenName}Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<{Feature}Provider>().load{Entities}();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{صفحه title}'),
      ),
      body: Consumer<{Feature}Provider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'خطا: ${provider.errorMessage}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.load{Entities}(),
                    child: const Text('تلاش مجدد'),
                  ),
                ],
              ),
            );
          }

          return _buildContent(provider);
        },
      ),
    );
  }

  Widget _buildContent({Feature}Provider provider) {
    return ResponsiveHelper.responsive(
      context,
      mobile: _buildMobileLayout(provider),
      tablet: _buildTabletLayout(provider),
      desktop: _buildDesktopLayout(provider),
    );
  }

  Widget _buildMobileLayout({Feature}Provider provider) {
    // Mobile implementation
    return ListView.builder(
      itemCount: provider.{entities}.length,
      itemBuilder: (context, index) {
        return {Entity}Card(entity: provider.{entities}[index]);
      },
    );
  }

  Widget _buildTabletLayout({Feature}Provider provider) {
    // Tablet implementation
    return _buildMobileLayout(provider);
  }

  Widget _buildDesktopLayout({Feature}Provider provider) {
    // Desktop implementation
    return _buildMobileLayout(provider);
  }
}
```

### Provider Template

```dart
// presentation/providers/{feature_name}_provider.dart
import 'package:flutter/foundation.dart';

import '../../domain/entities/{entity_name}_entity.dart';
import '../../domain/usecases/get_{entity_name}_usecase.dart';
import '../../../../core/errors/failures.dart';

/// Provider برای مدیریت state {FeatureName}
class {Feature}Provider extends ChangeNotifier {
  final Get{Entity}UseCase _get{Entity}UseCase;

  {Feature}Provider({
    required Get{Entity}UseCase get{Entity}UseCase,
  }) : _get{Entity}UseCase = get{Entity}UseCase;

  // State variables
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  List<{Entity}Entity> _{entities} = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  List<{Entity}Entity> get {entities} => List.unmodifiable(_{entities});

  /// بارگذاری {entities}
  Future<void> load{Entities}() async {
    _setLoading(true);

    try {
      final result = await _get{Entity}UseCase();

      result.fold(
        (failure) => _setError(_mapFailureToMessage(failure)),
        (entities) => _set{Entities}(entities),
      );
    } catch (e) {
      _setError('خطای غیرمنتظره: ${e.toString()}');
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'خطا در ارتباط با سرور';
      case NetworkFailure:
        return 'خطا در اتصال شبکه';
      case CacheFailure:
        return 'خطا در ذخیره‌سازی محلی';
      default:
        return 'خطای نامشخص';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void _set{Entities}(List<{Entity}Entity> entities) {
    _{entities} = entities;
    _hasError = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
```

## 📋 Export Files الزامی

### Feature Main Export

```dart
// {feature_name}.dart
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
```

### Layer Export Files

```dart
// data/data.dart
export 'models/models.dart';
export 'repositories/repositories.dart';
export 'datasources/datasources.dart';

// domain/domain.dart
export 'entities/entities.dart';
export 'usecases/usecases.dart';
export 'repositories/repositories.dart';

// presentation/presentation.dart
export 'screens/screens.dart';
export 'widgets/widgets.dart';
export 'providers/providers.dart';
```

## 🔍 Validation Rules

### قبل از ایجاد هر Feature:

1. ✅ تعیین feature type (customer/admin/shared)
2. ✅ ایجاد ساختار کامل پوشه‌ها
3. ✅ شروع از domain layer (entities → usecases)
4. ✅ پیاده‌سازی data layer (models → repositories)
5. ✅ ایجاد presentation layer (providers → widgets → screens)
6. ✅ ایجاد export files
7. ✅ نوشتن tests

### قبل از commit:

- [ ] Clean architecture رعایت شده
- [ ] Export files ایجاد شده
- [ ] Error handling پیاده شده
- [ ] Responsive design اعمال شده
- [ ] RTL support اضافه شده
- [ ] Documentation نوشته شده
- [ ] Tests نوشته شده

## 🎯 نکات مهم

1. **هرگز business logic در presentation قرار ندهید**
2. **همیشه از dependency injection استفاده کنید**
3. **خطاها را به درستی مدیریت کنید**
4. **responsive design را فراموش نکنید**
5. **RTL support اجباری است**
6. **Documentation کامل بنویسید**
