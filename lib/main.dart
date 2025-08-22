import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'screens/admin_dashboard.dart';
import 'screens/customer_app.dart';

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

  // با MySQL حالا نیازی به مقداردهی SQLite نیست
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: 'دستیار هوشمند یک دو سه',
        theme: ThemeData(
          fontFamily: 'Vazirmatn',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LayoutBuilder(
          builder: (context, constraints) {
            // اگر عرض صفحه بزرگ باشد، نسخه ادمین نمایش داده شود
            if (constraints.maxWidth > 800) {
              return const AdminDashboardScreen();
            } else {
              return const CustomerAppScreen();
            }
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
