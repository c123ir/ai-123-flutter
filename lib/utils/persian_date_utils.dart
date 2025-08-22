// lib/utils/persian_date_utils.dart
// ابزارهای کار با تاریخ و زمان شمسی

import 'package:shamsi_date/shamsi_date.dart';

class PersianDateUtils {
  /// دریافت تاریخ شمسی فعلی به فرمت ۱۴۰۴/۰۶/۰۱
  static String getCurrentPersianDate() {
    final now = Jalali.now();
    return '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
  }

  /// دریافت زمان فعلی به فرمت ۱۲:۳۰
  static String getCurrentPersianTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  /// تبدیل DateTime به تاریخ شمسی
  static String toShamsiDate(DateTime dateTime) {
    final jalali = Jalali.fromDateTime(dateTime);
    return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}';
  }

  /// تبدیل DateTime به زمان فارسی
  static String toShamsiTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// دریافت نام ماه شمسی
  static String getShamsiMonthName(int month) {
    const months = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند',
    ];
    return months[month - 1];
  }

  /// فرمت کامل تاریخ شمسی
  static String formatFullShamsiDate(DateTime dateTime) {
    final jalali = Jalali.fromDateTime(dateTime);
    final monthName = getShamsiMonthName(jalali.month);
    return '${jalali.day} $monthName ${jalali.year}';
  }
}
