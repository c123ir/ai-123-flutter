#!/bin/bash

# Smart Assistant 123 - Project Sync Script
# اسکریپت هماهنگ‌سازی با upstream repository

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

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "این پوشه یک repository Git نیست!"
    exit 1
fi

# Check if upstream exists
if ! git remote get-url upstream > /dev/null 2>&1; then
    print_warning "upstream remote وجود ندارد. آیا می‌خواهید اضافه کنید؟ [y/N]"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "لطفاً URL upstream repository را وارد کنید:"
        read -r upstream_url
        git remote add upstream "$upstream_url"
        print_success "upstream اضافه شد: $upstream_url"
    else
        print_error "بدون upstream نمی‌توان sync کرد!"
        exit 1
    fi
fi

print_status "شروع هماهنگ‌سازی با upstream..."

# Show current status
print_status "وضعیت فعلی:"
git remote -v

# Fetch from upstream
print_status "دریافت تغییرات از upstream..."
git fetch upstream

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
print_status "Branch فعلی: $CURRENT_BRANCH"

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    print_warning "تغییرات commit نشده وجود دارد!"
    git status --short
    print_warning "آیا می‌خواهید ادامه دهید؟ (تغییرات stash خواهند شد) [y/N]"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        git stash push -m "Auto-stash before sync at $(date)"
        print_status "تغییرات stash شدند"
        STASHED=true
    else
        print_error "لطفاً ابتدا تغییرات را commit کنید"
        exit 1
    fi
fi

# Switch to main if not already
if [ "$CURRENT_BRANCH" != "main" ]; then
    print_status "تغییر به branch main..."
    git checkout main
fi

# Pull from upstream main
print_status "Pull کردن از upstream/main..."
if git pull upstream main; then
    print_success "هماهنگ‌سازی با upstream موفق بود"
else
    print_error "خطا در pull از upstream!"
    if [ "$STASHED" = true ]; then
        print_status "بازگردانی stash..."
        git stash pop
    fi
    exit 1
fi

# Push to origin
print_status "Push کردن تغییرات به origin..."
git push origin main

# Return to original branch if needed
if [ "$CURRENT_BRANCH" != "main" ]; then
    print_status "بازگشت به branch $CURRENT_BRANCH..."
    git checkout "$CURRENT_BRANCH"
    
    # Try to rebase with main
    print_status "Rebase کردن $CURRENT_BRANCH با main..."
    if git rebase main; then
        print_success "Rebase موفق بود"
    else
        print_warning "Conflict در rebase! لطفاً دستی حل کنید."
        print_status "برای ادامه rebase: git rebase --continue"
        print_status "برای لغو rebase: git rebase --abort"
    fi
fi

# Restore stash if any
if [ "$STASHED" = true ]; then
    print_status "بازگردانی stash..."
    if git stash pop; then
        print_success "Stash بازگردانی شد"
    else
        print_warning "Conflict در stash! لطفاً دستی حل کنید."
    fi
fi

# Update dependencies if Flutter project
if [ -f "pubspec.yaml" ] && command -v flutter &> /dev/null; then
    print_status "بروزرسانی dependencies..."
    flutter pub get
    
    # Check for outdated packages
    print_status "بررسی packages قدیمی..."
    flutter pub outdated || true
fi

print_success "🎉 هماهنگ‌سازی کامل شد!"

# Show status
print_status "آخرین commit ها:"
git log --oneline -5

print_status "وضعیت فعلی:"
git status
