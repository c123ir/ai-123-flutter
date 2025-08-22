# 📋 راهنمای مدیریت تاریخچه بروزرسانی MySQL

## 🎯 معرفی

سیستم تاریخچه بروزرسانی پروژه **دستیار هوشمند ۱۲۳** بر پایه دیتابیس MySQL طراحی شده و امکان ثبت، مدیریت و گزارش‌گیری از تمام تغییرات پروژه را فراهم می‌کند.

## 🗄️ ساختار دیتابیس

### دیتابیس: `ai_123`
### جدول: `update_history`

```sql
CREATE TABLE update_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,                     -- عنوان تغییر
    version VARCHAR(50) NOT NULL,                    -- نسخه پروژه
    shamsi_date VARCHAR(20) NOT NULL,                -- تاریخ شمسی
    shamsi_time VARCHAR(10) NOT NULL,                -- زمان
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- زمان سیستمی
    user_problem TEXT NOT NULL,                      -- شرح مشکل/نیاز
    solution_description TEXT NOT NULL,              -- شرح راه‌حل
    user_comment TEXT,                              -- نظرات اضافی
    tags TEXT,                                      -- برچسب‌ها
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    category ENUM('feature', 'bugfix', 'enhancement', 'security', 'testing') DEFAULT 'feature',
    status ENUM('completed', 'in_progress', 'planned') DEFAULT 'completed'
);
```

## 📝 روش‌های ثبت تاریخچه

### 1️⃣ روش مستقیم MySQL (توصیه شده)

#### ثبت ویژگی جدید:
```bash
mysql -u root ai_123 -e "
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'اضافه کردن سیستم ارسال پیامک',
    '1.2.0',
    '۱۴۰۴/۰۶/۰۱',
    '۱۰:۳۰',
    'نیاز به سیستم ارسال پیامک برای اطلاع‌رسانی به کاربران',
    'پیاده‌سازی SmsService با پشتیبانی چند سامانه پیامک و رابط کاربری مدیریت',
    'sms، notification، feature، service',
    'high',
    'feature',
    'completed'
);"
```

#### رفع باگ:
```bash
mysql -u root ai_123 -e "
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'رفع مشکل عدم نمایش صحیح اعداد فارسی',
    '1.2.1',
    '۱۴۰۴/۰۶/۰۱',
    '۱۵:۴۵',
    'اعداد فارسی و عربی در فرم‌ها صحیح تبدیل نمی‌شدند',
    'بروزرسانی PersianNumberUtils و اعمال تبدیل خودکار در تمام ورودی‌ها',
    'bugfix، persian numbers، forms، validation',
    'medium',
    'bugfix',
    'completed'
);"
```

#### بهبود UI:
```bash
mysql -u root ai_123 -e "
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'بهبود رابط کاربری داشبورد مدیریت',
    '1.2.2',
    '۱۴۰۴/۰۶/۰۲',
    '۰۹:۱۵',
    'نیاز به رابط کاربری بهتر و responsive برای داشبورد',
    'طراحی مجدد با Material Design 3، اضافه کردن dark theme و بهبود navigation',
    'ui، ux، dashboard، material design، responsive',
    'medium',
    'enhancement',
    'completed'
);"
```

### 2️⃣ روش برنامه‌نویسی (برای automation)

```dart
// lib/services/mysql_update_history_service.dart
await MySqlUpdateHistoryService.registerUpdate(
  title: 'عنوان تغییر',
  userProblem: 'شرح مشکل',
  solutionDescription: 'شرح راه‌حل',
  version: '1.2.0',
  category: 'feature',
  priority: 'high',
  tags: 'برچسب‌ها',
);
```

## 📊 گزارش‌گیری و مشاهده

### مشاهده آخرین تغییرات:
```bash
mysql -u root ai_123 -e "
SELECT id, title, version, shamsi_date, shamsi_time, priority, category 
FROM update_history 
ORDER BY id DESC 
LIMIT 10;"
```

### آمار بر اساس دسته‌بندی:
```bash
mysql -u root ai_123 -e "
SELECT 
    category,
    COUNT(*) as total_count,
    COUNT(CASE WHEN priority = 'critical' THEN 1 END) as critical_count,
    COUNT(CASE WHEN priority = 'high' THEN 1 END) as high_count,
    COUNT(CASE WHEN priority = 'medium' THEN 1 END) as medium_count,
    COUNT(CASE WHEN priority = 'low' THEN 1 END) as low_count
FROM update_history 
GROUP BY category 
ORDER BY total_count DESC;"
```

