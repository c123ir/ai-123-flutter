// lib/widgets/add_update_dialog.dart
// دیالوگ افزودن بروزرسانی جدید - فرم کامل ثبت تغییرات

import 'package:flutter/material.dart';
import '../models/update_history.dart';
import '../services/update_history_service.dart';
import '../utils/persian_number_utils.dart';

class AddUpdateDialog extends StatefulWidget {
  final UpdateHistory? initialUpdate;

  const AddUpdateDialog({super.key, this.initialUpdate});

  @override
  State<AddUpdateDialog> createState() => _AddUpdateDialogState();
}

class _AddUpdateDialogState extends State<AddUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  final UpdateHistoryService _updateService = UpdateHistoryService();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _versionController;
  late TextEditingController _userProblemController;
  late TextEditingController _solutionController;
  late TextEditingController _tagsController;
  late TextEditingController _commentController;

  // Selected values
  String _selectedPriority = 'medium';
  String _selectedCategory = 'feature';
  String _selectedStatus = 'completed';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _titleController = TextEditingController(
      text: widget.initialUpdate?.title ?? '',
    );
    _versionController = TextEditingController(
      text: widget.initialUpdate?.version ?? '1.2.0',
    );
    _userProblemController = TextEditingController(
      text: widget.initialUpdate?.userProblem ?? '',
    );
    _solutionController = TextEditingController(
      text: widget.initialUpdate?.solutionDescription ?? '',
    );
    _tagsController = TextEditingController(
      text: widget.initialUpdate?.tags ?? '',
    );
    _commentController = TextEditingController(
      text: widget.initialUpdate?.userComment ?? '',
    );

    // Set initial values if editing
    if (widget.initialUpdate != null) {
      _selectedPriority = widget.initialUpdate!.priority;
      _selectedCategory = widget.initialUpdate!.category;
      _selectedStatus = widget.initialUpdate!.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _versionController.dispose();
    _userProblemController.dispose();
    _solutionController.dispose();
    _tagsController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 20),

              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTitleSection(),
                      const SizedBox(height: 20),
                      _buildVersionAndCategorySection(),
                      const SizedBox(height: 20),
                      _buildProblemSection(),
                      const SizedBox(height: 20),
                      _buildSolutionSection(),
                      const SizedBox(height: 20),
                      _buildTagsSection(),
                      const SizedBox(height: 20),
                      _buildCommentSection(),
                      const SizedBox(height: 20),
                      _buildPriorityAndStatusSection(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.add_circle_outline,
            color: Color(0xFF1976D2),
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.initialUpdate == null
                    ? 'بروزرسانی جدید'
                    : 'ویرایش بروزرسانی',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ثبت تغییرات و توسعه‌های انجام شده',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Vazirmatn',
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          tooltip: 'بستن',
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📝 عنوان بروزرسانی',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazirmatn',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'مثال: اضافه کردن سیستم تبدیل اعداد فارسی',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'عنوان بروزرسانی الزامی است';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildVersionAndCategorySection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🏷️ نسخه',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _versionController,
                decoration: InputDecoration(
                  hintText: '1.2.0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'نسخه الزامی است';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🎯 دسته‌بندی',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'feature',
                    child: Text('✨ ویژگی جدید'),
                  ),
                  DropdownMenuItem(value: 'bugfix', child: Text('🐛 رفع باگ')),
                  DropdownMenuItem(
                    value: 'enhancement',
                    child: Text('🔧 بهبود'),
                  ),
                  DropdownMenuItem(value: 'security', child: Text('🔒 امنیت')),
                  DropdownMenuItem(
                    value: 'performance',
                    child: Text('⚡ عملکرد'),
                  ),
                  DropdownMenuItem(value: 'ui', child: Text('🎨 رابط کاربری')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProblemSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '❓ مشکل کاربر یا درخواست',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazirmatn',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _userProblemController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'توضیح دهید که کاربر چه مشکلی داشت یا چه درخواستی کرد...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'توضیح مشکل کاربر الزامی است';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSolutionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🛠️ راه‌حل و شرح توسعه',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazirmatn',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _solutionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText:
                'توضیح کاملی از راه‌حل، کدهای نوشته شده، فایل‌های تغییر یافته و نتیجه...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'شرح راه‌حل الزامی است';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏷️ برچسب‌ها (اختیاری)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazirmatn',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _tagsController,
          decoration: InputDecoration(
            hintText: 'مثال: پیامک، اعداد فارسی، UI، بهبود',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💭 نظر شما (اختیاری)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazirmatn',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _commentController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'نظر، یادداشت یا پیشنهاد خود را بنویسید...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityAndStatusSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚠️ اولویت',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('🟢 پایین')),
                  DropdownMenuItem(value: 'medium', child: Text('🔵 متوسط')),
                  DropdownMenuItem(value: 'high', child: Text('🟠 بالا')),
                  DropdownMenuItem(value: 'critical', child: Text('🔴 بحرانی')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📊 وضعیت',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'planned',
                    child: Text('📝 برنامه‌ریزی'),
                  ),
                  DropdownMenuItem(
                    value: 'in_progress',
                    child: Text('🔄 در حال انجام'),
                  ),
                  DropdownMenuItem(value: 'completed', child: Text('✅ تکمیل')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'انصراف',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.initialUpdate == null
                        ? 'ثبت بروزرسانی'
                        : 'ذخیره تغییرات',
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final comment = _commentController.text.trim();

      if (widget.initialUpdate == null) {
        // افزودن بروزرسانی جدید
        await _updateService.addUpdate(
          title: _titleController.text.trim(),
          version: _versionController.text.trim(),
          userProblem: _userProblemController.text.trim(),
          solutionDescription: _solutionController.text.trim(),
          userComment: comment.isNotEmpty ? comment : null,
          tags: _tagsController.text.trim().isNotEmpty
              ? _tagsController.text.trim()
              : null,
          priority: _selectedPriority,
          category: _selectedCategory,
          status: _selectedStatus,
        );

        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        // ویرایش بروزرسانی موجود
        final updatedHistory = widget.initialUpdate!.copyWith(
          title: _titleController.text.trim(),
          version: _versionController.text.trim(),
          userProblem: _userProblemController.text.trim(),
          solutionDescription: _solutionController.text.trim(),
          userComment: comment.isNotEmpty ? comment : null,
          tags: _tagsController.text.trim().isNotEmpty
              ? _tagsController.text.trim()
              : null,
          priority: _selectedPriority,
          category: _selectedCategory,
          status: _selectedStatus,
        );

        await _updateService.updateHistory(updatedHistory);

        if (mounted) {
          Navigator.pop(context, updatedHistory);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطا در ذخیره: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
