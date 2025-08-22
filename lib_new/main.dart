// lib_new/main.dart
// نقطه ورود اصلی اپلیکیشن - Clean Architecture Implementation

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'features/admin/admin.dart';
import 'features/customer/customer.dart';

void main() {
  // مدیریت خطاهای Flutter برای وب
  if (kIsWeb) {
    FlutterError.onError = (FlutterErrorDetails details) {
      // نادیده گرفتن خطاهای trackpad در وب
      if (details.exception.toString().contains('PointerDeviceKind.trackpad')) {
        return;
      }
      FlutterError.presentError(details);
    };
  }

  // اجرای اپلیکیشن
  runApp(const MyApp());
}

/// اپلیکیشن اصلی
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: 'دستیار هوشمند یک دو سه',
        theme: ThemeData(
          fontFamily: 'Vazirmatn',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LayoutBuilder(
          builder: (context, constraints) {
            // اگر عرض صفحه بزرگ باشد، نسخه ادمین نمایش داده شود
            if (constraints.maxWidth > 800) {
              return const AdminDashboardScreen();
            } else {
              return const CustomerDashboardScreen();
            }
          },
        ),
      ),
    );
  }
}
