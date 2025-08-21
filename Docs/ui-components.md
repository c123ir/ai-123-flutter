# راهنمای کامپوننت‌های UI
## دستیار هوشمند یک دو سه

---

## 📋 فهرست مطالب

1. [معرفی](#معرفی)
2. [Design System](#design-system)
3. [Components](#components)
4. [Widgets](#widgets)
5. [Responsive Design](#responsive-design)
6. [Theming](#theming)
7. [Animation](#animation)
8. [Usage Examples](#usage-examples)

---

## 🎯 معرفی

این مستند شامل تمامی کامپوننت‌های UI و widget های سفارشی پروژه دستیار هوشمند یک دو سه می‌باشد. تمامی کامپوننت‌ها بر اساس Material Design 3 و با پشتیبانی کامل از زبان فارسی طراحی شده‌اند.

### **ویژگی‌های کلی**
- ✅ **RTL Support:** پشتیبانی کامل از راست به چپ
- ✅ **Persian Typography:** فونت Vazirmatn
- ✅ **Responsive Design:** سازگار با تمام سایزها
- ✅ **Dark/Light Theme:** پشتیبانی از تم تیره و روشن
- ✅ **Accessibility:** در نظر گیری معلولان
- ✅ **Performance:** بهینه‌سازی شده

---

## 🎨 Design System

### **Color Palette**

#### **Primary Colors**
```dart
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF667eea);
  static const Color primaryDark = Color(0xFF764ba2);
  static const Color primaryLight = Color(0xFF8B5CF6);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF43cea2);
  static const Color secondaryDark = Color(0xFF185a9d);
  
  // Status Colors
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF8F9FA);
  static const Color grey200 = Color(0xFFE9ECEF);
  static const Color grey300 = Color(0xFFDEE2E6);
  static const Color grey400 = Color(0xFFCED4DA);
  static const Color grey500 = Color(0xFFADB5BD);
  static const Color grey600 = Color(0xFF6C757D);
  static const Color grey700 = Color(0xFF495057);
  static const Color grey800 = Color(0xFF343A40);
  static const Color grey900 = Color(0xFF212529);
}
```

#### **Gradient Colors**
```dart
class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondary = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE3F2FD), // آبی روشن
      Color(0xFFF3E5F5), // بنفش روشن
      Color(0xFFE8F5E8), // سبز روشن
    ],
  );
}
```

### **Typography**
```dart
class AppTextStyles {
  static const String fontFamily = 'Vazirmatn';
  
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );
  
  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );
  
  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    color: AppColors.grey600,
  );
}
```

### **Spacing System**
```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### **Border Radius**
```dart
class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double round = 50.0;
}
```

---

## 🧩 Components

### **1. DashboardCard**
کارت آماری برای نمایش اطلاعات کلیدی در داشبورد

#### **Usage:**
```dart
DashboardCard(
  title: 'فروش کل',
  icon: Icons.shopping_cart_rounded,
  color: AppColors.success,
  value: '۵۸٬۹۰۰٬۰۰۰',
  subtitle: 'تومان این ماه',
  onTap: () {
    // Handle tap
  },
)
```

#### **Properties:**
```dart
class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String value;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? trailing;
  
  const DashboardCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.value,
    required this.subtitle,
    this.onTap,
    this.isLoading = false,
    this.trailing,
  }) : super(key: key);
}
```

#### **Visual Structure:**
```
┌─────────────────────────────────┐
│  [Icon]  Title          [Trail] │
│                                 │
│         Value                   │
│         Subtitle                │
│                                 │
└─────────────────────────────────┘
```

### **2. DashboardGraph**
نمودار خطی برای نمایش روند داده‌ها

#### **Usage:**
```dart
DashboardGraph(
  title: 'روند فروش ماهانه',
  data: [0.2, 0.4, 0.6, 0.8, 0.7, 0.9, 1.0],
  color: AppColors.primary,
  height: 200,
  showGrid: true,
  showPoints: true,
)
```

#### **Properties:**
```dart
class DashboardGraph extends StatelessWidget {
  final String title;
  final List<double> data;
  final Color color;
  final double height;
  final bool showGrid;
  final bool showPoints;
  final List<String>? labels;
  
  const DashboardGraph({
    Key? key,
    required this.title,
    required this.data,
    required this.color,
    this.height = 180,
    this.showGrid = false,
    this.showPoints = false,
    this.labels,
  }) : super(key: key);
}
```

### **3. AdminSidebar**
منوی کناری پنل مدیریت با افکت glassmorphism

#### **Usage:**
```dart
AdminSidebar(
  selectedIndex: 0,
  onMenuTap: (index) {
    setState(() {
      selectedIndex = index;
    });
  },
  menuItems: adminMenuItems,
  userInfo: UserInfo(
    name: 'مدیر سیستم',
    avatar: 'https://example.com/avatar.jpg',
    status: 'آنلاین',
  ),
)
```

#### **Properties:**
```dart
class AdminSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onMenuTap;
  final List<SidebarMenuItem> menuItems;
  final UserInfo? userInfo;
  final bool isCollapsed;
  
  const AdminSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onMenuTap,
    required this.menuItems,
    this.userInfo,
    this.isCollapsed = false,
  }) : super(key: key);
}
```

### **4. CustomButton**
دکمه سفارشی با انیمیشن و loading state

#### **Usage:**
```dart
CustomButton(
  text: 'ذخیره اطلاعات',
  onPressed: () async {
    // Handle button press
  },
  type: ButtonType.primary,
  size: ButtonSize.large,
  icon: Icons.save,
  isLoading: false,
  isDisabled: false,
)
```

#### **Types:**
```dart
enum ButtonType {
  primary,    // پر رنگ
  secondary,  // خالی با border
  text,       // فقط متن
  icon,       // فقط آیکون
}

enum ButtonSize {
  small,      // 32px height
  medium,     // 40px height
  large,      // 48px height
  extraLarge, // 56px height
}
```

### **5. CustomTextField**
فیلد ورودی سفارشی با validation

#### **Usage:**
```dart
CustomTextField(
  label: 'نام کاربری',
  hint: 'نام کاربری خود را وارد کنید',
  controller: usernameController,
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return 'نام کاربری الزامی است';
    }
    return null;
  },
  prefixIcon: Icons.person,
  textInputType: TextInputType.text,
  isRequired: true,
)
```

#### **Properties:**
```dart
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final TextInputType textInputType;
  final bool isPassword;
  final bool isRequired;
  final bool isReadOnly;
  final int maxLines;
  final Function(String)? onChanged;
}
```

### **6. LoadingIndicator**
اندیکاتور بارگذاری سفارشی

#### **Types:**
```dart
// Circular loading
LoadingIndicator.circular(
  size: LoadingSize.medium,
  color: AppColors.primary,
)

