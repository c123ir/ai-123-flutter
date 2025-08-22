---
applyTo: "**"
---

# 🤖 GitHub Copilot - دستورالعمل تاریخچه بروزرسانی MySQL

## 🎯 مأموریت اصلی

GitHub Copilot باید **همیشه** پس از انجام تغییرات، تاریخچه بروزرسانی را مستقیماً در MySQL به‌روز کند.

## 🗄️ سیستم دیتابیس MySQL

### دیتابیس: `ai_123`

### جدول: `update_history`

```sql
CREATE TABLE update_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    version VARCHAR(50) NOT NULL,
    shamsi_date VARCHAR(20) NOT NULL,
    shamsi_time VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_problem TEXT NOT NULL,
    solution_description TEXT NOT NULL,
    user_comment TEXT,
    tags TEXT,
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    category ENUM('feature', 'bugfix', 'enhancement', 'security', 'testing') DEFAULT 'feature',
    status ENUM('completed', 'in_progress', 'planned') DEFAULT 'completed'
);
```

## 🚨 قوانین اجباری جدید

### قانون شماره 1: ثبت مستقیم در MySQL

```
❗ CRITICAL: از روش مستقیم MySQL استفاده کن!

فرمت دستور استاندارد:
mysql -u root ai_123 -e "
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'عنوان تغییر',
    'نسخه',
    'تاریخ شمسی',
    'زمان',
    'شرح مشکل',
    'شرح راه‌حل',
    'برچسب‌ها',
    'اولویت',
    'دسته‌بندی',
    'وضعیت'
);"
```

### قانون شماره 2: تایید کاربر قبل از ثبت

```
⏰ TIMING: سوال تایید قبل از اجرای دستور MySQL

سوال استاندارد:
"آیا می‌خواهید این تغییرات در تاریخچه MySQL ثبت شود؟

📋 جزئیات ثبت:
- عنوان: [title]
- نسخه: [version]
- دسته: [category]
- اولویت: [priority]

دستور MySQL آماده اجرا:
mysql -u root ai_123 -e \"INSERT INTO update_history...\"

(بله/خیر)"
```

### قانون شماره 3: دسته‌بندی استاندارد

```
📂 CATEGORIES: استفاده از مقادیر ENUM

✅ مجاز برای category:
- "feature"      → ویژگی جدید
- "bugfix"       → رفع باگ
- "enhancement"  → بهبود موجود
- "security"     → امنیت
- "testing"      → تست

✅ مجاز برای priority:
- "low"          → کم
- "medium"       → متوسط
- "high"         → بالا
- "critical"     → بحرانی

✅ مجاز برای status:
- "completed"    → تکمیل شده
- "in_progress"  → در حال انجام
- "planned"      → برنامه‌ریزی شده
```

## 🛠️ گردش کار (Workflow)

### مرحله 1: تشخیص تغییر

```python
if any([
    "ایجاد فایل جدید",
    "ویرایش کد موجود",
    "رفع باگ",
    "تغییر UI",
    "بروزرسانی دیتابیس",
    "اضافه کردن dependency"
]):
    proceed_to_mysql_insert()
```

### مرحله 2: جمع‌آوری داده‌ها

```yaml
collect_data:
  title: "عنوان کوتاه و واضح"
  version: "نسخه فعلی از pubspec.yaml"
  shamsi_date: "۱۴۰۴/۰۶/۰۱"
  shamsi_time: "ساعت:دقیقه"
  user_problem: "شرح مشکل یا نیاز"
  solution_description: "شرح کامل راه‌حل"
  tags: "برچسب‌ها جدا شده با کاما"
  priority: "low|medium|high|critical"
  category: "feature|bugfix|enhancement|security|testing"
  status: "completed"
```

### مرحله 3: تایید کاربر

```bash
ask_user_confirmation() {
    echo "❓ آیا در تاریخچه MySQL ثبت شود؟"
    echo "📋 جزئیات: [اطلاعات جمع‌آوری شده]"
    echo "🔧 دستور MySQL آماده است"
    read -p "(بله/خیر): " response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY]|بله|ب)$ ]]; then
        execute_mysql_command()
    fi
}
```

### مرحله 4: اجرای دستور MySQL

