// test_update_history_record.dart
// فایل تست برای ثبت رکورد بروزرسانی دستورالعمل‌های GitHub Copilot

import 'lib/services/update_history_service.dart';

Future<void> main() async {
  print('🤖 شروع ثبت رکورد بروزرسانی...');

  try {
    final updateService = UpdateHistoryService();

    final recordId = await updateService.autoRegisterUpdate(
      title: 'بروزرسانی دستورالعمل‌های GitHub Copilot برای سیستم تاریخچه',
      version: '1.2.0',
      userProblem:
          'نیاز به دستورالعمل جامع برای GitHub Copilot جهت ثبت خودکار تاریخچه بروزرسانی‌ها',
      solutionDescription: '''
بروزرسانی کامل فایل دستورالعمل update_history_automation.instructions.md با:

✨ ویژگی‌های جدید:
- 🎯 مأموریت واضح برای GitHub Copilot
- 📊 مدل داده‌ای کامل UpdateHistory
- 🚨 ۴ قانون اجباری با جزئیات
- 🔄 گردش کار ۴ مرحله‌ای (تشخیص → جمع‌آوری → تایید → ثبت)
- 📝 الگوهای استاندارد برای انواع تغییرات
- 🎭 سناریوهای خاص و راه‌حل‌ها
- ⚠️ هشدارها و بهترین شیوه‌ها
- 🔧 نمونه کد عملی قابل استفاده
- 📊 بخش گزارش‌گیری و پیگیری کیفیت

🔧 قوانین کلیدی:
- CRITICAL: هرگز بدون تایید کاربر رکورد ثبت نشود
- دسته‌بندی‌های استاندارد: Feature|Bug Fix|UI Update|Database|API|Performance|Security|Documentation
- اولویت‌بندی دقیق: Critical|High|Medium|Low
- گردش کار مرحله‌ای برای هر تغییر

📋 نتیجه:
حالا GitHub Copilot قوانین دقیق و جامعی برای ثبت تاریخچه بروزرسانی‌ها دارد.
      ''',
      tags:
          'documentation,github-copilot,automation,instructions,update-history',
      category: 'documentation',
    );

    print('✅ رکورد با موفقیت ثبت شد - ID: $recordId');
    print(
      '📋 عنوان: بروزرسانی دستورالعمل‌های GitHub Copilot برای سیستم تاریخچه',
    );
    print('🗂️ دسته‌بندی: Documentation');
    print(
      '📁 فایل تغییر یافته: .github/instructions/update_history_automation.instructions.md',
    );
  } catch (e) {
    print('❌ خطا در ثبت رکورد: $e');
  }
}
