// lib/screens/update_history_screen.dart
// صفحه تاریخچه بروزرسانی - نمایش timeline توسعه پروژه

import 'package:flutter/material.dart';
import '../models/update_history.dart';
import '../services/update_history_service.dart';
import '../services/json_update_history_service.dart';
import '../widgets/update_history_card.dart';
import '../widgets/add_update_dialog_new.dart';

class UpdateHistoryScreen extends StatefulWidget {
  const UpdateHistoryScreen({super.key});

  @override
  State<UpdateHistoryScreen> createState() => _UpdateHistoryScreenState();
}

class _UpdateHistoryScreenState extends State<UpdateHistoryScreen>
    with TickerProviderStateMixin {
  final UpdateHistoryService _updateService = UpdateHistoryService();
  final JsonUpdateHistoryService _jsonService = JsonUpdateHistoryService();
  late TabController _tabController;

  List<UpdateHistory> _allUpdates = [];
  List<UpdateHistory> _filteredUpdates = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  String _selectedPriority = 'all';
  String _searchQuery = '';
  Map<String, int> _stats = {};

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// بارگذاری داده‌ها
  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // ابتدا از فایل JSON بخوانیم
      final jsonUpdates = await _jsonService.getAllUpdatesFromJson();

      // سپس از دیتابیس
      final dbUpdates = await _updateService.getAllUpdates();

      // ترکیب داده‌ها (JSON در اولویت است)
      final allUpdates = <UpdateHistory>[];
      allUpdates.addAll(jsonUpdates);

      // افزودن رکوردهای دیتابیس که در JSON نیستند
      for (final dbUpdate in dbUpdates) {
        final exists = jsonUpdates.any(
          (jsonUpdate) =>
              jsonUpdate.title == dbUpdate.title &&
              jsonUpdate.createdAt.day == dbUpdate.createdAt.day,
        );
        if (!exists) {
          allUpdates.add(dbUpdate);
        }
      }

      // مرتب‌سازی بر اساس تاریخ (جدیدترین اول)
      allUpdates.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _allUpdates = allUpdates;
        _filteredUpdates = allUpdates;
        _isLoading = false;
      });

      // بارگذاری آمار
      _loadStatistics();

      print(
        '✅ ${allUpdates.length} رکورد تاریخچه بارگذاری شد (${jsonUpdates.length} از JSON، ${dbUpdates.length} از DB)',
      );
    } catch (e) {
      print('❌ خطا در بارگذاری تاریخچه: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در بارگذاری تاریخچه: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// بارگذاری آمار
  Future<void> _loadStatistics() async {
    try {
      final stats = await _jsonService.getStatistics();
      setState(() {
        _stats = Map<String, int>.from(stats['categoryStats'] ?? {});
      });
    } catch (e) {
      print('خطا در بارگذاری آمار: $e');
    }
  }

  /// فیلتر کردن داده‌ها
  void _applyFilters() {
    _filteredUpdates = _allUpdates.where((update) {
      final categoryMatch =
          _selectedCategory == 'all' || update.category == _selectedCategory;
      final priorityMatch =
          _selectedPriority == 'all' || update.priority == _selectedPriority;
      final searchMatch =
          _searchQuery.isEmpty ||
          update.title.contains(_searchQuery) ||
          update.userProblem.contains(_searchQuery) ||
          update.solutionDescription.contains(_searchQuery);

      return categoryMatch && priorityMatch && searchMatch;
    }).toList();
  }

  /// تغییر متن جستجو
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  /// تغییر فیلتر دسته‌بندی
  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category ?? 'all';
      _applyFilters();
    });
  }

  /// تغییر فیلتر اولویت
  void _onPriorityChanged(String? priority) {
    setState(() {
      _selectedPriority = priority ?? 'all';
      _applyFilters();
    });
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
        body: Column(
          children: [
            // Header
            _buildHeader(),

            // آمار کلی
            _buildStatsCards(),

            // فیلترها و جستجو
            _buildFiltersSection(),

            // تب‌ها
            _buildTabBar(),

            // محتوای تب‌ها
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllUpdatesTab(),
                  _buildAllUpdatesTab(), // Features tab
                  _buildAllUpdatesTab(), // Bug fixes tab
                  _buildAllUpdatesTab(), // Recent tab
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddUpdateDialog,
          backgroundColor: const Color(0xFF2196F3),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'افزودن بروزرسانی',
            style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn'),
          ),
        ),
      ),
    );
  }

  /// ساخت header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'تاریخچه بروزرسانی',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'مشاهده تمام تغییرات و بهبودهای پروژه',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ساخت کارت‌های آمار
  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'کل بروزرسانی‌ها',
              (_stats['total'] ?? 0).toString(),
              Icons.update,
              const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'ویژگی‌های جدید',
              (_stats['features'] ?? 0).toString(),
              Icons.star,
              const Color(0xFF2196F3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'رفع باگ',
              (_stats['bugfixes'] ?? 0).toString(),
              Icons.bug_report,
              const Color(0xFFFF9800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'این ماه',
              (_stats['this_month'] ?? 0).toString(),
              Icons.calendar_today,
              const Color(0xFF9C27B0),
            ),
          ),
        ],
      ),
    );
  }

  /// ساخت کارت آمار واحد
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ],
      ),
    );
  }

  /// ساخت بخش فیلترها
  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // جستجو
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'جستجو در تاریخچه...',
              hintStyle: const TextStyle(fontFamily: 'Vazirmatn'),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: const TextStyle(fontFamily: 'Vazirmatn'),
          ),
          const SizedBox(height: 12),
          // فیلترها
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'دسته‌بندی',
                    labelStyle: const TextStyle(fontFamily: 'Vazirmatn'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('همه')),
                    DropdownMenuItem(
                      value: 'Feature',
                      child: Text('ویژگی جدید'),
                    ),
                    DropdownMenuItem(value: 'Bug Fix', child: Text('رفع باگ')),
                    DropdownMenuItem(
                      value: 'UI Update',
                      child: Text('بروزرسانی UI'),
                    ),
                    DropdownMenuItem(
                      value: 'Database',
                      child: Text('پایگاه داده'),
                    ),
                  ],
                  onChanged: _onCategoryChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'اولویت',
                    labelStyle: const TextStyle(fontFamily: 'Vazirmatn'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('همه')),
                    DropdownMenuItem(value: 'Low', child: Text('کم')),
                    DropdownMenuItem(value: 'Medium', child: Text('متوسط')),
                    DropdownMenuItem(value: 'High', child: Text('زیاد')),
                    DropdownMenuItem(value: 'Critical', child: Text('حیاتی')),
                  ],
                  onChanged: _onPriorityChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ساخت TabBar
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelColor: const Color(0xFF2196F3),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF2196F3),
        labelStyle: const TextStyle(fontFamily: 'Vazirmatn'),
        tabs: const [
          Tab(text: 'همه'),
          Tab(text: 'ویژگی‌ها'),
          Tab(text: 'رفع باگ'),
          Tab(text: 'اخیر'),
        ],
      ),
    );
  }

  /// ساخت تب تمام بروزرسانی‌ها
  Widget _buildAllUpdatesTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredUpdates.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'هیچ بروزرسانی یافت نشد',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredUpdates.length,
        itemBuilder: (context, index) {
          final update = _filteredUpdates[index];
          return UpdateHistoryCard(
            update: update,
            onEdit: (editedUpdate) async {
              await _updateService.updateHistory(editedUpdate);
              _loadData();
            },
            onDelete: (updateId) async {
              await _updateService.deleteUpdate(updateId);
              _loadData();
            },
            onAddComment: (updateId, comment) async {
              await _updateService.addUserComment(updateId, comment);
              _loadData();
            },
          );
        },
      ),
    );
  }
}
