// register_documentation_update.dart
// ثبت واقعی رکورد بروزرسانی مستندات در دیتابیس

import 'lib/services/update_history_service.dart';
import 'lib/database/database_helper.dart';

Future<void> main() async {
  print('🤖 شروع ثبت واقعی رکورد در دیتابیس...');

  try {
    // اطمینان از آماده بودن دیتابیس
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database; // اطمینان از ایجاد دیتابیس

    final updateService = UpdateHistoryService();

    print('📝 درحال ثبت رکورد بروزرسانی دستورالعمل‌های GitHub Copilot...');

    final recordId = await updateService.addUpdate(
      title: 'بروزرسانی دستورالعمل‌های GitHub Copilot برای سیستم تاریخچه',
      version: '1.2.0',
      userProblem:
          'GitHub Copilot نیاز به دستورالعمل جامع و دقیق برای ثبت خودکار تاریخچه بروزرسانی‌ها داشت',
      solutionDescription: '''
بروزرسانی کامل فایل .github/instructions/update_history_automation.instructions.md شامل:

✨ ویژگی‌های کلیدی اضافه شده:
• مأموریت واضح و دقیق برای GitHub Copilot
• مدل داده‌ای کامل UpdateHistory 
• ۴ قانون اجباری: تایید کاربر، زمان‌بندی، دسته‌بندی، اولویت‌بندی
• گردش کار ۴ مرحله‌ای: تشخیص → جمع‌آوری → تایید → ثبت
• الگوهای استاندارد برای Feature، Bug Fix، UI Update
• سناریوهای خاص و راه‌حل‌ها
• هشدارها و بهترین شیوه‌ها (DO/DON'T)
• نمونه کد عملی قابل استفاده
• بخش گزارش‌گیری و پیگیری کیفیت

🎯 نتیجه:
GitHub Copilot حالا قوانین جامع و دقیقی برای ثبت تاریخچه دارد و پس از هر تغییر مهم، حتماً تایید کاربر می‌گیرد.
      ''',
      userComment:
          'دستورالعمل‌های جدید باعث بهبود کیفیت ثبت تاریخچه و مستندسازی بهتر تغییرات خواهد شد',
      tags:
          'github-copilot,documentation,automation,instructions,update-history,guidelines',
      priority: 'medium',
      category: 'documentation',
      status: 'completed',
    );

    print('✅ رکورد با موفقیت در دیتابیس ثبت شد!');
    print('🆔 شناسه رکورد: $recordId');
    print(
      '📋 عنوان: بروزرسانی دستورالعمل‌های GitHub Copilot برای سیستم تاریخچه',
    );
    print('🗂️ دسته‌بندی: Documentation');
    print('⭐ اولویت: Medium');
    print(
      '📁 فایل: .github/instructions/update_history_automation.instructions.md',
    );
    print('');

    // نمایش تعداد کل رکوردها
    final allRecords = await updateService.getAllUpdates();
    print('📊 تعداد کل رکوردهای تاریخچه: ${allRecords.length}');

    // نمایش آخرین رکورد
    if (allRecords.isNotEmpty) {
      final latestRecord = allRecords.last;
      print('📅 آخرین رکورد: ${latestRecord.title}');
      print(
        '🕐 زمان ثبت: ${latestRecord.shamsiDate} ${latestRecord.shamsiTime}',
      );
    }
  } catch (e) {
    print('❌ خطا در ثبت رکورد: $e');
    print('🔍 بررسی کنید که دیتابیس و سرویس‌ها به درستی راه‌اندازی شده‌اند');
  }
}
