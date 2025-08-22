#!/bin/bash

# scripts/clean-build.sh
# اسکریپت clean build برای حل مشکلات dependency و stability

echo "🧹 شروع فرآیند Clean Build..."

# رنگ‌ها برای خروجی بهتر
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# بررسی وجود Flutter
if ! command -v flutter &> /dev/null; then
    print_error "Flutter یافت نشد! لطفاً Flutter را نصب کنید."
    exit 1
fi

print_step "بررسی وضعیت Flutter..."
flutter doctor

print_step "پاک کردن cache و build files..."
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf ios/Pods/
rm -rf ios/.symlinks/
rm -rf android/.gradle/
rm -rf macos/Pods/
rm -rf windows/flutter/ephemeral/
rm -rf linux/flutter/ephemeral/
rm -rf web/.dart_tool/

print_success "فایل‌های cache پاک شدند"

print_step "بروزرسانی Flutter..."
flutter upgrade --force

print_step "دریافت dependencies..."
flutter pub get

print_step "اجرای pub upgrade..."
flutter pub upgrade

print_step "بررسی مشکلات پروژه..."
flutter analyze

print_step "تست build برای تمام پلتفرم‌ها..."

# Test macOS build
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_step "تست build macOS..."
    flutter build macos --debug
    if [ $? -eq 0 ]; then
        print_success "Build macOS موفقیت‌آمیز"
    else
        print_error "Build macOS ناموفق"
    fi
fi

# Test Android build
print_step "تست build Android..."
flutter build apk --debug
if [ $? -eq 0 ]; then
    print_success "Build Android موفقیت‌آمیز"
else
    print_warning "Build Android با مشکل مواجه شد"
fi

# Test iOS build (فقط روی macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_step "تست build iOS..."
    flutter build ios --debug --no-codesign
    if [ $? -eq 0 ]; then
        print_success "Build iOS موفقیت‌آمیز"
    else
        print_warning "Build iOS با مشکل مواجه شد"
    fi
fi

print_step "اجرای تست‌ها..."
flutter test

print_success "فرآیند Clean Build کامل شد!"
echo ""
echo "🎯 حالا می‌توانید اپلیکیشن را اجرا کنید:"
echo "   flutter run -d macos"
echo "   flutter run -d android"
echo "   flutter run -d ios"
