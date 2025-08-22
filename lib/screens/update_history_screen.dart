// lib/screens/update_history_screen.dart
// صفحه تاریخچه بروزرسانی - نمایش timeline توسعه پروژه

import 'package:flutter/material.dart';
import '../models/update_history.dart';
import '../services/update_history_service.dart';
import '../services/json_update_history_service.dart';
import '../widgets/add_update_dialog.dart';

class UpdateHistoryScreen extends StatefulWidget {
  const UpdateHistoryScreen({super.key});

  @override
  State<UpdateHistoryScreen> createState() => _UpdateHistoryScreenState();
}

class _UpdateHistoryScreenState extends State<UpdateHistoryScreen> {
  final UpdateHistoryService _updateService = UpdateHistoryService();
  final JsonUpdateHistoryService _jsonService = JsonUpdateHistoryService();

  List<UpdateHistory> _allUpdates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// بارگذاری داده‌ها
  Future<void> _loadData() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      // بارگذاری داده‌ها از JSON
      final jsonUpdates = await _jsonService.getAllUpdatesFromJson();
      print('📋 تعداد رکوردهای JSON: ${jsonUpdates.length}');

      // بارگذاری داده‌ها از دیتابیس
      final dbUpdates = await _updateService.getAllUpdates();
      print('📋 تعداد رکوردهای دیتابیس: ${dbUpdates.length}');

      // ترکیب داده‌ها و حذف duplicate ها بر اساس ID
      final Map<int, UpdateHistory> uniqueUpdates = {};

      // ابتدا JSON ها را اضافه کن (اولویت بالاتر)
      for (final update in jsonUpdates) {
        uniqueUpdates[update.id ?? 0] = update;
      }

      // سپس DB records را اضافه کن (فقط اگر ID تکراری نباشد)
      for (final update in dbUpdates) {
        final id = update.id ?? 0;
        if (!uniqueUpdates.containsKey(id)) {
          uniqueUpdates[id] = update;
        }
      }

      _allUpdates = uniqueUpdates.values.toList();

      // مرتب‌سازی بر اساس ID نزولی (جدیدترین ابتدا)
      _allUpdates.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

      print('✅ کل رکوردهای یکتا: ${_allUpdates.length}');
    } catch (e) {
      print('❌ خطا در بارگذاری: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// نمایش دیالوگ افزودن بروزرسانی
  Future<void> _showAddUpdateDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddUpdateDialog(
        onUpdateAdded: () async {
          await _loadData(); // بارگذاری مجدد داده‌ها
        },
      ),
    );

    if (result == true) {
      // بارگذاری مجدد داده‌ها در صورت موفقیت
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text('تاریخچه بروزرسانی'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddUpdateDialog,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('افزودن بروزرسانی'),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allUpdates.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('هیچ رکوردی یافت نشد'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allUpdates.length,
        itemBuilder: (context, index) {
          final update = _allUpdates[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    update.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    update.solutionDescription,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(
                        label: Text(update.category),
                        backgroundColor: Colors.blue.withOpacity(0.1),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(update.priority),
                        backgroundColor: Colors.orange.withOpacity(0.1),
                      ),
                      const Spacer(),
                      Text(
                        update.shamsiDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
