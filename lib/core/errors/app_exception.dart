// lib_new/core/errors/app_exception.dart
// تعریف استثناهای اپلیکیشن

/// استثنای پایه اپلیکیشن
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message';
}

/// استثنای شبکه
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.details});
}

/// استثنای دیتابیس
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.details});
}

/// استثنای SMS
class SmsException extends AppException {
  const SmsException(super.message, {super.code, super.details});
}

/// استثنای اعتبارسنجی
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.details});
}

/// استثنای احراز هویت
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.details});
}
