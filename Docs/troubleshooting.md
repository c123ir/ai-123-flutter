# راهنمای عیب‌یابی - Flutter Development Issues

## 🛠️ مشکلات متداول و راه‌حل‌ها

### 1. مشکلات Dependency Conflicts

#### علائم:
- `version solving failed`
- `incompatible dependencies`
- `package has no versions that match`

#### راه‌حل:
```bash
# حذف dependency cache
flutter pub cache clean

# حذف pubspec.lock
rm pubspec.lock

# دریافت مجدد dependencies
flutter pub get

# یا استفاده از override در pubspec.yaml:
dependency_overrides:
  package_name: ^version
```

### 2. مشکلات Flutter Framework Corruption

#### علائم:
- `'Offset' isn't a type`
- `'PointerDeviceKind' isn't a type`
- `Method not found: 'clampDouble'`

#### راه‌حل:
```bash
# اجرای اسکریپت clean build
./scripts/clean-build.sh

# یا manual cleanup:
flutter clean
flutter pub cache clean
flutter doctor --verbose
flutter upgrade --force
flutter pub get
```

### 3. مشکلات Build

#### علائم:
- `Build failed`
- `Compilation errors`
- `Missing dependencies`

#### راه‌حل:
```bash
# بررسی وضعیت Flutter
flutter doctor

# حذف build artifacts
rm -rf build/
rm -rf .dart_tool/

# Build مجدد
flutter clean
flutter pub get
flutter build [platform]
```

### 4. مشکلات IDE و Hot Reload

#### علائم:
- Hot reload کار نمی‌کند
- IDE errors
- Import resolution issues

#### راه‌حل:
```bash
# Restart Flutter daemon
flutter clean
flutter pub get

# در VS Code:
Ctrl+Shift+P > Flutter: Reload

# Restart IDE
```

### 5. مشکلات Platform-Specific

#### macOS:
```bash
# حذف Pods
rm -rf ios/Pods/ ios/.symlinks/
rm -rf macos/Pods/

# نصب مجدد
cd ios && pod install
cd ../macos && pod install
```

#### Android:
```bash
# حذف gradle cache
rm -rf android/.gradle/

# Clean build
cd android && ./gradlew clean
```

#### Windows:
```bash
# حذف build files
rm -rf windows/flutter/ephemeral/

# Build مجدد
flutter build windows
```

## 🚀 اسکریپت‌های Automation

### Clean Build Script
```bash
./scripts/clean-build.sh
```

### Docker Development Environment
```bash
# ساخت container
docker-compose up -d flutter-dev

# اجرا در container
docker-compose exec flutter-dev flutter run
```

## 📊 Performance Monitoring

### Memory Usage
```bash
flutter run --observatory-port=9999
# سپس در browser: http://localhost:9999
```

### Build Size Analysis
```bash
flutter build apk --analyze-size
flutter build ios --analyze-size
```

## 🔍 Debugging Tips

### Flutter Inspector
```bash
flutter run
# سپس press 'i' برای inspector
```

### Verbose Logging
```bash
flutter run --verbose
flutter build --verbose
```

### Widget Tree
```bash
flutter run
# سپس press 'w' برای widget tree
```

## 🆘 وقتی هیچ چیز کار نمی‌کند

### Nuclear Option:
```bash
# حذف کامل Flutter
rm -rf ~/flutter

# نصب مجدد
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# تنظیم مجدد
flutter doctor
flutter config --no-analytics
```

### یا استفاده از Flutter Version Manager:
```bash
# نصب fvm
dart pub global activate fvm

# استفاده از نسخه stable
fvm install stable
fvm use stable

# اجرا با نسخه مشخص
fvm flutter run
```

## 📋 Checklist قبل از Development

- [ ] `flutter doctor` بدون خطا
- [ ] Dependencies compatible
- [ ] IDE extensions updated
- [ ] Git working tree clean
- [ ] Backup created
- [ ] Tests passing

## 🎯 Best Practices برای Stability

1. **Version Pinning**: همیشه نسخه‌های دقیق dependencies
2. **Regular Updates**: بروزرسانی منظم اما تدریجی
3. **Testing**: هر تغییر را تست کنید
4. **Backup**: همیشه backup داشته باشید
5. **Documentation**: تغییرات را مستند کنید

## 📞 کمک بیشتر

- [Flutter Documentation](https://docs.flutter.dev)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Community Discord](https://discord.gg/flutter)
