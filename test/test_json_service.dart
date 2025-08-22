// test_json_service.dart
// تست سرویس JSON برای خطایابی

import 'dart:io';
import '../lib/services/json_update_history_service.dart';

Future<void> main() async {
  print('🔍 شروع تست سرویس JSON...');

  // بررسی وجود فایل
  final jsonFile = File('update_history_records.json');
  final jsonFileLib = File('lib/update_history_records.json');

  print('📁 بررسی فایل‌ها:');
  print('   - Root: ${await jsonFile.exists()} (${jsonFile.path})');
  print('   - Lib: ${await jsonFileLib.exists()} (${jsonFileLib.path})');

  if (await jsonFile.exists()) {
    final content = await jsonFile.readAsString();
    print('✅ محتوای فایل root خوانده شد: ${content.length} کاراکتر');
  }

  if (await jsonFileLib.exists()) {
    final content = await jsonFileLib.readAsString();
    print('✅ محتوای فایل lib خوانده شد: ${content.length} کاراکتر');
  }

  // تست سرویس
  final jsonService = JsonUpdateHistoryService();
  try {
    final updates = await jsonService.getAllUpdatesFromJson();
    print('📊 نتیجه سرویس JSON: ${updates.length} رکورد');

    for (int i = 0; i < updates.length; i++) {
      print('   ${i + 1}. ${updates[i].title}');
      print('      تاریخ: ${updates[i].shamsiDate} - ${updates[i].shamsiTime}');
      print('      دسته: ${updates[i].category}');
      print('');
    }
  } catch (e) {
    print('❌ خطا در سرویس JSON: $e');
  }
}