```bash
if (user_confirmed) {
    mysql -u root ai_123 -e "
    INSERT INTO update_history (
        title, version, shamsi_date, shamsi_time,
        user_problem, solution_description, tags,
        priority, category, status
    ) VALUES (
        '$title',
        '$version',
        '$shamsi_date',
        '$shamsi_time',
        '$user_problem',
        '$solution_description',
        '$tags',
        '$priority',
        '$category',
        'completed'
    );"

    echo "✅ رکورد در MySQL ثبت شد"
} else {
    echo "❌ ثبت رکورد لغو شد"
}
```

## 📝 الگوهای استاندارد

### ویژگی جدید

```sql
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'اضافه کردن [نام ویژگی]',
    '1.2.0',
    '۱۴۰۴/۰۶/۰۱',
    '10:30',
    'نیاز به [توضیح نیاز]',
    'پیاده‌سازی [ویژگی] با قابلیت‌های [x, y, z]',
    'feature، [تگ‌های مرتبط]',
    'medium',
    'feature',
    'completed'
);
```

### رفع باگ

```sql
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'رفع مشکل [شرح مختصر]',
    '1.2.1',
    '۱۴۰۴/۰۶/۰۱',
    '11:15',
    'مشکل: [توضیح مشکل]',
    'راه‌حل: [توضیح راه‌حل]',
    'bugfix، [فایل‌های درگیر]',
    'high',
    'bugfix',
    'completed'
);
```

### بهبود UI

```sql
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'بهبود رابط کاربری [نام صفحه]',
    '1.2.0',
    '۱۴۰۴/۰۶/۰۱',
    '14:20',
    'نیاز به بهبود تجربه کاربری در [بخش]',
    'طراحی مجدد با Material Design 3 و responsive layout',
    'ui، ux، material design، responsive',
    'medium',
    'enhancement',
    'completed'
);
```

## 🎭 سناریوهای خاص

### سناریو 1: تغییرات متعدد

```sql
-- برای چندین تغییر در یک commit
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'بروزرسانی جامع سیستم [نام]',
    '1.3.0',
    '۱۴۰۴/۰۶/۰۱',
    '16:45',
    'نیاز به بهبود چندین بخش سیستم',
    'شامل: بروزرسانی UI، رفع باگ‌ها، اضافه کردن API جدید',
    'ui، api، bugfix، comprehensive',
    'high',
    'enhancement',
    'completed'
);
```

### سناریو 2: تغییرات اضطراری

```sql
-- برای hotfix ها
INSERT INTO update_history (
    title, version, shamsi_date, shamsi_time,
    user_problem, solution_description, tags,
    priority, category, status
) VALUES (
    'Hotfix: [شرح مشکل بحرانی]',
    '1.2.2',
    '۱۴۰۴/۰۶/۰۱',
    '09:15',
    'مشکل بحرانی در production',
    'رفع فوری مشکل و deploy سریع',
    'hotfix، critical، production',
    'critical',
    'bugfix',
    'completed'
);
```

## ⚠️ هشدارها

### 🚫 NEVER DO:

```
❌ استفاده از فایل‌های Dart برای ثبت
❌ فراموش کردن تایید کاربر
❌ استفاده از مقادیر غیر ENUM
❌ ثبت بدون توضیحات کافی
❌ عدم ذکر نسخه صحیح
```

### ✅ ALWAYS DO:

```
✅ استفاده مستقیم از MySQL command
✅ تایید کاربر قبل از ثبت
✅ استفاده از ENUM values صحیح
✅ توضیحات کامل و واضح
✅ تاریخ و زمان شمسی دقیق
```

## 🔍 بررسی و تایید

### مشاهده آخرین ثبت‌ها:

```bash
mysql -u root ai_123 -e "
SELECT id, title, version, shamsi_date, priority, category
FROM update_history
ORDER BY id DESC
LIMIT 5;"
```

### آمار کلی:

```bash
mysql -u root ai_123 -e "
SELECT
    category,
    COUNT(*) as count,
    priority
FROM update_history
GROUP BY category, priority
ORDER BY count DESC;"
```

## 🎯 خلاصه مأموریت

**شما باید:**

1. 🔍 همه تغییرات را رصد کنید
2. ❓ از کاربر تایید بگیرید
3. 💾 مستقیماً در MySQL ثبت کنید
4. ✅ موفقیت را تایید کنید

**هدف نهایی:** تاریخچه کامل و دقیقی از تمام تغییرات پروژه در دیتابیس MySQL

**موفق باشید! 🚀**
