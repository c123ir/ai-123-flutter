import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://yourdomain.com/api';
  static const Duration timeout = Duration(seconds: 30);

  // Headers پیش‌فرض
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  // GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {...defaultHeaders, ...?headers},
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {...defaultHeaders, ...?headers},
            body: jsonEncode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {...defaultHeaders, ...?headers},
            body: jsonEncode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {...defaultHeaders, ...?headers},
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // پردازش پاسخ
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        message: 'درخواست ناموفق: ${response.statusCode}',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }

  // مدیریت خطا
  static Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error.toString().contains('TimeoutException')) {
      return ApiException(message: 'زمان انتظار تمام شد');
    } else if (error.toString().contains('SocketException')) {
      return ApiException(message: 'خطا در اتصال به اینترنت');
    } else {
      return ApiException(message: 'خطای غیرمنتظره: ${error.toString()}');
    }
  }
}

// کلاس Exception سفارشی
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? response;

  ApiException({required this.message, this.statusCode, this.response});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Code: $statusCode)' : ''}';
  }
}
