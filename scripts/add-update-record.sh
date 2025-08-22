#!/bin/bash

# scripts/add-update-record.sh
# اسکریپت تعاملی برای افزودن رکورد جدید به تاریخچه بروزرسانی

# رنگ‌ها برای خروجی بهتر
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# تاریخ و زمان شمسی
get_shamsi_date() {
    # محاسبه تاریخ شمسی (ساده‌شده)
    echo "۱۴۰۴/۰۶/۰۱"
}

get_shamsi_time() {
    date '+%H:%M'
}

get_iso_date() {
    date -u +"%Y-%m-%dT%H:%M:%S.%6N"
}

print_header() {
    clear
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}           🚀 افزودن رکورد جدید تاریخچه بروزرسانی           ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# فایل JSON path
JSON_FILE="assets/update_history_records.json"

# بررسی وجود فایل JSON
if [[ ! -f "$JSON_FILE" ]]; then
    print_error "فایل JSON یافت نشد: $JSON_FILE"
    exit 1
fi

print_header

print_step "شروع فرآیند افزودن رکورد جدید..."

# دریافت اطلاعات از کاربر
echo -e "${PURPLE}🔹 عنوان بروزرسانی:${NC}"
read -p "» " title
if [[ -z "$title" ]]; then
    print_error "عنوان نمی‌تواند خالی باشد!"
    exit 1
fi

echo ""
echo -e "${PURPLE}🔹 نسخه (مثال: 1.2.4):${NC}"
read -p "» " version
if [[ -z "$version" ]]; then
    version="1.0.0"
    print_warning "نسخه پیش‌فرض انتخاب شد: $version"
fi

echo ""
echo -e "${PURPLE}🔹 دسته‌بندی - یکی از گزینه‌های زیر را انتخاب کنید:${NC}"
echo "  1) Feature"
echo "  2) Bug Fix"  
echo "  3) UI Update"
echo "  4) Performance"
echo "  5) Database"
echo "  6) API"
echo "  7) Security"
echo "  8) Documentation"
read -p "انتخاب شما (1-8): " category_choice

case $category_choice in
    1) category="Feature" ;;
    2) category="Bug Fix" ;;
    3) category="UI Update" ;;
    4) category="Performance" ;;
    5) category="Database" ;;
    6) category="API" ;;
    7) category="Security" ;;
    8) category="Documentation" ;;
    *) category="Feature"; print_warning "گزینه پیش‌فرض انتخاب شد: Feature" ;;
esac

echo ""
echo -e "${PURPLE}🔹 اولویت - یکی از گزینه‌های زیر را انتخاب کنید:${NC}"
echo "  1) Low"
echo "  2) Medium"
echo "  3) High"  
echo "  4) Critical"
read -p "انتخاب شما (1-4): " priority_choice

case $priority_choice in
    1) priority="low" ;;
    2) priority="medium" ;;
    3) priority="high" ;;
    4) priority="critical" ;;
    *) priority="medium"; print_warning "گزینه پیش‌فرض انتخاب شد: Medium" ;;
esac

echo ""
echo -e "${PURPLE}🔹 توضیح مشکل کاربر:${NC}"
read -p "» " user_problem
if [[ -z "$user_problem" ]]; then
    user_problem="مشکل مشخص نشده"
fi

echo ""
echo -e "${PURPLE}🔹 شرح راه‌حل (چند خط مجاز - برای پایان خط خالی وارد کنید):${NC}"
solution_lines=()
while IFS= read -r line; do
    [[ -z "$line" ]] && break
    solution_lines+=("$line")
done

solution_description=""
for line in "${solution_lines[@]}"; do
    solution_description="${solution_description}${line}\\n"
done

if [[ -z "$solution_description" ]]; then
    solution_description="راه‌حل مشخص نشده"
fi

echo ""
echo -e "${PURPLE}🔹 نظر کاربر (اختیاری):${NC}"
read -p "» " user_comment
if [[ -z "$user_comment" ]]; then
    user_comment="بدون نظر"
fi

echo ""
echo -e "${PURPLE}🔹 برچسب‌ها (با کامل جدا شوند - مثال: ui,performance,bug):${NC}"
read -p "» " tags
if [[ -z "$tags" ]]; then
    tags="general"
fi

