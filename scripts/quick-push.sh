#!/bin/bash

# Smart Assistant 123 - Quick Git Push Script
# اسکریپت ارسال سریع تغییرات به GitHub

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if commit message is provided
if [ -z "$1" ]; then
    print_error "لطفاً پیام commit را وارد کنید"
    echo "استفاده: ./quick-push.sh \"commit message\""
    echo "مثال: ./quick-push.sh \"feat: add new feature\""
    exit 1
fi

COMMIT_MESSAGE="$1"

print_status "شروع فرآیند ارسال تغییرات..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "این پوشه یک repository Git نیست!"
    exit 1
fi

# Check for Flutter project
if [ ! -f "pubspec.yaml" ]; then
    print_warning "فایل pubspec.yaml پیدا نشد. آیا در پوشه پروژه Flutter هستید؟"
fi

# Pre-commit checks
print_status "بررسی‌های قبل از commit..."

# Check if Flutter is installed
if command -v flutter &> /dev/null; then
    print_status "بررسی فرمت کد..."
    if ! dart format --output=none --set-exit-if-changed .; then
        print_warning "کد نیاز به فرمت‌بندی دارد. در حال فرمت کردن..."
        dart format .
    fi
    
    print_status "تحلیل کد..."
    if ! flutter analyze --fatal-infos; then
        print_error "خطا در تحلیل کد! لطفاً خطاها را رفع کنید."
        exit 1
    fi
    
    print_status "اجرای تست‌ها..."
    if ! flutter test; then
        print_error "تست‌ها ناموفق! لطفاً مشکلات را رفع کنید."
        exit 1
    fi
else
    print_warning "Flutter نصب نیست. بررسی‌های Flutter skip شد."
fi

# Check git status
if [ -z "$(git status --porcelain)" ]; then
    print_warning "هیچ تغییری برای commit وجود ندارد!"
    exit 0
fi

# Show changes
print_status "تغییرات:"
git status --short

# Add all changes
print_status "اضافه کردن تغییرات..."
git add .

# Commit
print_status "Commit کردن با پیام: \"$COMMIT_MESSAGE\""
git commit -m "$COMMIT_MESSAGE"

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
print_status "Branch فعلی: $CURRENT_BRANCH"

# Push to origin
print_status "Push کردن به origin/$CURRENT_BRANCH..."
if git push origin "$CURRENT_BRANCH"; then
    print_success "✅ تغییرات با موفقیت به GitHub ارسال شد!"
    
    # Show remote URL
    REMOTE_URL=$(git config --get remote.origin.url)
    if [[ $REMOTE_URL == *"github.com"* ]]; then
        # Extract repo info for GitHub URL
        if [[ $REMOTE_URL == *".git" ]]; then
            REPO_URL=${REMOTE_URL%.git}
        else
            REPO_URL=$REMOTE_URL
        fi
        REPO_URL=${REPO_URL/git@github.com:/https://github.com/}
        print_success "🌐 مشاهده در GitHub: $REPO_URL"
    fi
else
    print_error "❌ خطا در push کردن!"
    exit 1
fi

# Optional: Show recent commits
print_status "آخرین commit ها:"
git log --oneline -5

print_success "🎉 فرآیند کامل شد!"
