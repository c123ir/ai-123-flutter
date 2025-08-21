// lib/models/update_history.dart
// مدل تاریخچه بروزرسانی - ردیابی تمام تغییرات و توسعه‌های پروژه

class UpdateHistory {
  final int? id;
  final String title;
  final String version;
  final String shamsiDate;
  final String shamsiTime;
  final DateTime createdAt;
  final String userProblem;
  final String solutionDescription;
  final String? userComment;
  final String? tags;
  final String priority; // low, medium, high, critical
  final String category; // feature, bugfix, enhancement, security
  final String status; // completed, in_progress, planned

  UpdateHistory({
    this.id,
    required this.title,
    required this.version,
    required this.shamsiDate,
    required this.shamsiTime,
    required this.createdAt,
    required this.userProblem,
    required this.solutionDescription,
    this.userComment,
    this.tags,
    this.priority = 'medium',
    this.category = 'feature',
    this.status = 'completed',
  });

  /// تبدیل به Map برای ذخیره در دیتابیس
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'version': version,
      'shamsi_date': shamsiDate,
      'shamsi_time': shamsiTime,
      'created_at': createdAt.toIso8601String(),
      'user_problem': userProblem,
      'solution_description': solutionDescription,
      'user_comment': userComment,
      'tags': tags,
      'priority': priority,
      'category': category,
      'status': status,
    };
  }

  /// تبدیل از Map دیتابیس
  factory UpdateHistory.fromMap(Map<String, dynamic> map) {
    return UpdateHistory(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      version: map['version'] ?? '',
      shamsiDate: map['shamsi_date'] ?? '',
      shamsiTime: map['shamsi_time'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      userProblem: map['user_problem'] ?? '',
      solutionDescription: map['solution_description'] ?? '',
      userComment: map['user_comment'],
      tags: map['tags'],
      priority: map['priority'] ?? 'medium',
      category: map['category'] ?? 'feature',
      status: map['status'] ?? 'completed',
    );
  }

  /// کپی با تغییرات
  UpdateHistory copyWith({
    int? id,
    String? title,
    String? version,
    String? shamsiDate,
    String? shamsiTime,
    DateTime? createdAt,
    String? userProblem,
    String? solutionDescription,
    String? userComment,
    String? tags,
    String? priority,
    String? category,
    String? status,
  }) {
    return UpdateHistory(
      id: id ?? this.id,
      title: title ?? this.title,
      version: version ?? this.version,
      shamsiDate: shamsiDate ?? this.shamsiDate,
      shamsiTime: shamsiTime ?? this.shamsiTime,
      createdAt: createdAt ?? this.createdAt,
      userProblem: userProblem ?? this.userProblem,
      solutionDescription: solutionDescription ?? this.solutionDescription,
      userComment: userComment ?? this.userComment,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  /// دریافت آیکون بر اساس دسته‌بندی
  String getCategoryIcon() {
    switch (category) {
      case 'feature':
        return '✨';
      case 'bugfix':
        return '🐛';
      case 'enhancement':
        return '🔧';
      case 'security':
        return '🔒';
      case 'performance':
        return '⚡';
      case 'ui':
        return '🎨';
      default:
        return '📝';
    }
  }

  /// دریافت رنگ بر اساس اولویت
  String getPriorityColor() {
    switch (priority) {
      case 'critical':
        return '#f44336'; // قرمز
      case 'high':
        return '#ff9800'; // نارنجی
      case 'medium':
        return '#2196f3'; // آبی
      case 'low':
        return '#4caf50'; // سبز
      default:
        return '#9e9e9e'; // خاکستری
    }
  }

  /// دریافت متن فارسی اولویت
  String getPriorityText() {
    switch (priority) {
      case 'critical':
        return 'بحرانی';
      case 'high':
        return 'بالا';
      case 'medium':
        return 'متوسط';
      case 'low':
        return 'پایین';
      default:
        return 'نامشخص';
    }
  }

  /// دریافت متن فارسی دسته‌بندی
  String getCategoryText() {
    switch (category) {
      case 'feature':
        return 'ویژگی جدید';
      case 'bugfix':
        return 'رفع باگ';
      case 'enhancement':
        return 'بهبود';
      case 'security':
        return 'امنیت';
      case 'performance':
        return 'عملکرد';
      case 'ui':
        return 'رابط کاربری';
      default:
        return 'متفرقه';
    }
  }

  /// دریافت متن فارسی وضعیت
  String getStatusText() {
    switch (status) {
      case 'completed':
        return 'تکمیل شده';
      case 'in_progress':
        return 'در حال انجام';
      case 'planned':
        return 'برنامه‌ریزی شده';
      default:
        return 'نامشخص';
    }
  }

  @override
  String toString() {
    return 'UpdateHistory(id: $id, title: $title, version: $version, shamsiDate: $shamsiDate)';
  }
}