### تغییرات اخیر (هفته گذشته):
```bash
mysql -u root ai_123 -e "
SELECT title, shamsi_date, category, priority 
FROM update_history 
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY created_at DESC;"
```

### جستجو در توضیحات:
```bash
mysql -u root ai_123 -e "
SELECT id, title, shamsi_date, category 
FROM update_history 
WHERE solution_description LIKE '%کلمه مورد نظر%' 
   OR tags LIKE '%کلمه مورد نظر%'
ORDER BY id DESC;"
```

## 🏷️ راهنمای برچسب‌گذاری

### دسته‌بندی (category):
- **`feature`**: ویژگی‌های جدید
- **`bugfix`**: رفع باگ‌ها و مشکلات
- **`enhancement`**: بهبود ویژگی‌های موجود
- **`security`**: مسائل امنیتی
- **`testing`**: تست‌ها و validation

### اولویت (priority):
- **`critical`**: مشکلات بحرانی که باید فوری حل شوند
- **`high`**: تغییرات مهم با اولویت بالا
- **`medium`**: تغییرات معمولی (پیش‌فرض)
- **`low`**: تغییرات کم اهمیت

### وضعیت (status):
- **`completed`**: تکمیل شده (پیش‌فرض)
- **`in_progress`**: در حال انجام
- **`planned`**: برنامه‌ریزی شده

## 🎯 بهترین practice ها

### 1. عنوان واضح و مختصر
```
✅ صحیح: "اضافه کردن سیستم احراز هویت دو مرحله‌ای"
❌ نادرست: "بروزرسانی"
```

### 2. توضیح کامل مشکل
```
✅ صحیح: "کاربران نمی‌توانستند پس از ورود به حساب کاربری، تنظیمات پروفایل خود را ذخیره کنند"
❌ نادرست: "مشکل در پروفایل"
```

### 3. شرح دقیق راه‌حل
```
✅ صحیح: "اضافه کردن validation برای فرم‌ها، بروزرسانی UserService و رفع مشکل API call"
❌ نادرست: "رفع شد"
```

### 4. برچسب‌گذاری مناسب
```
✅ صحیح: "authentication، security، user management، validation"
❌ نادرست: "fix"
```

## ⚡ دستورات سریع

### ثبت سریع ویژگی:
```bash
mysql -u root ai_123 -e "
INSERT INTO update_history (title, version, shamsi_date, shamsi_time, user_problem, solution_description, tags, priority, category) 
VALUES ('عنوان', '1.x.x', 'تاریخ', 'زمان', 'مشکل', 'راه‌حل', 'تگ‌ها', 'medium', 'feature');"
```

### نمایش آخرین رکورد:
```bash
mysql -u root ai_123 -e "SELECT * FROM update_history ORDER BY id DESC LIMIT 1\G"
```

### تعداد کل رکوردها:
```bash
mysql -u root ai_123 -e "SELECT COUNT(*) as total_updates FROM update_history;"
```

## 🔧 نکات فنی

### تاریخ شمسی:
```
فرمت: ۱۴۰۴/۰۶/۰۱ (سال/ماه/روز)
مثال: ۱۴۰۴/۰۶/۰۱ = ۱ شهریور ۱۴۰۴
```

### زمان:
```
فرمت: ۱۰:۳۰ (ساعت:دقیقه)
سیستم ۲۴ ساعته
```

### رمزگذاری:
```
استفاده از UTF-8 برای پشتیبانی کامل از متن فارسی
```

## 🎉 نتیجه‌گیری

سیستم تاریخچه بروزرسانی MySQL ابزاری قدرتمند برای:
- 📊 **ردیابی دقیق پیشرفت پروژه**
- 📈 **تحلیل روند توسعه**
- 🔍 **جستجو و گزارش‌گیری سریع**
- 👥 **همکاری بهتر تیم**
- 📋 **مستندسازی خودکار**

با استفاده از دستورات ساده MySQL، می‌توانید به راحتی تمام تغییرات پروژه را ثبت و مدیریت کنید.

---

💡 **نکته:** همیشه قبل از ثبت، از درستی اطلاعات و کامل بودن توضیحات اطمینان حاصل کنید.