// Linear loading
LoadingIndicator.linear(
  value: 0.7, // 70% complete
  backgroundColor: AppColors.grey200,
  color: AppColors.primary,
)

// Dots loading
LoadingIndicator.dots(
  size: LoadingSize.small,
  color: AppColors.primary,
)
```

### **7. CustomCard**
کارت سفارشی با shadow و border radius

#### **Usage:**
```dart
CustomCard(
  child: Column(
    children: [
      Text('محتوای کارت'),
      // Other widgets
    ],
  ),
  padding: EdgeInsets.all(16),
  elevation: 2,
  borderRadius: 12,
  backgroundColor: Colors.white,
  onTap: () {
    // Handle tap
  },
)
```

### **8. EmptyState**
نمایش حالت خالی بودن لیست

#### **Usage:**
```dart
EmptyState(
  icon: Icons.inbox_outlined,
  title: 'موردی یافت نشد',
  description: 'هیچ محصولی در این دسته‌بندی وجود ندارد',
  actionText: 'افزودن محصول',
  onActionPressed: () {
    // Handle action
  },
)
```

---

## 📱 Responsive Design

### **Breakpoints**
```dart
class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;
}
```

### **Responsive Helper**
```dart
class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppBreakpoints.mobile;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppBreakpoints.mobile && width < AppBreakpoints.desktop;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppBreakpoints.desktop;
  }
  
  static double getResponsiveSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }
}
```

### **Usage Example:**
```dart
Container(
  padding: EdgeInsets.all(
    ResponsiveHelper.getResponsiveSize(
      context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
    ),
  ),
  child: Text('Responsive Content'),
)
```

---

## 🎭 Theming

### **App Theme**
```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Vazirmatn',
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      background: AppColors.grey100,
      error: AppColors.error,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(color: AppColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.grey600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      color: Colors.white,
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Vazirmatn',
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      surface: AppColors.grey800,
      background: AppColors.grey900,
      error: AppColors.error,
    ),
    // ... similar structure for dark theme
  );
}
```

### **Theme Usage**
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // Auto switch based on system
  home: MyHomePage(),
)
```

---

## 🎬 Animation

### **Custom Animations**

#### **1. Fade In Animation**
```dart
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  
  const FadeInAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
  }) : super(key: key);
}
```

#### **2. Slide Animation**
```dart
class SlideAnimation extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;
  
  const SlideAnimation({
    Key? key,
    required this.child,
    this.direction = SlideDirection.fromBottom,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);
}

enum SlideDirection {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
}
```

#### **3. Scale Animation**
```dart
class ScaleAnimation extends StatefulWidget {
  final Widget child;
  final double begin;
  final double end;
  final Duration duration;
  
  const ScaleAnimation({
    Key? key,
    required this.child,
    this.begin = 0.0,
    this.end = 1.0,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);
}
```

### **Page Transitions**
```dart
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType type;
  
  CustomPageRoute({
    required this.child,
    this.type = PageTransitionType.slideFromRight,
  }) : super(
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (type) {
        case PageTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        case PageTransitionType.slideFromRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        // ... other transition types
      }
    },
  );
}
```

---

