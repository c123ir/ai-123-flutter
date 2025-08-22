// lib/database/mysql_adapter.dart
// آداپتور MySQL برای ارتباط با سرور از طریق API

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database_adapter.dart';

class MySQLAdapter implements DatabaseAdapter {
  final String _baseUrl;
  final String _apiKey;

  MySQLAdapter({required String baseUrl, required String apiKey})
    : _baseUrl = baseUrl,
      _apiKey = apiKey;

  @override
  Future<void> init() async {
    print('🗄️ [MySQL] اتصال به سرور MySQL');
    // تست اتصال به سرور
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      if (response.statusCode == 200) {
        print('✅ [MySQL] اتصال موفق به سرور');
      } else {
        throw Exception('خطا در اتصال به سرور');
      }
    } catch (e) {
      print('❌ [MySQL] خطا در اتصال: $e');
      rethrow;
    }
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    print('💾 [MySQL] ذخیره در $table: $data');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$table'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        final result = json.decode(response.body);
        return result['id'] as int;
      } else {
        throw Exception('خطا در ذخیره داده: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [MySQL] خطا در insert: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('🔍 [MySQL] خواندن از $table');

    try {
      var url = '$_baseUrl/$table';

      // اضافه کردن query parameters
      if (where != null && whereArgs != null) {
        final params = _buildQueryParams(where, whereArgs);
        url += '?$params';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('خطا در خواندن داده: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [MySQL] خطا در query: $e');
      return [];
    }
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('✏️ [MySQL] بروزرسانی $table: $data');

    try {
      var url = '$_baseUrl/$table';

      if (where != null && whereArgs != null) {
        final params = _buildQueryParams(where, whereArgs);
        url += '?$params';
      }

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['affected_rows'] as int? ?? 1;
      } else {
        throw Exception('خطا در بروزرسانی: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [MySQL] خطا در update: $e');
      return 0;
    }
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('🗑️ [MySQL] حذف از $table');

    try {
      var url = '$_baseUrl/$table';

      if (where != null && whereArgs != null) {
        final params = _buildQueryParams(where, whereArgs);
        url += '?$params';
      }

      final response = await http.delete(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['affected_rows'] as int? ?? 1;
      } else {
        throw Exception('خطا در حذف: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [MySQL] خطا در delete: $e');
      return 0;
    }
  }

  @override
  Future<void> close() async {
    print('🔒 [MySQL] بستن اتصال');
    // در MySQL/HTTP نیازی به close نیست
  }

  String _buildQueryParams(String where, List<dynamic> whereArgs) {
    // تبدیل where clause به query parameters
    if (where.contains('=') && whereArgs.isNotEmpty) {
      final field = where.split('=')[0].trim();
      final value = whereArgs[0];
      return '$field=$value';
    }
    return '';
  }
}
