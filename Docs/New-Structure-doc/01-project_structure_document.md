# ساختار استاندارد پروژه دستیار هوشمند یک دو سه

## 📋 مقدمه

این مستند ساختار استاندارد و حرفه‌ای فایل‌ها و پوشه‌ها برای پروژه "دستیار هوشمند یک دو سه" را تعریف می‌کند. با توجه به دوگانه بودن این اپلیکیشن (Customer App + Admin Dashboard)، ساختاری طراحی شده که هم جداسازی مناسب و هم اشتراک‌گذاری کد را ممکن می‌سازد.

## 🏗️ ساختار کلی پروژه

```
ai_123/
├── 📁 lib/                          # کد اصلی Dart
│   ├── 📁 app/                      # هسته اصلی اپلیکیشن
│   ├── 📁 shared/                   # کامپوننت‌های مشترک
│   ├── 📁 features/                 # ویژگی‌های اصلی (Feature-based)
│   ├── 📁 core/                     # سرویس‌ها و utilities اساسی
│   └── main.dart                    # Entry point
├── 📁 test/                         # تست‌ها
├── 📁 integration_test/             # تست‌های یکپارچه‌سازی
├── 📁 assets/                       # فایل‌های استاتیک
├── 📁 docs/                         # مستندات
├── 📁 scripts/                      # اسکریپت‌های خودکارسازی
├── 📁 .github/                      # GitHub configs و workflows
└── 📁 tools/                        # ابزارهای توسعه
```

## 📂 ساختار تفصیلی lib/

### 🎯 app/ - هسته اصلی اپلیکیشن

```
lib/app/
├── 📄 app.dart                      # تعریف MyApp
├── 📄 app_router.dart               # مدیریت routing اصلی
├── 📄 app_config.dart               # تنظیمات کلی اپ
└── 📁 theme/                        # تم و استایل
    ├── 📄 app_theme.dart           # تعریف theme‌های اصلی
    ├── 📄 app_colors.dart          # رنگ‌بندی
    ├── 📄 app_text_styles.dart     # استایل متن‌ها
    ├── 📄 app_dimensions.dart      # ابعاد و spacing
    └── 📄 theme.dart               # Export file
```

### 🔗 shared/ - کامپوننت‌های مشترک

```
lib/shared/
├── 📁 widgets/                      # Widget‌های مشترک
│   ├── 📁 buttons/
│   │   ├── 📄 custom_button.dart
│   │   ├── 📄 icon_button.dart
│   │   └── 📄 buttons.dart         # Export file
│   ├── 📁 forms/
│   │   ├── 📄 custom_text_field.dart
│   │   ├── 📄 dropdown_field.dart
│   │   ├── 📄 date_picker_field.dart
│   │   └── 📄 forms.dart           # Export file
│   ├── 📁 dialogs/
│   │   ├── 📄 confirmation_dialog.dart
│   │   ├── 📄 info_dialog.dart
│   │   └── 📄 dialogs.dart         # Export file
│   ├── 📁 layout/
│   │   ├── 📄 responsive_layout.dart
│   │   ├── 📄 loading_overlay.dart
│   │   └── 📄 layout.dart          # Export file
│   └── 📄 widgets.dart             # Main export file
├── 📁 utils/                        # کمکی‌های مشترک
│   ├── 📄 validators.dart          # اعتبارسنجی فرم‌ها
│   ├── 📄 formatters.dart          # فرمت کننده‌ها
│   ├── 📄 extensions.dart          # Extension methods
│   ├── 📄 constants.dart           # ثابت‌های مشترک
│   ├── 📄 helpers.dart             # توابع کمکی
│   └── 📄 utils.dart               # Export file
└── 📁 models/                       # مدل‌های مشترک
    ├── 📄 api_response.dart        # پاسخ API استاندارد
    ├── 📄 error_model.dart         # مدل خطاها
    ├── 📄 pagination_model.dart    # صفحه‌بندی
    └── 📄 models.dart              # Export file
```