## 🔧 Usage Examples

### **Example 1: Dashboard Screen**
```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.background,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'داشبورد مدیریت',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.grey800,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              
              // Stats Cards Row
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'فروش کل',
                      icon: Icons.shopping_cart_rounded,
                      color: AppColors.success,
                      value: '۵۸٬۹۰۰٬۰۰۰',
                      subtitle: 'تومان این ماه',
                    ),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: DashboardCard(
                      title: 'کاربران فعال',
                      icon: Icons.people_alt_rounded,
                      color: AppColors.info,
                      value: '۱۲۴',
                      subtitle: 'آنلاین الان',
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Chart
              DashboardGraph(
                title: 'روند فروش ماهانه',
                data: [0.2, 0.4, 0.6, 0.8, 0.7, 0.9, 1.0],
                color: AppColors.primary,
                showGrid: true,
                showPoints: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### **Example 2: Form Screen**
```dart
class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('افزودن کاربر جدید'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'نام کامل',
                controller: _nameController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'نام الزامی است';
                  }
                  return null;
                },
                prefixIcon: Icons.person,
                isRequired: true,
              ),
              
              SizedBox(height: AppSpacing.lg),
              
              CustomTextField(
                label: 'ایمیل',
                controller: _emailController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'ایمیل الزامی است';
                  }
                  if (!value!.contains('@')) {
                    return 'ایمیل معتبر نیست';
                  }
                  return null;
                },
                prefixIcon: Icons.email,
                textInputType: TextInputType.emailAddress,
                isRequired: true,
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              CustomButton(
                text: 'ذخیره کاربر',
                onPressed: _isLoading ? null : _handleSubmit,
                type: ButtonType.primary,
                size: ButtonSize.large,
                isLoading: _isLoading,
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Submit logic here
        await Future.delayed(Duration(seconds: 2)); // Simulate API call
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('کاربر با موفقیت ذخیره شد'),
            backgroundColor: AppColors.success,
          ),
        );
        
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در ذخیره کاربر'),
            backgroundColor: AppColors.error,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
```

### **Example 3: Product List**
```dart
class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فهرست محصولات'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to add product
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: LoadingIndicator.circular())
          : products.isEmpty
              ? EmptyState(
                  icon: Icons.shopping_bag_outlined,
                  title: 'محصولی یافت نشد',
                  description: 'هنوز محصولی اضافه نشده است',
                  actionText: 'افزودن محصول',
                  onActionPressed: () {
                    // Navigate to add product
                  },
                )
              : ListView.builder(
                  padding: EdgeInsets.all(AppSpacing.md),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return FadeInAnimation(
                      child: CustomCard(
                        margin: EdgeInsets.only(bottom: AppSpacing.md),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${product.price.toStringAsFixed(0)} تومان',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            // Navigate to product details
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
  
  Future<void> _loadProducts() async {
    try {
      final loadedProducts = await ProductService.getAllProducts();
      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا در بارگذاری محصولات'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
```

---

## 🎯 Best Practices

### **1. Performance**
- استفاده از `const` constructors
- پیاده‌سازی `shouldRebuild` در CustomPainter
- استفاده از `ListView.builder` برای لیست‌های طولانی
- Cache کردن تصاویر

### **2. Accessibility**
```dart
Semantics(
  label: 'دکمه ذخیره اطلاعات',
  child: CustomButton(
    text: 'ذخیره',
    onPressed: _handleSave,
  ),
)
```

### **3. Testing**
```dart
// Widget test example
testWidgets('DashboardCard should display correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: DashboardCard(
        title: 'Test Title',
        icon: Icons.test,
        color: Colors.blue,
        value: '100',
        subtitle: 'Test Subtitle',
      ),
    ),
  );
  
  expect(find.text('Test Title'), findsOneWidget);
  expect(find.text('100'), findsOneWidget);
  expect(find.text('Test Subtitle'), findsOneWidget);
});
```

### **4. Documentation**
```dart
/// کارت آماری برای نمایش اطلاعات کلیدی در داشبورد
/// 
/// این widget برای نمایش آمار مهم مثل فروش، تعداد کاربران و ... استفاده می‌شود.
/// 
/// Example:
/// ```dart
/// DashboardCard(
///   title: 'فروش کل',
///   icon: Icons.shopping_cart,
///   color: Colors.green,
///   value: '1,000,000',
///   subtitle: 'تومان',
/// )
/// ```
class DashboardCard extends StatelessWidget {
  /// عنوان کارت
  final String title;
  
  /// آیکون نمایشی
  final IconData icon;
  
  /// رنگ اصلی کارت
  final Color color;
  
  /// مقدار اصلی که نمایش داده می‌شود
  final String value;
  
  /// توضیح اضافی زیر مقدار
  final String subtitle;
}
```

---

**نسخه:** 1.0.0  
**آخرین به‌روزرسانی:** ۳۰ مرداد ۱۴۰۴  
**طراح UI/UX:** تیم طراحی دستیار هوشمند یک دو سه