echo ""
echo -e "${PURPLE}🔹 فایل‌های تحت تأثیر (با کامل جدا شوند):${NC}"
read -p "» " affected_files_input
if [[ -z "$affected_files_input" ]]; then
    affected_files_input="lib/main.dart"
fi

# تبدیل فایل‌ها به آرایه JSON
IFS=',' read -ra affected_files_array <<< "$affected_files_input"
affected_files_json="["
for i in "${!affected_files_array[@]}"; do
    file=$(echo "${affected_files_array[$i]}" | xargs) # trim whitespace
    if [[ $i -gt 0 ]]; then
        affected_files_json+=", "
    fi
    affected_files_json+="\"$file\""
done
affected_files_json+="]"

echo ""
echo -e "${PURPLE}🔹 تغییرات انجام شده (با کامل جدا شوند):${NC}"
read -p "» " changes_input
if [[ -z "$changes_input" ]]; then
    changes_input="تغییرات عمومی"
fi

# تبدیل تغییرات به آرایه JSON
IFS=',' read -ra changes_array <<< "$changes_input"
changes_json="["
for i in "${!changes_array[@]}"; do
    change=$(echo "${changes_array[$i]}" | xargs) # trim whitespace
    if [[ $i -gt 0 ]]; then
        changes_json+=", "
    fi
    changes_json+="\"$change\""
done
changes_json+="]"

# محاسبه ID جدید
current_total=$(jq '.metadata.totalRecords' "$JSON_FILE")
new_id=$((current_total + 1))

# تاریخ و زمان
shamsi_date=$(get_shamsi_date)
shamsi_time=$(get_shamsi_time)
iso_date=$(get_iso_date)

echo ""
echo -e "${CYAN}═══════════════ 📋 خلاصه اطلاعات ═══════════════${NC}"
echo -e "${YELLOW}🆔 شناسه:${NC} $new_id"
echo -e "${YELLOW}📝 عنوان:${NC} $title"
echo -e "${YELLOW}🏷️ نسخه:${NC} $version"
echo -e "${YELLOW}📂 دسته‌بندی:${NC} $category"
echo -e "${YELLOW}⚡ اولویت:${NC} $priority"
echo -e "${YELLOW}📅 تاریخ:${NC} $shamsi_date"
echo -e "${YELLOW}🕐 زمان:${NC} $shamsi_time"
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"

echo ""
echo -e "${PURPLE}آیا اطلاعات صحیح هستند و می‌خواهید رکورد ثبت شود؟ (y/N)${NC}"
read -p "» " confirm

if [[ ! "$confirm" =~ ^[yY]([eE][sS])?$ ]]; then
    print_warning "عملیات لغو شد."
    exit 0
fi

print_step "در حال ثبت رکورد..."

# ایجاد رکورد JSON جدید
new_record=$(cat <<EOF
{
  "id": $new_id,
  "title": "$title",
  "version": "$version",
  "shamsiDate": "$shamsi_date",
  "shamsiTime": "$shamsi_time",
  "createdAt": "$iso_date",
  "userProblem": "$user_problem",
  "solutionDescription": "$solution_description",
  "userComment": "$user_comment",
  "tags": "$tags",
  "priority": "$priority",
  "category": "$category",
  "status": "completed",
  "affectedFiles": $affected_files_json,
  "changes": $changes_json
}
EOF
)

# بروزرسانی فایل JSON با jq
temp_file=$(mktemp)
jq --argjson new_record "$new_record" \
   --arg new_date "$iso_date" \
   --arg new_version "$version" \
   '.metadata.totalRecords = (.metadata.totalRecords + 1) | 
    .metadata.lastUpdated = $new_date | 
    .metadata.version = $new_version | 
    .records = [$new_record] + .records' \
   "$JSON_FILE" > "$temp_file"

if [[ $? -eq 0 ]]; then
    mv "$temp_file" "$JSON_FILE"
    print_success "رکورد با موفقیت ثبت شد!"
    print_success "شناسه رکورد: $new_id"
    print_success "تعداد کل رکوردها: $((current_total + 1))"
    
    echo ""
    echo -e "${BLUE}🚀 برای مشاهده تغییرات اپلیکیشن را اجرا کنید:${NC}"
    echo -e "${CYAN}   flutter run -d macos${NC}"
else
    print_error "خطا در ثبت رکورد!"
    rm -f "$temp_file"
    exit 1
fi
