#!/bin/bash

# scripts/quick-add-record.sh
# اسکریپت سریع برای افزودن رکورد تست

# رنگ‌ها
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🚀 افزودن رکورد تست سریع${NC}"
echo ""

# اطلاعات پیش‌فرض
title="تست اسکریپت command-line برای افزودن رکورد"
version="1.2.4"
category="Feature"
priority="medium"
user_problem="نیاز به روشی سریع و آسان برای افزودن رکورد جدید بدون ویرایش فایل‌ها داشتیم."
solution_description="ایجاد اسکریپت تعاملی command-line که از طریق prompt های ترمینال اطلاعات دریافت کرده و مستقیماً JSON را بروزرسانی می‌کند:\\n\\n✨ **ویژگی‌های کلیدی:**\\n• رابط تعاملی و user-friendly\\n• Validation ورودی‌ها\\n• انتخاب از لیست گزینه‌های از پیش تعریف شده\\n• بروزرسانی خودکار JSON با jq\\n• نمایش خلاصه قبل از تأیید\\n\\n🛠️ **پیاده‌سازی:**\\n• اسکریپت bash با پشتیبانی کامل از UTF-8\\n• استفاده از jq برای manipulation امن JSON\\n• رنگ‌بندی خروجی برای تجربه بهتر\\n• Error handling و rollback در صورت مشکل"
user_comment="این راه‌حل بسیار عملی است! حالا می‌توان بدون باز کردن فایل‌ها و IDE، سریع رکورد جدید اضافه کرد."
tags="automation,cli,scripting,productivity,json"
affected_files="scripts/add-update-record.sh,scripts/quick-add-record.sh,assets/update_history_records.json"
changes="ایجاد اسکریپت تعاملی add-update-record.sh,افزودن validation و user input handling,پیاده‌سازی JSON manipulation با jq,ایجاد رابط کاربری رنگی و user-friendly,اضافه کردن quick-add-record.sh برای تست سریع"

JSON_FILE="assets/update_history_records.json"

# بررسی وجود فایل
if [[ ! -f "$JSON_FILE" ]]; then
    echo "❌ فایل JSON یافت نشد: $JSON_FILE"
    exit 1
fi

# محاسبه ID جدید
current_total=$(jq '.metadata.totalRecords' "$JSON_FILE")
new_id=$((current_total + 1))

# تاریخ و زمان
shamsi_date="۱۴۰۴/۰۶/۰۱"
shamsi_time=$(date '+%H:%M')
iso_date=$(date -u +"%Y-%m-%dT%H:%M:%S.%6N")

# تبدیل فایل‌ها و تغییرات به JSON arrays
IFS=',' read -ra files_array <<< "$affected_files"
affected_files_json="["
for i in "${!files_array[@]}"; do
    file=$(echo "${files_array[$i]}" | xargs)
    if [[ $i -gt 0 ]]; then affected_files_json+=", "; fi
    affected_files_json+="\"$file\""
done
affected_files_json+="]"

IFS=',' read -ra changes_array <<< "$changes"
changes_json="["
for i in "${!changes_array[@]}"; do
    change=$(echo "${changes_array[$i]}" | xargs)
    if [[ $i -gt 0 ]]; then changes_json+=", "; fi
    changes_json+="\"$change\""
done
changes_json+="]"

echo -e "${BLUE}📋 ایجاد رکورد با اطلاعات زیر:${NC}"
echo "🆔 شناسه: $new_id"
echo "📝 عنوان: $title"
echo "🏷️ نسخه: $version"
echo "📂 دسته‌بندی: $category"
echo "⚡ اولویت: $priority"
echo ""

# ایجاد رکورد JSON
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

# بروزرسانی JSON
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
    echo -e "${GREEN}✅ رکورد با موفقیت ثبت شد!${NC}"
    echo -e "${GREEN}✅ شناسه رکورد: $new_id${NC}"
    echo -e "${GREEN}✅ تعداد کل رکوردها: $((current_total + 1))${NC}"
    echo ""
    echo -e "${CYAN}🚀 برای مشاهده: flutter run -d macos${NC}"
else
    echo "❌ خطا در ثبت رکورد!"
    rm -f "$temp_file"
    exit 1
fi
