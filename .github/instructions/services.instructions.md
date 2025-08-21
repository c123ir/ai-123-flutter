---
applyTo: "lib/services/**"
---

# قوانین ایجاد سرویس‌ها (Service Creation Rules)

## ساختار استاندارد سرویس

### فرمت کلی

```dart
// lib/services/service_name_service.dart
// سرویس [نام سرویس] - توضیح عملکرد و مسئولیت‌های سرویس

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model_name.dart';
import '../utils/logger.dart';
import '../utils/persian_date_helper.dart';

/// سرویس مدیریت [نام بخش]
/// مسئولیت‌ها: [لیست مسئولیت‌ها]
class ServiceNameService {
  static const String _baseUrl = 'https://api.example.com';
  static const String _endpoint = '/endpoint';

  /// دریافت لیست [نام آیتم‌ها]
  static Future<List<ModelName>> getAll() async {
    try {
      Logger.info('سرویس [نام]', 'شروع دریافت لیست');

      final response = await http.get(
        Uri.parse('$_baseUrl$_endpoint'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final items = jsonList.map((json) => ModelName.fromJson(json)).toList();

        Logger.success('سرویس [نام]', 'دریافت ${items.length} آیتم');
        return items;
      } else {
        Logger.error('سرویس [نام]', 'خطا در دریافت: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      Logger.error('سرویس [نام]', 'خطای شبکه: $e');
      return [];
    }
  }

  /// دریافت یک آیتم با شناسه
  static Future<ModelName?> getById(int id) async {
    try {
      Logger.info('سرویس [نام]', 'دریافت آیتم با شناسه: $id');

      final response = await http.get(
        Uri.parse('$_baseUrl$_endpoint/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final item = ModelName.fromJson(json.decode(response.body));
        Logger.success('سرویس [نام]', 'دریافت آیتم موفق');
        return item;
      } else {
        Logger.error('سرویس [نام]', 'آیتم پیدا نشد: $id');
        return null;
      }
    } catch (e) {
      Logger.error('سرویس [نام]', 'خطا در دریافت آیتم: $e');
      return null;
    }
  }

  /// ایجاد آیتم جدید
  static Future<bool> create(ModelName item) async {
    try {
      Logger.info('سرویس [نام]', 'شروع ایجاد آیتم جدید');

      final response = await http.post(
        Uri.parse('$_baseUrl$_endpoint'),
        headers: _getHeaders(),
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201) {
        Logger.success('سرویس [نام]', 'آیتم با موفقیت ایجاد شد');
        return true;
      } else {
        Logger.error('سرویس [نام]', 'خطا در ایجاد: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Logger.error('سرویس [نام]', 'خطا در ایجاد آیتم: $e');
      return false;
    }
  }

  /// بروزرسانی آیتم
  static Future<bool> update(int id, ModelName item) async {
    try {
      Logger.info('سرویس [نام]', 'شروع بروزرسانی آیتم: $id');

      final response = await http.put(
        Uri.parse('$_baseUrl$_endpoint/$id'),
        headers: _getHeaders(),
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        Logger.success('سرویس [نام]', 'آیتم با موفقیت بروزرسانی شد');
        return true;
      } else {
        Logger.error('سرویس [نام]', 'خطا در بروزرسانی: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Logger.error('سرویس [نام]', 'خطا در بروزرسانی آیتم: $e');
      return false;
    }
  }

  /// حذف آیتم
  static Future<bool> delete(int id) async {
    try {
      Logger.info('سرویس [نام]', 'شروع حذف آیتم: $id');

      final response = await http.delete(
        Uri.parse('$_baseUrl$_endpoint/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        Logger.success('سرویس [نام]', 'آیتم با موفقیت حذف شد');
        return true;
      } else {
        Logger.error('سرویس [نام]', 'خطا در حذف: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Logger.error('سرویس [نام]', 'خطا در حذف آیتم: $e');
      return false;
    }
  }

  /// تنظیم headers درخواست
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_getToken()}',
    };
  }

  /// دریافت token احراز هویت
  static String _getToken() {
    // پیاده‌سازی دریافت token
    return 'your-auth-token';
  }
}
```

## قوانین نام‌گذاری

### کلاس‌ها

- `[Name]Service`: نام سرویس + Service
- مثال: `UserService`, `ProductService`, `OrderService`

### متدها

- `getAll()`: دریافت همه آیتم‌ها
- `getById(int id)`: دریافت با شناسه
- `create(Model item)`: ایجاد جدید
- `update(int id, Model item)`: بروزرسانی
- `delete(int id)`: حذف
- `search(String query)`: جستجو

### متغیرها

- `_baseUrl`: آدرس پایه API
- `_endpoint`: مسیر endpoint
- `_headers`: headers درخواست

## الگوهای مفید

### مدیریت خطا

```dart
try {
  // عملیات اصلی
} on SocketException {
  Logger.error('سرویس', 'عدم اتصال به اینترنت');
} on TimeoutException {
  Logger.error('سرویس', 'تایم‌اوت در ارتباط');
} catch (e) {
  Logger.error('سرویس', 'خطای غیرمنتظره: $e');
}
```

### Cache مدیری

```dart
static final Map<int, ModelName> _cache = {};

static Future<ModelName?> getCachedById(int id) async {
  if (_cache.containsKey(id)) {
    Logger.info('سرویس', 'دریافت از cache: $id');
    return _cache[id];
  }

  final item = await getById(id);
  if (item != null) {
    _cache[id] = item;
  }
  return item;
}
```
