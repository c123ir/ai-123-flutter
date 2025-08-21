#!/bin/bash

# Smart Assistant 123 - Release Management Script
# اسکریپت مدیریت Release خودکار

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check if version is provided
if [ -z "$1" ]; then
    print_error "لطفاً نسخه جدید را وارد کنید"
    echo "استفاده: ./create-release.sh [major|minor|patch|version]"
    echo "مثال: ./create-release.sh minor"
    echo "مثال: ./create-release.sh 1.2.0"
    exit 1
fi

VERSION_INPUT="$1"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "این پوشه یک repository Git نیست!"
    exit 1
fi

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    print_warning "شما در branch $CURRENT_BRANCH هستید. آیا می‌خواهید به main برگردید؟ [y/N]"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        git checkout main
        git pull origin main
    fi
fi

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    print_error "تغییرات commit نشده وجود دارد! لطفاً ابتدا commit کنید."
    git status --short
    exit 1
fi

# Get current version from pubspec.yaml
if [ -f "pubspec.yaml" ]; then
    CURRENT_VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: *//' | sed 's/+.*//')
    print_status "نسخه فعلی: $CURRENT_VERSION"
else
    print_error "فایل pubspec.yaml پیدا نشد!"
    exit 1
fi

# Determine new version
case $VERSION_INPUT in
    "major"|"minor"|"patch")
        print_status "بروزرسانی نسخه با flutter pub version..."
        flutter pub version "$VERSION_INPUT"
        NEW_VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: *//' | sed 's/+.*//')
        ;;
    *)
        # Custom version provided
        NEW_VERSION="$VERSION_INPUT"
        # Update pubspec.yaml manually
        sed -i.bak "s/^version: .*/version: $NEW_VERSION+1/" pubspec.yaml
        rm -f pubspec.yaml.bak
        ;;
esac

print_success "نسخه جدید: $NEW_VERSION"

# Pre-release checks
print_status "اجرای بررسی‌های قبل از release..."

# Flutter checks
if command -v flutter &> /dev/null; then
    print_status "فرمت کد..."
    dart format .
    
    print_status "تحلیل کد..."
    flutter analyze --fatal-infos
    
    print_status "اجرای تست‌ها..."
    flutter test
    
    print_status "Build کردن برای اطمینان..."
    flutter build apk --debug
    flutter build web --debug
    
    print_success "✅ همه بررسی‌ها موفق بود!"
else
    print_warning "Flutter نصب نیست. بررسی‌های Flutter skip شد."
fi

# Update CHANGELOG.md
CHANGELOG_FILE="Docs/CHANGELOG.md"
if [ -f "$CHANGELOG_FILE" ]; then
    print_status "بروزرسانی CHANGELOG.md..."
    
    # Create temporary file with new entry
    TEMP_FILE=$(mktemp)
    echo "## [$NEW_VERSION] - $(date +%Y-%m-%d)" > "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    echo "### ✨ ویژگی‌های جدید" >> "$TEMP_FILE"
    echo "- بهبود عملکرد و رابط کاربری" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    echo "### 🐛 رفع مشکلات" >> "$TEMP_FILE"
    echo "- رفع باگ‌های شناخته شده" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    echo "### 🔧 تغییرات فنی" >> "$TEMP_FILE"
    echo "- بهینه‌سازی کد و performance" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    
    # Append existing changelog
    tail -n +1 "$CHANGELOG_FILE" >> "$TEMP_FILE"
    
    # Replace original file
    mv "$TEMP_FILE" "$CHANGELOG_FILE"
    
    print_success "CHANGELOG.md بروزرسانی شد"
fi

# Commit version changes
print_status "Commit کردن تغییرات نسخه..."
git add .
git commit -m "chore: bump version to $NEW_VERSION

- Update pubspec.yaml version
- Update CHANGELOG.md
- Prepare for release"

# Create and push tag
TAG_NAME="v$NEW_VERSION"
print_status "ایجاد tag $TAG_NAME..."
git tag -a "$TAG_NAME" -m "Release $NEW_VERSION

🚀 Smart Assistant 123 - نسخه $NEW_VERSION

این release شامل بهبودهای جدید، رفع باگ‌ها و بهینه‌سازی‌هایی است که تجربه کاربری را بهتر می‌کند.

برای جزئیات کامل تغییرات، فایل CHANGELOG.md را مشاهده کنید."

# Push commits and tags
print_status "Push کردن به GitHub..."
git push origin main
git push origin "$TAG_NAME"

print_success "🎉 Release $NEW_VERSION با موفقیت ایجاد شد!"
print_success "📦 GitHub Actions به زودی release files را بسازد"

# Show GitHub release URL
REMOTE_URL=$(git config --get remote.origin.url)
if [[ $REMOTE_URL == *"github.com"* ]]; then
    REPO_URL=${REMOTE_URL%.git}
    REPO_URL=${REPO_URL/git@github.com:/https://github.com/}
    print_success "🌐 مشاهده Release: $REPO_URL/releases/tag/$TAG_NAME"
fi

print_status "آخرین تغییرات:"
git log --oneline -3
