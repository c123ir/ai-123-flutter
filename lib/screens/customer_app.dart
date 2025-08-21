import 'package:flutter/material.dart';

class CustomerAppScreen extends StatelessWidget {
  const CustomerAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اپلیکیشن مشتری')),
      body: Center(
        child: Text(
          'خوش آمدید مشتری عزیز!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
