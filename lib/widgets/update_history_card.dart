// lib/widgets/update_history_card.dart
// کارت نمایش تاریخچه بروزرسانی - UI component برای نمایش هر بروزرسانی

import 'package:flutter/material.dart';
import '../models/update_history.dart';

class UpdateHistoryCard extends StatefulWidget {
  final UpdateHistory update;
  final Function(UpdateHistory) onEdit;
  final Function(int) onDelete;
  final Function(int, String) onAddComment;

  const UpdateHistoryCard({
    super.key,
    required this.update,
    required this.onEdit,
    required this.onDelete,
    required this.onAddComment,
  });

  @override
  State<UpdateHistoryCard> createState() => _UpdateHistoryCardState();
}

class _UpdateHistoryCardState extends State<UpdateHistoryCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.update.userComment != null) {
      _commentController.text = widget.update.userComment!;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color _getPriorityColor() {
    switch (widget.update.priority) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            // هدر کارت
            _buildCardHeader(),

            // محتوای اضافی (expandable)
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: _buildExpandedContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return InkWell(
      onTap: _toggleExpansion,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ردیف اول: عنوان و نسخه
            Row(
              children: [
                // آیکون دسته‌بندی
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getPriorityColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.update.getCategoryIcon(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),

                // عنوان
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.update.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // نسخه
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'v${widget.update.version}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Vazirmatn',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // دسته‌بندی
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.update.getCategoryText(),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getPriorityColor(),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Vazirmatn',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // تاریخ و زمان
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.update.shamsiDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                    Text(
                      widget.update.shamsiTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                  ],
                ),

                // آیکون باز/بسته
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // خلاصه مشکل کاربر
            Text(
              widget.update.userProblem,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                fontFamily: 'Vazirmatn',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),

          // مشکل کاربر کامل
          _buildSection(
            'مشکل کاربر',
            widget.update.userProblem,
            Icons.error_outline,
            Colors.orange,
          ),

          const SizedBox(height: 16),

          // راه‌حل و توسعه
          _buildSection(
            'راه‌حل و توسعه',
            widget.update.solutionDescription,
            Icons.build,
            Colors.green,
          ),

          // نظر کاربر
          if (widget.update.userComment != null) ...[
            const SizedBox(height: 16),
            _buildSection(
              'نظر شما',
              widget.update.userComment!,
              Icons.comment,
              Colors.blue,
            ),
          ],

          const SizedBox(height: 16),

          // فیلد افزودن/ویرایش نظر
          _buildCommentSection(),

          const SizedBox(height: 16),

          // دکمه‌های عملیات
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Vazirmatn',
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.edit_note, size: 20, color: Colors.purple),
            const SizedBox(width: 8),
            const Text(
              'نظر شما',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontFamily: 'Vazirmatn',
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _saveComment,
              icon: const Icon(Icons.save, size: 16),
              label: const Text('ذخیره'),
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _commentController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'نظر یا یادداشت خود را اینجا بنویسید...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // دکمه ویرایش
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showEditDialog(),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('ویرایش'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // دکمه حذف
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showDeleteDialog(),
            icon: const Icon(Icons.delete, size: 16),
            label: const Text('حذف'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveComment() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty && widget.update.id != null) {
      widget.onAddComment(widget.update.id!, comment);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ نظر ذخیره شد'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showEditDialog() {
    // TODO: پیاده‌سازی دیالوگ ویرایش
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚧 ویرایش در حال توسعه...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'حذف بروزرسانی',
          style: TextStyle(fontFamily: 'Vazirmatn'),
        ),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید این بروزرسانی را حذف کنید؟',
          style: TextStyle(fontFamily: 'Vazirmatn'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.update.id != null) {
                widget.onDelete(widget.update.id!);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
