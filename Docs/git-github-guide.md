# راهنمای Git و GitHub - پروژه Smart Assistant 123

## 📋 فهرست مطالب
- [مقدمه](#مقدمه)
- [تنظیمات اولیه Git](#تنظیمات-اولیه-git)
- [دستورات Git پایه](#دستورات-git-پایه)
- [کار با GitHub](#کار-با-github)
- [GitHub Actions و CI/CD](#github-actions-و-cicd)
- [مدیریت Branch](#مدیریت-branch)
- [Release و Versioning](#release-و-versioning)
- [نکات امنیتی](#نکات-امنیتی)

## 🎯 مقدمه

این راهنما تمامی مراحل کار با Git و GitHub برای پروژه Smart Assistant 123 را شرح می‌دهد.

### مخزن پروژه
```
Repository: https://github.com/c123ir/ai-123-flutter.git
Owner: c123ir
Main Branch: main
```

## ⚙️ تنظیمات اولیه Git

### نصب Git
```bash
# macOS
brew install git

# Ubuntu/Debian
sudo apt install git

# Windows
# دانلود از: https://git-scm.com/download/win
```

### تنظیم هویت کاربر
```bash
git config --global user.name "نام شما"
git config --global user.email "email@example.com"
git config --global init.defaultBranch main
```

### Clone کردن پروژه
```bash
git clone https://github.com/c123ir/ai-123-flutter.git
cd ai-123-flutter
```

## 🔧 دستورات Git پایه

### بررسی وضعیت
```bash
# بررسی وضعیت فایلها
git status

# مشاهده تاریخچه commit ها
git log --oneline

# مشاهده تفاوت تغییرات
git diff
```

### اضافه کردن و Commit
```bash
# اضافه کردن فایل خاص
git add lib/models/new_model.dart

# اضافه کردن همه فایلها
git add .

# Commit با پیام توضیحی
git commit -m "feat: add new model for user management"

# Commit با توضیحات کامل
git commit -m "feat: add user authentication

- Add User model with validation
- Implement JWT token handling
- Add password encryption
- Update database schema"
```

### Push و Pull
```bash
# ارسال به GitHub
git push origin main

# دریافت آخرین تغییرات
git pull origin main

# Push اولین بار
git push -u origin main
```

## 🌐 کار با GitHub

### تنظیم Remote
```bash
# اضافه کردن remote
git remote add origin https://github.com/c123ir/ai-123-flutter.git

# مشاهده remote ها
git remote -v

# تغییر URL remote
git remote set-url origin https://github.com/c123ir/ai-123-flutter.git
```

### کلون و Fork
```bash
# کلون مخزن اصلی
git clone https://github.com/c123ir/ai-123-flutter.git

# اضافه کردن upstream برای fork
git remote add upstream https://github.com/original/ai-123-flutter.git
```

## 🤖 GitHub Actions و CI/CD

### ایجاد Workflow برای Flutter

ایجاد فایل `.github/workflows/flutter.yml`:

```yaml
name: Flutter CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.8.1'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test
    
    - name: Analyze code
      run: flutter analyze
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Build Web
      run: flutter build web --release
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: flutter-builds
        path: |
          build/app/outputs/flutter-apk/
          build/web/

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.8.1'
    
    - name: Build Web
      run: |
        flutter pub get
        flutter build web --release
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

### Workflow برای Release خودکار

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.8.1'
    
    - name: Build APK
      run: |
        flutter pub get
        flutter build apk --release
    
    - name: Create Release
      uses: softprops/action-gh-release@v1
      with:
        files: build/app/outputs/flutter-apk/app-release.apk
        body: |
          ## تغییرات این نسخه
          - بهبود عملکرد
          - رفع باگ های شناخته شده
          - اضافه شدن ویژگی های جدید
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## 🌿 مدیریت Branch

### ایجاد و تغییر Branch
```bash
# ایجاد branch جدید
git checkout -b feature/user-authentication

# تغییر به branch موجود
git checkout main

# مشاهده لیست branch ها
git branch -a

# حذف branch
git branch -d feature/old-feature
```

### Merge و Pull Request
```bash
# Merge کردن branch
git checkout main
git merge feature/user-authentication

# Push کردن branch جدید
git push -u origin feature/user-authentication
```

### Git Flow استاندارد

```
main          ←  Production ready code
develop       ←  Development branch
feature/*     ←  New features
hotfix/*      ←  Emergency fixes
release/*     ←  Release preparation
```

## 📦 Release و Versioning

### Semantic Versioning
```
MAJOR.MINOR.PATCH
مثال: v1.2.3

MAJOR: Breaking changes
MINOR: New features (backward compatible)
PATCH: Bug fixes
```

### ایجاد Tag و Release
```bash
# ایجاد tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag به GitHub
git push origin v1.0.0

# Push همه tag ها
git push origin --tags
```

### بروزرسانی خودکار نسخه
```bash
# در pubspec.yaml
version: 1.0.0+1

# افزایش نسخه
flutter pub version patch  # 1.0.0+1 → 1.0.1+1
flutter pub version minor  # 1.0.1+1 → 1.1.0+1
flutter pub version major  # 1.1.0+1 → 2.0.0+1
```

## 🔒 نکات امنیتی

### GitHub Secrets
```bash
# برای CI/CD، secrets را در GitHub تنظیم کنید:
# Settings > Secrets and variables > Actions

ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
FIREBASE_SERVICE_ACCOUNT_KEY
```

### .gitignore مهم
```gitignore
# Sensitive files
.env
*.key
*.keystore
google-services.json
GoogleService-Info.plist

# Build files
build/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies

# IDE
.vscode/
.idea/
*.iml
```

### حفاظت از Branch اصلی
در GitHub Settings > Branches:
- ✅ Require pull request reviews
- ✅ Require status checks to pass
- ✅ Require branches to be up to date
- ✅ Include administrators

## 🚀 دستورات مفید

### ارسال سریع تغییرات
```bash
# Script برای commit و push سریع
#!/bin/bash
git add .
git commit -m "$1"
git push origin main

# استفاده:
# ./quick-push.sh "fix: resolve login issue"
```

### بررسی سلامت پروژه
```bash
# اجرای تست ها
flutter test

# بررسی کد
flutter analyze

# فرمت کردن کد
dart format .

# بررسی dependency ها
flutter pub deps
```

### GitHub CLI
```bash
# نصب GitHub CLI
brew install gh

# احراز هویت
gh auth login

# ایجاد Pull Request
gh pr create --title "Add new feature" --body "Description"

# مشاهده Issues
gh issue list
```

## 📚 منابع مفید

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Docs](https://docs.github.com)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [Semantic Versioning](https://semver.org)

## 🆘 عیب یابی رایج

### مشکلات Push
```bash
# خطای rejected
git pull origin main --rebase
git push origin main

# فراموشی credentials
git config --global credential.helper store
```

### مشکلات Merge
```bash
# لغو merge
git merge --abort

# حل conflict
git status
# ویرایش فایل های conflict
git add .
git commit
```

### بازگردانی تغییرات
```bash
# بازگردانی فایل خاص
git checkout -- filename.dart

# بازگردانی commit آخر
git reset HEAD~1

# بازگردانی کامل به commit قبلی
git reset --hard HEAD~1
```

---

> **نکته:** همیشه قبل از push کردن، تست هایتان را اجرا کنید و کد را بررسی کنید.
