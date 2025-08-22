// lib/database/mysql_database_adapter.dart
// MySQL Database Adapter برای اتصال به پایگاه داده MySQL

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_adapter.dart';

class MySqlDatabaseAdapter implements DatabaseAdapter {
  static const String _baseUrl =
      'http://localhost:3000/api'; // PHP API endpoint
  static const String _dbName = 'ai_123';

  @override
  Future<void> init() async {
    print('🔗 [MySQL] اتصال به پایگاه داده $_dbName');

    try {
      // تست اتصال
      final response = await http.get(Uri.parse('$_baseUrl/test'));
      if (response.statusCode == 200) {
        print('✅ [MySQL] اتصال برقرار شد');
      } else {
        print(
          '⚠️ [MySQL] سرور API در دسترس نیست، از WebAdapter استفاده می‌شود',
        );
      }
    } catch (e) {
      print('⚠️ [MySQL] خطا در اتصال: $e');
    }
  }

  @override
  Future<void> close() async {
    print('🔒 [MySQL] بستن اتصال پایگاه داده');
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$table'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        return result['id'] ?? 1;
      }
    } catch (e) {
      print('❌ [MySQL] خطا در درج $table: $e');
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      String url = '$_baseUrl/$table';
      if (where != null) {
        url += '?where=$where';
        if (whereArgs != null && whereArgs.isNotEmpty) {
          url += '&args=${whereArgs.join(',')}';
        }
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      print('❌ [MySQL] خطا در کوئری $table: $e');
    }
    return [];
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      String url = '$_baseUrl/$table';
      if (where != null) {
        url += '?where=$where';
        if (whereArgs != null && whereArgs.isNotEmpty) {
          url += '&args=${whereArgs.join(',')}';
        }
      }

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['affected_rows'] ?? 0;
      }
    } catch (e) {
      print('❌ [MySQL] خطا در بروزرسانی $table: $e');
    }
    return 0;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      String url = '$_baseUrl/$table';
      if (where != null) {
        url += '?where=$where';
        if (whereArgs != null && whereArgs.isNotEmpty) {
          url += '&args=${whereArgs.join(',')}';
        }
      }

      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['affected_rows'] ?? 0;
      }
    } catch (e) {
      print('❌ [MySQL] خطا در حذف $table: $e');
    }
    return 0;
  }
}