### 🎨 features/ - ویژگی‌های اصلی (Feature-Based Architecture)

```
lib/features/
├── 📁 auth/                         # احراز هویت
│   ├── 📁 data/
│   │   ├── 📁 models/
│   │   │   ├── 📄 user.dart
│   │   │   ├── 📄 auth_result.dart
│   │   │   └── 📄 models.dart
│   │   ├── 📁 repositories/
│   │   │   ├── 📄 auth_repository.dart
│   │   │   └── 📄 repositories.dart
│   │   └── 📁 datasources/
│   │       ├── 📄 auth_local_datasource.dart
│   │       ├── 📄 auth_remote_datasource.dart
│   │       └── 📄 datasources.dart
│   ├── 📁 domain/
│   │   ├── 📁 entities/
│   │   │   ├── 📄 user_entity.dart
│   │   │   └── 📄 entities.dart
│   │   ├── 📁 usecases/
│   │   │   ├── 📄 login_usecase.dart
│   │   │   ├── 📄 logout_usecase.dart
│   │   │   ├── 📄 check_auth_usecase.dart
│   │   │   └── 📄 usecases.dart
│   │   └── 📁 repositories/
│   │       └── 📄 auth_repository_interface.dart
│   ├── 📁 presentation/
│   │   ├── 📁 screens/
│   │   │   ├── 📄 login_screen.dart
│   │   │   ├── 📄 forgot_password_screen.dart
│   │   │   └── 📄 screens.dart
│   │   ├── 📁 widgets/
│   │   │   ├── 📄 login_form.dart
│   │   │   ├── 📄 auth_loading.dart
│   │   │   └── 📄 widgets.dart
│   │   └── 📁 providers/ (یا blocs/)
│   │       ├── 📄 auth_provider.dart
│   │       └── 📄 providers.dart
│   └── 📄 auth.dart                # Main export file
├── 📁 customer/                     # ویژگی‌های مشتری
│   ├── 📁 dashboard/
│   │   ├── 📁 data/
│   │   │   ├── 📁 models/
│   │   │   ├── 📁 repositories/
│   │   │   └── 📁 datasources/
│   │   ├── 📁 domain/
│   │   │   ├── 📁 entities/
│   │   │   ├── 📁 usecases/
│   │   │   └── 📁 repositories/
│   │   ├── 📁 presentation/
│   │   │   ├── 📁 screens/
│   │   │   │   ├── 📄 customer_dashboard_screen.dart
│   │   │   │   └── 📄 screens.dart
│   │   │   ├── 📁 widgets/
│   │   │   │   ├── 📄 dashboard_card.dart
│   │   │   │   ├── 📄 quick_actions.dart
│   │   │   │   └── 📄 widgets.dart
│   │   │   └── 📁 providers/
│   │   │       ├── 📄 dashboard_provider.dart
│   │   │       └── 📄 providers.dart
│   │   └── 📄 dashboard.dart
│   ├── 📁 consultation/
│   │   ├── 📁 data/
│   │   │   ├── 📁 models/
│   │   │   │   ├── 📄 consultation.dart
│   │   │   │   ├── 📄 consultation_request.dart
│   │   │   │   └── 📄 models.dart
│   │   │   ├── 📁 repositories/
│   │   │   └── 📁 datasources/
│   │   ├── 📁 domain/
│   │   ├── 📁 presentation/
│   │   │   ├── 📁 screens/
│   │   │   │   ├── 📄 consultation_list_screen.dart
│   │   │   │   ├── 📄 new_consultation_screen.dart
│   │   │   │   └── 📄 screens.dart
│   │   │   ├── 📁 widgets/
│   │   │   └── 📁 providers/
│   │   └── 📄 consultation.dart
│   ├── 📁 ai_chat/
│   │   ├── 📁 data/
│   │   ├── 📁 domain/
│   │   ├── 📁 presentation/
│   │   │   ├── 📁 screens/
│   │   │   │   ├── 📄 ai_chat_screen.dart
│   │   │   │   └── 📄 screens.dart
│   │   │   ├── 📁 widgets/
│   │   │   │   ├── 📄 chat_bubble.dart
│   │   │   │   ├── 📄 chat_input.dart
│   │   │   │   └── 📄 widgets.dart
│   │   │   └── 📁 providers/
│   │   └── 📄 ai_chat.dart
│   └── 📄 customer.dart            # Main export file
├── 📁 admin/                        # ویژگی‌های مدیریت
│   ├── 📁 dashboard/
│   │   ├── 📁 data/
│   │   ├── 📁 domain/
│   │   ├── 📁 presentation/
│   │   │   ├── 📁 screens/
│   │   │   │   ├── 📄 admin_dashboard_screen.dart
│   │   │   │   └── 📄 screens.dart
│   │   │   ├── 📁 widgets/
│   │   │   │   ├── 📄 admin_sidebar.dart
│   │   │   │   ├── 📄 stats_card.dart
│   │   │   │   ├── 📄 admin_chart.dart
│   │   │   │   └── 📄 widgets.dart
│   │   │   └── 📁 providers/
│   │   └── 📄 dashboard.dart
│   ├── 📁 user_management/
│   │   ├── 📁 data/
│   │   ├── 📁 domain/
│   │   ├── 📁 presentation/
│   │   │   ├── 📁 screens/
│   │   │   │   ├── 📄 users_list_screen.dart
│   │   │   │   ├── 📄 user_details_screen.dart
│   │   │   │   ├── 📄 add_edit_user_screen.dart
│   │   │   │   └── 📄 screens.dart
│   │   │   ├── 📁 widgets/
│   │   │   │   ├── 📄 user_data_table.dart
│   │   │   │   ├── 📄 user_form.dart
│   │   │   │   └── 📄 widgets.dart
│   │   │   └── 📁 providers/
│   │   └── 📄 user_management.dart
│   ├── 📁 reports/
│   │   ├── 📁 data/
│   │   ├── 📁 domain/
│   │   ├── 📁 presentation/
│   │   │   ├── 📁 screens/
│   │   │   │   ├── 📄 reports_screen.dart
│   │   │   │   ├── 📄 analytics_screen.dart
│   │   │   │   └── 📄 screens.dart
│   │   │   ├── 📁 widgets/
│   │   │   │   ├── 📄 report_chart.dart
│   │   │   │   ├── 📄 export_button.dart
│   │   │   │   └── 📄 widgets.dart
│   │   │   └── 📁 providers/
│   │   └── 📄 reports.dart
│   ├── 📁 settings/
│   │   ├── 📁 data/
│   │   ├── 📁 domain/
│   │   ├── 📁 presentation/
│   │   │   ├── 📁 screens/
│   │   │   │   ├── 📄 system_settings_screen.dart
│   │   │   │   ├── 📄 sms_settings_screen.dart
│   │   │   │   └── 📄 screens.dart
│   │   │   ├── 📁 widgets/
│   │   │   └── 📁 providers/
│   │   └── 📄 settings.dart
│   └── 📄 admin.dart               # Main export file
└── 📄 features.dart                # Main export file
```

