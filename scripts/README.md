# 🔧 Scripts - اسکریپت‌های خودکار

این پوشه شامل اسکریپت‌های مفید برای مدیریت پروژه و ارسال خودکار به GitHub است.

## 📋 لیست اسکریپت‌ها

### 🚀 `quick-push.sh`
ارسال سریع تغییرات به GitHub با بررسی‌های خودکار

```bash
# استفاده
./scripts/quick-push.sh "feat: add new feature"

# مثال
./scripts/quick-push.sh "fix: resolve login issue"
./scripts/quick-push.sh "docs: update README"
```

**ویژگی‌ها:**
- ✅ بررسی فرمت کد
- ✅ تحلیل کد با flutter analyze
- ✅ اجرای تست‌ها
- ✅ Commit و Push خودکار
- ✅ نمایش لینک GitHub

### 📦 `create-release.sh`
ایجاد release جدید با تمام مراحل خودکار

```bash
# استفاده
./scripts/create-release.sh [major|minor|patch|version]

# مثال‌ها
./scripts/create-release.sh patch     # 1.0.0 → 1.0.1
./scripts/create-release.sh minor     # 1.0.1 → 1.1.0
./scripts/create-release.sh major     # 1.1.0 → 2.0.0
./scripts/create-release.sh 2.5.0     # نسخه سفارشی
```

**ویژگی‌ها:**
- 🔄 بروزرسانی نسخه در pubspec.yaml
- 📝 بروزرسانی CHANGELOG.md
- 🏷️ ایجاد Git tag
- 🚀 Push به GitHub
- 🤖 راه‌اندازی GitHub Actions

### 🔄 `sync-upstream.sh`
هماهنگ‌سازی با repository اصلی (برای contributors)

```bash
# استفاده
./scripts/sync-upstream.sh
```

**ویژگی‌ها:**
- 📥 Fetch از upstream
- 🔄 Merge با main branch
- 📤 Push به origin
- 🔀 Rebase branch فعلی
- 📦 بروزرسانی dependencies

## 🛠 نصب و تنظیم

### 1. مجوز اجرا
```bash
chmod +x scripts/*.sh
```

### 2. اضافه کردن به PATH (اختیاری)
```bash
# در ~/.bashrc یا ~/.zshrc
export PATH="$PATH:$(pwd)/scripts"

# سپس می‌توانید مستقیماً استفاده کنید:
quick-push.sh "commit message"
```

### 3. Alias ایجاد کردن (اختیاری)
```bash
# در ~/.bashrc یا ~/.zshrc
alias qp='./scripts/quick-push.sh'
alias release='./scripts/create-release.sh'
alias sync='./scripts/sync-upstream.sh'

# استفاده:
qp "fix: bug fix"
release patch
sync
```

## 📖 راهنمای استفاده

### Workflow روزانه
```bash
# 1. شروع کار - هماهنگ‌سازی
./scripts/sync-upstream.sh

# 2. توسعه کد
# ... کدنویسی ...

# 3. ارسال تغییرات
./scripts/quick-push.sh "feat: implement user dashboard"

# 4. ایجاد release (هنگام آماده بودن)
./scripts/create-release.sh minor
```

### Git Flow با Scripts
```bash
# ایجاد feature branch
git checkout -b feature/new-feature

# توسعه و تست
# ... کدنویسی ...

# ارسال feature
./scripts/quick-push.sh "feat: add awesome feature"

# ایجاد Pull Request در GitHub
# پس از merge، ایجاد release
git checkout main
git pull origin main
./scripts/create-release.sh minor
```

## 🔧 سفارشی‌سازی

### تنظیمات محیطی
می‌توانید متغیرهای محیطی تنظیم کنید:

```bash
# در ~/.bashrc یا ~/.zshrc
export GIT_AUTHOR_NAME="نام شما"
export GIT_AUTHOR_EMAIL="email@example.com"
export FLUTTER_ROOT="/path/to/flutter"
```

### Hook های Git
```bash
# تنظیم pre-commit hook
ln -s ../../scripts/quick-push.sh .git/hooks/pre-commit
```

## 🐛 عیب‌یابی

### مشکلات رایج

#### مجوز اجرا
```bash
# خطا: Permission denied
chmod +x scripts/quick-push.sh
```

#### مسیر Flutter
```bash
# خطا: flutter command not found
export PATH="$PATH:/path/to/flutter/bin"
```

#### مشکل Git Remote
```bash
# بررسی remote ها
git remote -v

# اضافه کردن origin
git remote add origin https://github.com/username/repo.git
```

#### Conflict در Rebase
```bash
# حل conflict دستی
git status
# ویرایش فایل های conflict
git add .
git rebase --continue
```

## 📝 نکات مهم

- 🔍 همیشه قبل از استفاده status پروژه را بررسی کنید
- 💾 قبل از script های خطرناک backup تهیه کنید
- 🧪 اسکریپت ها را ابتدا در محیط تست امتحان کنید
- 📚 Log ها را برای عیب‌یابی نگه دارید

## 🔗 منابع مفید

- [Git Documentation](https://git-scm.com/doc)
- [Flutter CLI Reference](https://docs.flutter.dev/reference/flutter-cli)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)

---

> **نکته:** این اسکریپت‌ها برای تسهیل کار طراحی شده‌اند. در صورت بروز مشکل، می‌توانید دستی عملیات را انجام دهید.
