// lib/services/json_update_history_service.dart
// سرویس خواندن تاریخچه بروزرسانی از فایل JSON

import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/update_history.dart';

class JsonUpdateHistoryService {
  static const String _jsonFileName = 'update_history_records.json';

  /// خواندن همه رکوردهای تاریخچه از فایل JSON
  Future<List<UpdateHistory>> getAllUpdatesFromJson() async {
    try {
      // ابتدا سعی می‌کنیم از assets بخوانیم
      String content;
      try {
        content = await rootBundle.loadString('assets/$_jsonFileName');
        print('✅ فایل JSON از assets خوانده شد');
      } catch (e) {
        // اگر از assets نتوانستیم بخوانیم، از فایل‌های محلی استفاده می‌کنیم
        print('⚠️ خطا در خواندن از assets: $e');
        print('🔄 تلاش برای خواندن از فایل محلی...');

        // ابتدا در root directory جستجو کن
        File jsonFile = File(_jsonFileName);

        // اگر در root نبود، در lib جستجو کن
        if (!await jsonFile.exists()) {
          jsonFile = File('lib/$_jsonFileName');
        }

        if (!await jsonFile.exists()) {
          print('📁 فایل JSON تاریخچه وجود ندارد');
          return [];
        }

        content = await jsonFile.readAsString();
        print('✅ فایل JSON از مسیر محلی خوانده شد');
      }
      final jsonData = jsonDecode(content);
      final records = jsonData['records'] as List<dynamic>;

      final updates = records.map((record) {
        // تلاش برای parse کردن تاریخ با handling خطا
        DateTime? createdAt;
        try {
          String dateStr = record['createdAt'];
          // اصلاح فرمت‌های نامعتبر
          if (dateStr.endsWith('.6N')) {
            dateStr = dateStr.replaceAll('.6N', '.000000Z');
          }
          if (!dateStr.endsWith('Z') && !dateStr.contains('+')) {
            dateStr += 'Z';
          }
          createdAt = DateTime.parse(dateStr);
        } catch (e) {
          print(
            '⚠️ خطا در parse تاریخ برای رکورد ${record['id']}: ${record['createdAt']}',
          );
          createdAt = DateTime.now(); // تاریخ پیش‌فرض
        }

        return UpdateHistory(
          id: record['id'],
          title: record['title'],
          version: record['version'],
          shamsiDate: record['shamsiDate'],
          shamsiTime: record['shamsiTime'],
          createdAt: createdAt,
          userProblem: record['userProblem'],
          solutionDescription: record['solutionDescription'],
          userComment: record['userComment'],
          tags: record['tags'],
          priority: record['priority'],
          category: record['category'],
          status: record['status'],
        );
      }).toList();

      print('📋 تعداد رکوردهای JSON: ${updates.length}');
      return updates;
    } catch (e) {
      print('❌ خطا در خواندن فایل JSON: $e');
      return [];
    }
  }

  /// دریافت آمار کلی
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final updates = await getAllUpdatesFromJson();

      final categoryStats = <String, int>{};
      final priorityStats = <String, int>{};

      for (final update in updates) {
        categoryStats[update.category] =
            (categoryStats[update.category] ?? 0) + 1;
        priorityStats[update.priority] =
            (priorityStats[update.priority] ?? 0) + 1;
      }

      return {
        'totalUpdates': updates.length,
        'categoryStats': categoryStats,
        'priorityStats': priorityStats,
        'lastUpdate': updates.isNotEmpty
            ? '${updates.last.shamsiDate} ${updates.last.shamsiTime}'
            : 'هیچ رکوردی موجود نیست',
      };
    } catch (e) {
      print('❌ خطا در محاسبه آمار: $e');
      return {
        'totalUpdates': 0,
        'categoryStats': {},
        'priorityStats': {},
        'lastUpdate': 'خطا در بارگذاری',
      };
    }
  }

  /// افزودن رکورد جدید به فایل JSON
  Future<bool> addUpdate(Map<String, dynamic> updateData) async {
    try {
      // خواندن رکوردهای موجود
      List<Map<String, dynamic>> existingRecords = [];

      try {
        final file = File(_jsonFileName);
        if (await file.exists()) {
          final content = await file.readAsString();
          final jsonData = jsonDecode(content);
          existingRecords = List<Map<String, dynamic>>.from(
            jsonData['records'] ?? [],
          );
        }
      } catch (e) {
        print('⚠️ خطا در خواندن فایل موجود: $e');
      }

      // اضافه کردن رکورد جدید
      existingRecords.insert(0, updateData); // در ابتدای لیست اضافه کن

      // ایجاد ساختار JSON
      final jsonStructure = {
        'last_updated': DateTime.now().toIso8601String(),
        'total_records': existingRecords.length,
        'records': existingRecords,
      };

      // نوشتن به فایل
      final file = File(_jsonFileName);
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(jsonStructure),
      );

      // کپی به assets
      try {
        final assetsFile = File('assets/$_jsonFileName');
        await assetsFile.writeAsString(
          const JsonEncoder.withIndent('  ').convert(jsonStructure),
        );
        print('✅ فایل JSON به assets کپی شد');
      } catch (e) {
        print('⚠️ خطا در کپی به assets: $e');
      }

      print('✅ رکورد جدید با موفقیت اضافه شد');
      return true;
    } catch (e) {
      print('❌ خطا در افزودن رکورد: $e');
      return false;
    }
  }

  /// جستجو در رکوردها
  Future<List<UpdateHistory>> searchUpdates(String query) async {
    try {
      final allUpdates = await getAllUpdatesFromJson();

      if (query.trim().isEmpty) return allUpdates;

      final filteredUpdates = allUpdates.where((update) {
        final searchQuery = query.toLowerCase();
        return update.title.toLowerCase().contains(searchQuery) ||
            update.solutionDescription.toLowerCase().contains(searchQuery) ||
            (update.tags?.toLowerCase().contains(searchQuery) ?? false) ||
            update.category.toLowerCase().contains(searchQuery);
      }).toList();

      print('🔍 ${filteredUpdates.length} رکورد یافت شد برای: "$query"');
      return filteredUpdates;
    } catch (e) {
      print('❌ خطا در جستجو: $e');
      return [];
    }
  }

  /// فیلتر بر اساس دسته‌بندی
  Future<List<UpdateHistory>> getUpdatesByCategory(String category) async {
    try {
      final allUpdates = await getAllUpdatesFromJson();

      final filteredUpdates = allUpdates
          .where(
            (update) => update.category.toLowerCase() == category.toLowerCase(),
          )
          .toList();

      print('📂 ${filteredUpdates.length} رکورد در دسته "$category" یافت شد');
      return filteredUpdates;
    } catch (e) {
      print('❌ خطا در فیلتر دسته‌بندی: $e');
      return [];
    }
  }
}