### ⚙️ core/ - سرویس‌ها و utilities اساسی

```
lib/core/
├── 📁 network/                      # شبکه و API
│   ├── 📄 api_client.dart          # HTTP client اصلی
│   ├── 📄 api_endpoints.dart       # URL endpoints
│   ├── 📄 api_interceptors.dart    # Request/Response interceptors
│   ├── 📄 network_info.dart        # بررسی اتصال شبکه
│   └── 📄 network.dart             # Export file
├── 📁 database/                     # پایگاه داده
│   ├── 📄 database_helper.dart     # SQLite helper
│   ├── 📄 database_tables.dart     # تعریف جداول
│   ├── 📄 database_migrations.dart # Migration ها
│   └── 📄 database.dart            # Export file
├── 📁 storage/                      # ذخیره‌سازی محلی
│   ├── 📄 secure_storage.dart      # ذخیره امن (token ها)
│   ├── 📄 shared_preferences.dart  # تنظیمات کاربر
│   ├── 📄 file_storage.dart        # فایل‌های محلی
│   └── 📄 storage.dart             # Export file
├── 📁 services/                     # سرویس‌های اصلی
│   ├── 📄 auth_service.dart        # احراز هویت
│   ├── 📄 notification_service.dart # اعلان‌ها
│   ├── 📄 analytics_service.dart   # آنالیتیکس
│   ├── 📄 logging_service.dart     # لاگ‌گیری
│   ├── 📄 crash_service.dart       # مدیریت کرش
│   └── 📄 services.dart            # Export file
├── 📁 errors/                       # مدیریت خطاها
│   ├── 📄 exceptions.dart          # استثناهای سفارشی
│   ├── 📄 failures.dart            # مدل‌های شکست
│   ├── 📄 error_handler.dart       # مدیریت خطاها
│   └── 📄 errors.dart              # Export file
├── 📁 localization/                 # چندزبانه‌ای
│   ├── 📄 app_localizations.dart   # تنظیمات l10n
│   ├── 📄 persian_utils.dart       # ابزارهای فارسی
│   └── 📄 localization.dart        # Export file
└── 📄 core.dart                     # Main export file
```

