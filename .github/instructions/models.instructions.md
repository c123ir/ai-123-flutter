---
applyTo: "lib/models/**"
---

# قوانین ایجاد مدل‌ها (Model Creation Rules)

## ⚠️ قوانین تایید پس از ایجاد/ویرایش مدل

### تایید عملیات‌های حیاتی

پس از ایجاد یا ویرایش هر مدل، **الزامی** است این سوالات مطرح شود:

```markdown
🤔 سوالات تایید پس از تغییرات مدل:

1. آیا می‌خواهید تاریخچه بروزرسانی آپدیت شود؟ (بله/خیر)
2. آیا می‌خواهید مستندات پروژه بروزرسانی شود؟ (بله/خیر)
3. آیا می‌خواهید تغییرات به Git ارسال شود؟ (بله/خیر)
```

### اجرای تاییدیه‌ها

در صورت تایید کاربر:

- **تاریخچه:** ثبت رکورد جدید با `UpdateHistoryService.autoRegisterUpdate()`
- **مستندات:** بروزرسانی README.md و فایل‌های مرتبط
- **Git:** اجرای دستورات `git add`, `git commit`, `git push`

## ساختار استاندارد مدل

### فرمت کلی

```dart
// lib/models/model_name.dart
// مدل [نام مدل] - توضیح کاربرد مدل

import 'package:json_annotation/json_annotation.dart';

part 'model_name.g.dart';

/// مدل اطلاعات [نام مدل]
/// شامل: [لیست فیلدهای اصلی]
@JsonSerializable()
class ModelName {
  /// شناسه یکتا
  final int id;

  /// نام یا عنوان
  final String name;

  /// تاریخ ایجاد (شمسی)
  final String createdAt;

  /// تاریخ بروزرسانی (شمسی)
  final String updatedAt;

  const ModelName({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ایجاد instance از JSON
  factory ModelName.fromJson(Map<String, dynamic> json) =>
      _$ModelNameFromJson(json);

  /// تبدیل به JSON
  Map<String, dynamic> toJson() => _$ModelNameToJson(this);

  /// ایجاد کپی با تغییرات
  ModelName copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    return ModelName(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ModelName(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ModelName && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
```

## قوانین نام‌گذاری

### فیلدها

- `id`: همیشه int و required
- `name/title`: متن اصلی
- `description`: توضیحات اختیاری
- `isActive`: وضعیت فعال/غیرفعال
- `createdAt/updatedAt`: تاریخ‌ها به فرمت شمسی

### متدها

- `fromJson()`: ایجاد از JSON
- `toJson()`: تبدیل به JSON
- `copyWith()`: کپی با تغییرات
- `toString()`: نمایش رشته‌ای
- `operator ==()` و `hashCode`: مقایسه

## مثال‌های کاربردی

### مدل کاربر

```dart
@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String role; // 'admin', 'user', 'moderator'
  final bool isActive;
  final String createdAt;
  final String updatedAt;
}
```

### مدل محصول

```dart
@JsonSerializable()
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final String categoryId;
  final String createdAt;
  final String updatedAt;
}
```
