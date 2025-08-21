// Smart Assistant 123 - Widget Tests
// تست‌های اصلی برای کامپوننت‌های UI

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_123/main.dart';

void main() {
  group('Smart Assistant 123 Tests', () {
    testWidgets('App should start without errors', (WidgetTester tester) async {
      // بناء اپلیکیشن و تریگر فریم
      await tester.pumpWidget(const MyApp());

      // بررسی که اپ لود شده است
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Should load basic UI structure', (WidgetTester tester) async {
      // بناء اپلیکیشن
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // بررسی وجود ساختار اصلی UI
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });
  });

  group('Model Tests', () {
    test('Basic model test', () {
      // تست ساده برای اطمینان از کارکرد تست framework
      expect(1 + 1, equals(2));
      expect('Smart Assistant 123'.length, greaterThan(0));
    });
  });
}