## 📁 ساختار test/

```
test/
├── 📁 unit/                         # تست‌های واحد
│   ├── 📁 features/
│   │   ├── 📁 auth/
│   │   │   ├── 📁 data/
│   │   │   ├── 📁 domain/
│   │   │   └── 📁 presentation/
│   │   ├── 📁 customer/
│   │   └── 📁 admin/
│   ├── 📁 shared/
│   │   ├── 📁 widgets/
│   │   ├── 📁 utils/
│   │   └── 📁 models/
│   └── 📁 core/
│       ├── 📁 network/
│       ├── 📁 database/
│       └── 📁 services/
├── 📁 widget/                       # تست‌های widget
│   ├── 📁 features/
│   ├── 📁 shared/
│   └── 📁 app/
├── 📁 mocks/                        # Mock objects
│   ├── 📄 mock_auth_service.dart
│   ├── 📄 mock_api_client.dart
│   └── 📄 mocks.dart
├── 📁 fixtures/                     # داده‌های تست
│   ├── 📄 user_fixture.dart
│   ├── 📄 consultation_fixture.dart
│   └── 📄 fixtures.dart
└── 📁 helpers/                      # کمکی‌های تست
    ├── 📄 test_helpers.dart
    ├── 📄 widget_tester_extensions.dart
    └── 📄 helpers.dart
```

## 📚 ساختار assets/

```
assets/
├── 📁 images/                       # تصاویر
│   ├── 📁 icons/                   # آیکون‌ها
│   │   ├── 📄 app_icon.png
│   │   ├── 📄 customer_icon.png
│   │   └── 📄 admin_icon.png
│   ├── 📁 logos/                   # لوگوها
│   │   ├── 📄 app_logo.png
│   │   └── 📄 company_logo.png
│   ├── 📁 illustrations/           # تصاویر توضیحی
│   │   ├── 📄 empty_state.png
│   │   └── 📄 error_state.png
│   └── 📁 backgrounds/             # پس‌زمینه‌ها
│       ├── 📄 login_bg.png
│       └── 📄 dashboard_bg.png
├── 📁 fonts/                        # فونت‌ها
│   ├── 📄 Vazirmatn-Regular.ttf
│   ├── 📄 Vazirmatn-Bold.ttf
│   └── 📄 Vazirmatn-Medium.ttf
├── 📁 animations/                   # انیمیشن‌ها
│   ├── 📄 loading.json             # Lottie animations
│   └── 📄 success.json
├── 📁 data/                         # داده‌های استاتیک
│   ├── 📄 cities.json              # لیست شهرها
│   ├── 📄 categories.json          # دسته‌بندی‌ها
│   └── 📄 sample_data.json         # داده‌های نمونه
└── 📁 configs/                      # فایل‌های پیکربندی
    ├── 📄 app_config.json          # تنظیمات اپ
    └── 📄 api_endpoints.json       # لیست endpoint ها
```

