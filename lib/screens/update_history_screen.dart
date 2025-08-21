// lib/screens/update_history_screen.dart
// صفحه تاریخچه بروزرسانی - نمایش timeline توسعه پروژه

import 'package:flutter/material.dart';
import '../models/update_history.dart';
import '../services/update_history_service.dart';
import '../widgets/update_history_card.dart';
import '../widgets/add_update_dialog.dart';

class UpdateHistoryScreen extends StatefulWidget {
  const UpdateHistoryScreen({super.key});

  @override
  State<UpdateHistoryScreen> createState() => _UpdateHistoryScreenState();
}

class _UpdateHistoryScreenState extends State<UpdateHistoryScreen>
    with TickerProviderStateMixin {
  final UpdateHistoryService _updateService = UpdateHistoryService();
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
      final [updates, stats] = await Future.wait([
        _updateService.getAllUpdates(),
        _updateService.getUpdateStats(),
      ]);

      setState(() {
        _allUpdates = updates as List<UpdateHistory>;
        _stats = stats as Map<String, int>;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      print('❌ خطا در بارگذاری داده‌ها: $e');
      setState(() => _isLoading = false);
    }
  }

  /// اعمال فیلترها
  void _applyFilters() {
    _filteredUpdates = _allUpdates.where((update) {
      bool matchesCategory =
          _selectedCategory == 'all' || update.category == _selectedCategory;
      bool matchesPriority =
          _selectedPriority == 'all' || update.priority == _selectedPriority;
      bool matchesSearch =
          _searchQuery.isEmpty ||
          update.title.contains(_searchQuery) ||
          update.userProblem.contains(_searchQuery) ||
          update.solutionDescription.contains(_searchQuery);

      return matchesCategory && matchesPriority && matchesSearch;
    }).toList();
  }

  /// جستجو
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
    final result = await showDialog<UpdateHistory>(
      context: context,
      builder: (context) => const AddUpdateDialog(),
    );

    if (result != null) {
      await _loadData(); // بارگذاری مجدد داده‌ها
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ بروزرسانی جدید اضافه شد'),
            backgroundColor: Colors.green,
          ),
        );
      }
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

            // محتوا
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllUpdatesTab(),
                  _buildTimelineTab(),
                  _buildStatsTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddUpdateDialog,
          backgroundColor: const Color(0xFF1976D2),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'بروزرسانی جدید',
            style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn'),
          ),
        ),
      ),
    );
  }

  /// ساخت هدر
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 تاریخچه بروزرسانی',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'مدیریت و ردیابی تمام تغییرات پروژه',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// کارت‌های آمار
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
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'ویژگی‌های جدید',
              (_stats['features'] ?? 0).toString(),
              Icons.new_releases,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'رفع باگ',
              (_stats['bugfixes'] ?? 0).toString(),
              Icons.bug_report,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'این ماه',
              (_stats['this_month'] ?? 0).toString(),
              Icons.calendar_today,
              Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  /// کارت آمار تکی
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Vazirmatn',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Vazirmatn',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// بخش فیلترها
  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // جستجو
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'جستجو در بروزرسانی‌ها...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),

              // فیلترها
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'دسته‌بندی',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('همه')),
                        DropdownMenuItem(
                          value: 'feature',
                          child: Text('ویژگی جدید'),
                        ),
                        DropdownMenuItem(
                          value: 'bugfix',
                          child: Text('رفع باگ'),
                        ),
                        DropdownMenuItem(
                          value: 'enhancement',
                          child: Text('بهبود'),
                        ),
                        DropdownMenuItem(
                          value: 'security',
                          child: Text('امنیت'),
                        ),
                      ],
                      onChanged: _onCategoryChanged,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'اولویت',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('همه')),
                        DropdownMenuItem(
                          value: 'critical',
                          child: Text('بحرانی'),
                        ),
                        DropdownMenuItem(value: 'high', child: Text('بالا')),
                        DropdownMenuItem(value: 'medium', child: Text('متوسط')),
                        DropdownMenuItem(value: 'low', child: Text('پایین')),
                      ],
                      onChanged: _onPriorityChanged,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// نوار تب‌ها
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1976D2),
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: const Color(0xFF1976D2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        tabs: const [
          Tab(icon: Icon(Icons.list), text: 'همه'),
          Tab(icon: Icon(Icons.timeline), text: 'زمان‌بندی'),
          Tab(icon: Icon(Icons.analytics), text: 'آمار'),
          Tab(icon: Icon(Icons.settings), text: 'تنظیمات'),
        ],
      ),
    );
  }

  /// تب همه بروزرسانی‌ها
  Widget _buildAllUpdatesTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredUpdates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'هیچ بروزرسانی یافت نشد',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
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

  /// تب زمان‌بندی
  Widget _buildTimelineTab() {
    return const Center(
      child: Text(
        '🚧 Timeline در حال توسعه...',
        style: TextStyle(fontSize: 18, fontFamily: 'Vazirmatn'),
      ),
    );
  }

  /// تب آمار
  Widget _buildStatsTab() {
    return const Center(
      child: Text(
        '📊 آمار تفصیلی در حال توسعه...',
        style: TextStyle(fontSize: 18, fontFamily: 'Vazirmatn'),
      ),
    );
  }

  /// تب تنظیمات
  Widget _buildSettingsTab() {
    return const Center(
      child: Text(
        '⚙️ تنظیمات در حال توسعه...',
        style: TextStyle(fontSize: 18, fontFamily: 'Vazirmatn'),
      ),
    );
  }
}
