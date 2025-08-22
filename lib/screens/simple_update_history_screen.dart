// تست ساده برای UpdateHistoryScreen
import 'package:flutter/material.dart';

class SimpleUpdateHistoryScreen extends StatefulWidget {
  const SimpleUpdateHistoryScreen({super.key});

  @override
  State<SimpleUpdateHistoryScreen> createState() =>
      _SimpleUpdateHistoryScreenState();
}

class _SimpleUpdateHistoryScreenState extends State<SimpleUpdateHistoryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('🚀 SimpleUpdateHistoryScreen initState() called');
    _loadData();
  }

  @override
  void dispose() {
    print('🛑 SimpleUpdateHistoryScreen dispose() called');
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔄 SimpleUpdateHistoryScreen didChangeDependencies() called');
  }

  Future<void> _loadData() async {
    print('🔄 شروع بارگذاری داده‌ها... (instance: ${hashCode})');

    // حذف delay غیرضروری برای بهبود تجربه کاربری
    // await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      print('✅ Widget mounted - setState قرار است فراخوانی شود');
      setState(() {
        _isLoading = false;
      });
      print('✅ setState کامل شد');
    } else {
      print('❌ Widget unmounted - setState لغو شد');
    }

    print('✅ بارگذاری کامل شد (instance: ${hashCode})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تاریخچه بروزرسانی - ساده'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('در حال بارگذاری...'),
                ],
              ),
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 80, color: Colors.green),
                  SizedBox(height: 16),
                  Text('بارگذاری کامل شد!'),
                  Text('سیستم تاریخچه آماده است'),
                ],
              ),
            ),
    );
  }
}