## 📖 ساختار docs/

```
docs/
├── 📄 README.md                     # راهنمای اصلی
├── 📄 CONTRIBUTING.md               # راهنمای مشارکت
├── 📄 CHANGELOG.md                  # تاریخچه تغییرات
├── 📄 LICENSE.md                    # لایسنس
├── 📁 api/                          # مستندات API
│   ├── 📄 authentication.md
│   ├── 📄 user_management.md
│   ├── 📄 consultation.md
│   └── 📄 admin_apis.md
├── 📁 architecture/                 # معماری
│   ├── 📄 overview.md              # نمای کلی
│   ├── 📄 clean_architecture.md    # Clean Architecture
│   ├── 📄 state_management.md      # مدیریت state
│   └── 📄 routing.md               # Routing strategy
├── 📁 features/                     # مستندات ویژگی‌ها
│   ├── 📄 customer_features.md
│   ├── 📄 admin_features.md
│   └── 📄 shared_features.md
├── 📁 deployment/                   # راهنمای استقرار
│   ├── 📄 android.md
│   ├── 📄 ios.md
│   ├── 📄 web.md
│   └── 📄 desktop.md
├── 📁 testing/                      # راهنمای تست
│   ├── 📄 unit_testing.md
│   ├── 📄 widget_testing.md
│   ├── 📄 integration_testing.md
│   └── 📄 testing_best_practices.md
└── 📁 design/                       # طراحی UI/UX
    ├── 📄 design_system.md
    ├── 📄 ui_components.md
    ├── 📄 responsive_design.md
    └── 📄 accessibility.md
```

## 🛠️ ساختار scripts/

```
scripts/
├── 📄 build.sh                     # اسکریپت build
├── 📄 test.sh                      # اجرای تست‌ها
├── 📄 deploy.sh                    # استقرار
├── 📄 generate.sh                  # تولید کد (JSON serialization)
├── 📄 clean.sh                     # پاک‌سازی
├── 📄 setup.sh                     # راه‌اندازی اولیه
├── 📄 lint.sh                      # بررسی کیفیت کد
└── 📁 tools/                       # ابزارهای سفارشی
    ├── 📄 icon_generator.dart      # تولید آیکون‌ها
    ├── 📄 translation_checker.dart # بررسی ترجمه‌ها
    └── 📄 dependency_checker.dart  # بررسی dependencies
```

## ⚙️ ساختار .github/

```
.github/
├── 📁 workflows/                    # GitHub Actions
│   ├── 📄 ci.yml                   # Continuous Integration
│   ├── 📄 cd.yml                   # Continuous Deployment
│   ├── 📄 test.yml                 # اجرای تست‌ها
│   └── 📄 release.yml              # ایجاد release
├── 📁 ISSUE_TEMPLATE/               # قالب‌های issue
│   ├── 📄 bug_report.md
│   ├── 📄 feature_request.md
│   └── 📄 question.md
├── 📁 PULL_REQUEST_TEMPLATE/        # قالب‌های PR
│   └── 📄 pull_request_template.md
├── 📁 instructions/                 # دستورالعمل‌های GitHub Copilot
│   ├── 📄 general_rules.md
│   ├── 📄 feature_development.md
│   ├── 📄 clean_architecture.md
│   ├── 📄 testing_guidelines.md
│   └── 📄 ui_development.md
└── 📄 CODEOWNERS                   # مالکیت فایل‌ها
```

