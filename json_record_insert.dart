// json_record_insert.dart
// ثبت رکورد در فایل JSON به عنوان backup تا دیتابیس رفع شود

import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  print('🤖 ثبت رکورد تاریخچه در فایل JSON...');

  try {
    // مسیر فایل JSON
    final jsonFile = File('update_history_records.json');

    // خواندن رکوردهای موجود (اگر فایل وجود دارد)
    List<Map<String, dynamic>> records = [];
    if (await jsonFile.exists()) {
      final content = await jsonFile.readAsString();
      final jsonData = jsonDecode(content);
      records = List<Map<String, dynamic>>.from(jsonData['records'] ?? []);
    }

    // آماده‌سازی رکورد جدید
    final now = DateTime.now();
    final shamsiDate = '۱۴۰۴/۰۵/۳۱';
    final shamsiTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final newRecord = {
      'id': records.length + 1,
      'title': 'بروزرسانی دستورالعمل‌های GitHub Copilot برای سیستم تاریخچه',
      'version': '1.2.0',
      'shamsiDate': shamsiDate,
      'shamsiTime': shamsiTime,
      'createdAt': now.toIso8601String(),
      'userProblem':
          'GitHub Copilot نیاز به دستورالعمل جامع و دقیق برای ثبت خودکار تاریخچه بروزرسانی‌ها داشت',
      'solutionDescription':
          '''بروزرسانی کامل فایل .github/instructions/update_history_automation.instructions.md شامل:

✨ ویژگی‌های کلیدی اضافه شده:
• مأموریت واضح و دقیق برای GitHub Copilot
• مدل داده‌ای کامل UpdateHistory با تمام فیلدهای ضروری
• ۴ قانون اجباری: تایید کاربر، زمان‌بندی، دسته‌بندی، اولویت‌بندی
• گردش کار ۴ مرحله‌ای: تشخیص → جمع‌آوری → تایید → ثبت
• الگوهای استاندارد برای Feature، Bug Fix، UI Update
• سناریوهای خاص: تغییرات متعدد، جزئی، اضطراری
• هشدارها و بهترین شیوه‌ها (DO/DON'T)
• نمونه کد عملی قابل استفاده مستقیم
• بخش گزارش‌گیری و پیگیری کیفیت

🔧 قوانین کلیدی:
- CRITICAL: هرگز بدون تایید کاربر رکورد ثبت نشود
- دسته‌بندی‌های استاندارد: Feature|Bug Fix|UI Update|Database|API|Performance|Security|Documentation
- اولویت‌بندی دقیق: Critical|High|Medium|Low
- گردش کار مرحله‌ای برای هر تغییر

🎯 نتیجه نهایی:
GitHub Copilot حالا قوانین جامع و دقیقی برای ثبت تاریخچه دارد و پس از هر تغییر مهم، حتماً تایید کاربر می‌گیرد.''',
      'userComment':
          'دستورالعمل‌های جدید باعث بهبود کیفیت ثبت تاریخچه و مستندسازی بهتر تغییرات می‌شود. این تغییر بنیادی در نحوه کار GitHub Copilot خواهد داشت.',
      'tags':
          'github-copilot,documentation,automation,instructions,update-history,guidelines,workflow',
      'priority': 'medium',
      'category': 'documentation',
      'status': 'completed',
      'affectedFiles': [
        '.github/instructions/update_history_automation.instructions.md',
      ],
      'changes': [
        'بازنویسی کامل دستورالعمل‌های GitHub Copilot',
        'اضافه کردن ۴ قانون اجباری',
        'تعریف گردش کار ۴ مرحله‌ای',
        'افزودن الگوهای استاندارد برای انواع تغییرات',
        'اضافه کردن نمونه کدهای عملی',
        'ایجاد بخش گزارش‌گیری و پیگیری کیفیت',
        'تعریف سناریوهای خاص و راه‌حل‌ها',
        'اضافه کردن هشدارها و بهترین شیوه‌ها',
      ],
    };

    // اضافه کردن رکورد جدید
    records.add(newRecord);

    // آماده‌سازی داده نهایی
    final finalData = {
      'metadata': {
        'totalRecords': records.length,
        'lastUpdated': now.toIso8601String(),
        'version': '1.2.0',
      },
      'records': records,
    };

    // نوشتن در فایل
    final jsonString = JsonEncoder.withIndent('  ').convert(finalData);
    await jsonFile.writeAsString(jsonString);

    print('✅ رکورد با موفقیت در فایل JSON ثبت شد!');
    print('🆔 شناسه رکورد: ${newRecord['id']}');
    print('📁 فایل: ${jsonFile.path}');
    print('📋 عنوان: ${newRecord['title']}');
    print('🗂️ دسته‌بندی: ${newRecord['category']}');
    print('⭐ اولویت: ${newRecord['priority']}');
    print('📅 تاریخ: $shamsiDate - $shamsiTime');
    print('📊 تعداد کل رکوردها: ${records.length}');

    print('');
    print('🎉 رکورد تاریخچه بروزرسانی ثبت شد!');
    print(
      '📄 این رکورد شامل تمام جزئیات بروزرسانی دستورالعمل‌های GitHub Copilot است.',
    );
    print('🚀 حالا سیستم تاریخچه بروزرسانی کامل و عملیاتی است!');
  } catch (e) {
    print('❌ خطا در ثبت رکورد: $e');
  }
}
