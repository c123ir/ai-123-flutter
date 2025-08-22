// lib/widgets/add_update_dialog.dart
// دیالوگ پیشرفته افزودن بروزرسانی - فرم کامل با امکانات جدید

import 'package:flutter/material.dart';
import '../models/update_history.dart';
import '../services/update_history_service.dart';
import '../services/json_update_history_service.dart';

class AddUpdateDialog extends StatefulWidget {
  final UpdateHistory? initialUpdate;
  final VoidCallback? onUpdateAdded;

  const AddUpdateDialog({super.key, this.initialUpdate, this.onUpdateAdded});

  @override
  State<AddUpdateDialog> createState() => _AddUpdateDialogState();
}

class _AddUpdateDialogState extends State<AddUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  final UpdateHistoryService _updateService = UpdateHistoryService();
  final JsonUpdateHistoryService _jsonService = JsonUpdateHistoryService();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _versionController;
  late TextEditingController _descriptionController;
  late TextEditingController _changesController;
  late TextEditingController _affectedFilesController;
  late TextEditingController _userFeedbackController;

  // Selected values
  String _selectedPriority = 'Medium';
  String _selectedCategory = 'Feature';

  // Multi-line fields
  final List<String> _changesList = [];
  final List<String> _filesList = [];

  bool _isLoading = false;

  // دسته‌بندی‌های جدید
  final List<String> _categories = [
    'Feature',
    'Bug Fix',
    'UI Update',
    'Database',
    'API',
    'Performance',
    'Security',
    'Documentation',
  ];

  // اولویت‌های جدید
  final List<String> _priorities = ['Critical', 'High', 'Medium', 'Low'];

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
    _descriptionController = TextEditingController(
      text: widget.initialUpdate?.userProblem ?? '',
    );
    _changesController = TextEditingController();
    _affectedFilesController = TextEditingController();
    _userFeedbackController = TextEditingController(
      text: widget.initialUpdate?.userComment ?? '',
    );

    // Set initial values if editing
    if (widget.initialUpdate != null) {
      _selectedPriority = widget.initialUpdate!.priority;
      _selectedCategory = widget.initialUpdate!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _versionController.dispose();
    _descriptionController.dispose();
    _changesController.dispose();
    _affectedFilesController.dispose();
    _userFeedbackController.dispose();
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
          height: MediaQuery.of(context).size.height * 0.9,
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
                      const SizedBox(height: 16),
                      _buildVersionAndCategorySection(),
                      const SizedBox(height: 16),
                      _buildDescriptionSection(),
                      const SizedBox(height: 16),
                      _buildChangesSection(),
                      const SizedBox(height: 16),
                      _buildAffectedFilesSection(),
                      const SizedBox(height: 16),
                      _buildPrioritySection(),
                      const SizedBox(height: 16),
                      _buildUserFeedbackSection(),
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
            gradient: const LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.add_circle_outline,
            color: Colors.white,
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
                    ? 'افزودن بروزرسانی جدید'
                    : 'ویرایش بروزرسانی',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
              const Text(
                'ثبت تغییرات و بهبودهای انجام شده',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'عنوان بروزرسانی *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: _buildInputDecoration(
            'مثال: اضافه کردن سیستم احراز هویت',
            Icons.title,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'عنوان الزامی است';
            }
            if (value.length < 5) {
              return 'عنوان باید حداقل ۵ کاراکتر باشد';
            }
            return null;
          },
          maxLength: 100,
        ),
      ],
    );
  }

  Widget _buildVersionAndCategorySection() {
    return Row(
      children: [
        // Version
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'نسخه *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _versionController,
                decoration: _buildInputDecoration('1.2.0', Icons.tag),
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
        // Category
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'دسته‌بندی *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: _buildInputDecoration(
                  'انتخاب دسته‌بندی',
                  Icons.category,
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_getCategoryDisplayName(category)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'دسته‌بندی الزامی است';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'توضیحات کامل *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: _buildInputDecoration(
            'توضیح کاملی از تغییرات انجام شده ارائه دهید...',
            Icons.description,
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'توضیحات الزامی است';
            }
            if (value.length < 10) {
              return 'توضیحات باید حداقل ۱۰ کاراکتر باشد';
            }
            return null;
          },
          maxLength: 500,
        ),
      ],
    );
  }

  Widget _buildChangesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'تغییرات انجام شده',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addChange,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('افزودن'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1976D2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _changesController,
                        decoration: const InputDecoration(
                          hintText: 'مثال: افزودن صفحه لاگین',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onFieldSubmitted: (_) => _addChange(),
                      ),
                    ),
                    IconButton(
                      onPressed: _addChange,
                      icon: const Icon(Icons.add, color: Color(0xFF1976D2)),
                    ),
                  ],
                ),
              ),
              if (_changesList.isNotEmpty) ...[
                const Divider(height: 1),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _changesList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      title: Text(_changesList[index]),
                      trailing: IconButton(
                        onPressed: () => _removeChange(index),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAffectedFilesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'فایل‌های تغییر یافته',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addFile,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('افزودن'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1976D2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _affectedFilesController,
                        decoration: const InputDecoration(
                          hintText: 'مثال: lib/screens/login_screen.dart',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onFieldSubmitted: (_) => _addFile(),
                      ),
                    ),
                    IconButton(
                      onPressed: _addFile,
                      icon: const Icon(Icons.add, color: Color(0xFF1976D2)),
                    ),
                  ],
                ),
              ),
              if (_filesList.isNotEmpty) ...[
                const Divider(height: 1),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filesList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.insert_drive_file,
                        color: Color(0xFF1976D2),
                        size: 20,
                      ),
                      title: Text(_filesList[index]),
                      trailing: IconButton(
                        onPressed: () => _removeFile(index),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اولویت *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: _priorities.map((priority) {
              final isSelected = _selectedPriority == priority;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? _getPriorityColor(priority) : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _getPriorityDisplayName(priority),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : _getPriorityColor(priority),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildUserFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نظرات و توضیحات اضافی',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _userFeedbackController,
          decoration: _buildInputDecoration(
            'نظرات یا توضیحات اضافی در مورد این بروزرسانی...',
            Icons.feedback,
          ),
          maxLines: 3,
          maxLength: 300,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF1976D2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'انصراف',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('در حال ذخیره...'),
                    ],
                  )
                : Text(
                    widget.initialUpdate == null
                        ? 'ثبت بروزرسانی'
                        : 'بروزرسانی',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  void _addChange() {
    if (_changesController.text.trim().isNotEmpty) {
      setState(() {
        _changesList.add(_changesController.text.trim());
        _changesController.clear();
      });
    }
  }

  void _removeChange(int index) {
    setState(() {
      _changesList.removeAt(index);
    });
  }

  void _addFile() {
    if (_affectedFilesController.text.trim().isNotEmpty) {
      setState(() {
        _filesList.add(_affectedFilesController.text.trim());
        _affectedFilesController.clear();
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _filesList.removeAt(index);
    });
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'Feature':
        return '🚀 ویژگی جدید';
      case 'Bug Fix':
        return '🐛 رفع باگ';
      case 'UI Update':
        return '🎨 بروزرسانی UI';
      case 'Database':
        return '🗄️ پایگاه داده';
      case 'API':
        return '🔌 API';
      case 'Performance':
        return '⚡ بهینه‌سازی';
      case 'Security':
        return '🔒 امنیت';
      case 'Documentation':
        return '📚 مستندات';
      default:
        return category;
    }
  }

  String _getPriorityDisplayName(String priority) {
    switch (priority) {
      case 'Critical':
        return '🔴 بحرانی';
      case 'High':
        return '🟠 بالا';
      case 'Medium':
        return '🟡 متوسط';
      case 'Low':
        return '🟢 پایین';
      default:
        return priority;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_changesList.isEmpty) {
      _showErrorSnackBar('لطفاً حداقل یک تغییر اضافه کنید');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create update history object
      final updateData = {
        'id': widget.initialUpdate?.id ?? DateTime.now().millisecondsSinceEpoch,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'priority': _selectedPriority,
        'version': _versionController.text.trim(),
        'changes': _changesList,
        'affectedFiles': _filesList,
        'userFeedback': _userFeedbackController.text.trim().isEmpty
            ? null
            : _userFeedbackController.text.trim(),
        'createdAt':
            widget.initialUpdate?.createdAt ?? DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Save to JSON service
      await _jsonService.addUpdate(updateData);

      // Show success message
      _showSuccessSnackBar(
        widget.initialUpdate == null
            ? 'بروزرسانی با موفقیت ثبت شد!'
            : 'بروزرسانی با موفقیت ویرایش شد!',
      );

      // Call callback
      if (widget.onUpdateAdded != null) {
        widget.onUpdateAdded!();
      }

      // Close dialog
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      _showErrorSnackBar('خطا در ذخیره: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