## 📏 قوانین نام‌گذاری

### 📂 پوشه‌ها
- **snake_case** برای تمام پوشه‌ها
- **جمع** برای پوشه‌های حاوی آیتم‌های متعدد (`widgets/`, `models/`, `screens/`)
- **مفرد** برای پوشه‌های مفهومی (`data/`, `domain/`, `presentation/`)

### 📄 فایل‌ها
- **snake_case** برای تمام فایل‌های Dart
- **پسوند مناسب** برای نوع فایل (`_screen.dart`, `_widget.dart`, `_service.dart`)
- **Export files** با نام پوشه والد برای دسترسی آسان

### 🏷️ کلاس‌ها و متغیرها
- **PascalCase** برای کلاس‌ها، enum ها و typedef ها
- **camelCase** برای متغیرها، توابع و property ها
- **SCREAMING_SNAKE_CASE** برای ثابت‌ها
- **snake_case** برای نام فایل‌ها

## 🔗 سیستم Import/Export

### Export Files
هر پوشه اصلی باید یک فایل export داشته باشد:

```dart
// lib/shared/widgets/widgets.dart
export 'buttons/buttons.dart';
export 'forms/forms.dart';
export 'dialogs/dialogs.dart';
export 'layout/layout.dart';
```

### Import Guidelines
```dart
// ✅ درست - استفاده از export files
import 'package:ai_123/shared/widgets/widgets.dart';
import 'package:ai_123/features/auth/auth.dart';
import 'package:ai_123/core/core.dart';

// ❌ غلط - import مستقیم فایل‌های داخلی
import 'package:ai_123/shared/widgets/buttons/custom_button.dart';
import 'package:ai_123/features/auth/data/models/user.dart';
```

## 🎯 اصول معماری

### Clean Architecture Layers
1. **Presentation Layer**: UI و User Interaction
2. **Domain Layer**: Business Logic و Use Cases
3. **Data Layer**: Data Sources و Repositories

### Feature-Based Organization
- هر feature مستقل و خودکفا
- امکان حذف یا اضافه کردن feature بدون تأثیر بر بقیه
- اشتراک‌گذاری کد از طریق پوشه shared/

### Dependency Rules
- Presentation وابسته به Domain
- Data وابسته به Domain
- Domain مستقل از همه
- Core قابل استفاده توسط همه لایه‌ها

## 📝 مثال‌های کاربردی

### ایجاد Feature جدید
```bash
# ساختار برای feature جدید "products"
mkdir -p lib/features/products/{data,domain,presentation}/{models,repositories,datasources,entities,usecases,screens,widgets,providers}
```

### مثال کلاس Model
```dart
// lib/features/customer/consultation/data/models/consultation.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/consultation_entity.dart';

part 'consultation.g.dart';

@JsonSerializable()
class ConsultationModel extends ConsultationEntity {
  const ConsultationModel({
    required super.id,
    required super.userId,
    required super.message,
    required super.status,
    required super.createdAt,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationModelToJson(this);
}
```

### مثال Screen
```dart
// lib/features/customer/consultation/presentation/screens/consultation_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/consultation_provider.dart';
import '../widgets/widgets.dart';
import '../../../../shared/widgets/widgets.dart';

class ConsultationListScreen extends StatelessWidget {
  const ConsultationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشاوره‌های من'),
      ),
      body: Consumer<ConsultationProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.consultations.length,
            itemBuilder: (context, index) {
              return ConsultationCard(
                consultation: provider.consultations[index],
              );
            },
          );
        },
      ),
    );
  }
}
```

## ✅ چک‌لیست رعایت ساختار

### برای هر Feature جدید:
- [ ] پوشه‌های data/domain/presentation ایجاد شده
- [ ] فایل export اصلی feature موجود است
- [ ] Models در data/models/ قرار دارند
- [ ] Entities در domain/entities/ قرار دارند
- [ ] Use cases در domain/usecases/ قرار دارند
- [ ] Screens در presentation/screens/ قرار دارند
- [ ] Widgets در presentation/widgets/ قرار دارند
- [ ] Providers در presentation/providers/ قرار دارند

### برای هر فایل جدید:
- [ ] نام‌گذاری snake_case رعایت شده
- [ ] Import/Export guidelines رعایت شده
- [ ] Documentation و comments مناسب نوشته شده
- [ ] Clean architecture principles رعایت شده

## 🔧 ابزارهای کمکی

### اسکریپت ایجاد Feature
```bash
#!/bin/bash
# scripts/create_feature.sh

FEATURE_NAME=$1
FEATURE_TYPE=$2  # customer, admin, shared

if [ -z "$FEATURE_NAME" ] || [ -z "$FEATURE_TYPE" ]; then
    echo "Usage: ./create_feature.sh <feature_name> <feature_type>"
    echo "Example: ./create_feature.sh products customer"
    exit 1
fi

FEATURE_PATH="lib/features/$FEATURE_TYPE/$FEATURE_NAME"

# ایجاد ساختار پوشه‌ها
mkdir -p "$FEATURE_PATH"/{data,domain,presentation}/{models,repositories,datasources,entities,usecases,screens,widgets,providers}

# ایجاد فایل‌های export
echo "// Export file for $FEATURE_NAME feature" > "$FEATURE_PATH/data/models/models.dart"
echo "// Export file for $FEATURE_NAME feature" > "$FEATURE_PATH/data/repositories/repositories.dart"
echo "// Export file for $FEATURE_NAME feature" > "$FEATURE_PATH/data/datasources/datasources.dart"

echo "// Export file for $FEATURE_NAME feature" > "$FEATURE_PATH/domain/entities/entities.dart"
echo "// Export file for $FEATURE_NAME feature" > "$FEATURE_PATH/domain/usecases/usecases.dart"

echo "// Export file for $FEATURE_NAME feature" > "$FEATURE_PATH/presentation/screens/screens.dart"
echo "// Export file for $FEATURE_NAME feature" > "$FEATURE_PATH/presentation/widgets/widgets.dart"
echo "// Export file for $FEATURE_NAME feature" > "$FEATURE_PATH/presentation/providers/providers.dart"

# ایجاد فایل export اصلی
cat > "$FEATURE_PATH/$FEATURE_NAME.dart" << EOF
// $FEATURE_NAME Feature Export File
// تمام کامپوننت‌های مربوط به $FEATURE_NAME

export 'data/models/models.dart';
export 'data/repositories/repositories.dart';
export 'data/datasources/datasources.dart';

export 'domain/entities/entities.dart';
export 'domain/usecases/usecases.dart';

export 'presentation/screens/screens.dart';
export 'presentation/widgets/widgets.dart';
export 'presentation/providers/providers.dart';
EOF

echo "✅ Feature '$FEATURE_NAME' created successfully in $FEATURE_PATH"
```

### Template فایل‌ها

#### Model Template
```dart
// Template: lib/features/{type}/{feature}/data/models/{model_name}.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/{model_name}_entity.dart';

part '{model_name}.g.dart';

/// مدل {model_name} برای لایه داده
/// 
/// این مدل داده‌های دریافتی از API را به فرمت قابل استفاده
/// در اپلیکیشن تبدیل می‌کند
@JsonSerializable()
class {ModelName}Model extends {ModelName}Entity {
  const {ModelName}Model({
    required super.id,
    // سایر فیلدها
  });

  /// ایجاد instance از JSON
  factory {ModelName}Model.fromJson(Map<String, dynamic> json) =>
      _${ModelName}ModelFromJson(json);

  /// تبدیل به JSON
  Map<String, dynamic> toJson() => _${ModelName}ModelToJson(this);

  /// تبدیل به Entity
  {ModelName}Entity toEntity() {
    return {ModelName}Entity(
      id: id,
      // سایر فیلدها
    );
  }
}
```

#### Screen Template
```dart
// Template: lib/features/{type}/{feature}/presentation/screens/{screen_name}_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/{feature}_provider.dart';
import '../widgets/widgets.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/core.dart';

/// صفحه {screen_name}
/// 
/// این صفحه برای {توضیح کارکرد} استفاده می‌شود
class {ScreenName}Screen extends StatefulWidget {
  const {ScreenName}Screen({super.key});

  @override
  State<{ScreenName}Screen> createState() => _{ScreenName}ScreenState();
}

class _{ScreenName}ScreenState extends State<{ScreenName}Screen> {
  @override
  void initState() {
    super.initState();
    // مقداردهی اولیه
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{عنوان صفحه}'),
      ),
      body: Consumer<{Feature}Provider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(
              child: Text('خطا: ${provider.errorMessage}'),
            );
          }

          return _buildContent(provider);
        },
      ),
    );
  }

  Widget _buildContent({Feature}Provider provider) {
    // پیاده‌سازی محتوای صفحه
    return const Center(
      child: Text('محتوای صفحه'),
    );
  }
}
```

#### Provider Template
```dart
// Template: lib/features/{type}/{feature}/presentation/providers/{feature}_provider.dart
import 'package:flutter/foundation.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../../../core/core.dart';

/// Provider برای مدیریت state مربوط به {feature}
class {Feature}Provider extends ChangeNotifier {
  final {Feature}UseCase _{feature}UseCase;

  {Feature}Provider({
    required {Feature}UseCase {feature}UseCase,
  }) : _{feature}UseCase = {feature}UseCase;

  // State variables
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  List<{Entity}> _{entities} = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  List<{Entity}> get {entities} => List.unmodifiable(_{entities});

  /// بارگذاری داده‌ها
  Future<void> load{Entities}() async {
    _setLoading(true);
    
    try {
      final result = await _{feature}UseCase.get{Entities}();
      
      result.fold(
        (failure) => _setError(failure.message),
        (entities) => _setEntities(entities),
      );
    } catch (e) {
      _setError('خطای غیرمنتظره: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
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

  void _setEntities(List<{Entity}> entities) {
    _{entities} = entities;
    _hasError = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
```

## 🎨 استانداردهای UI/UX

### تعریف Theme
```dart
// lib/app/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Vazirmatn',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      textTheme: AppTextStyles.textTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
      ),
    );
  }

  // سایر theme configurations...
}
```

### Responsive Design
```dart
// lib/shared/utils/responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? desktop;
    return mobile;
  }
}
```

## 📋 نتیجه‌گیری

این ساختار استاندارد برای پروژه "دستیار هوشمند یک دو سه" مزایای زیر را فراهم می‌کند:

### ✅ مزایای ساختار پیشنهادی:

1. **جداسازی مناسب**: Customer و Admin features کاملاً جدا
2. **قابلیت توسعه**: راحتی اضافه کردن features جدید
3. **Clean Architecture**: رعایت اصول معماری تمیز
4. **تست‌پذیری**: ساختار مناسب برای نوشتن تست
5. **تیم‌کاری**: امکان کار موثر چندین developer
6. **نگهداری**: سادگی در maintenance و debug
7. **استانداردهای صنعتی**: رعایت best practices

### 🎯 نکات کلیدی:

- Feature-based organization برای مدیریت بهتر کد
- Clean Architecture برای جداسازی concerns
- Export files برای import های تمیز
- Template های آماده برای consistency
- Documentation کامل برای هر بخش

این ساختار آماده‌ای برای شروع توسعه حرفه‌ای و تیمی پروژه فراهم می‌کند.