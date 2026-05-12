import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../controllers/note_controller.dart';
import '../../data/models/note_model.dart';
import '../../utils/app_theme.dart';
import '../widgets/app_confirm_dialog.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late final NoteController noteController;

  @override
  void initState() {
    super.initState();
    noteController = Get.find<NoteController>();
  }

  Future<void> _handleEditNote() async {
    context.pushNamed('edit-note', extra: widget.note);
  }

  Future<void> _handleDeleteNote() async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Delete Note',
      content: 'Are you sure you want to delete this note?',
      confirmText: 'Delete',
    );

    if (confirmed == true) {
      final success = await noteController.deleteNote(widget.note.id);
      if (success && mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(noteController.errorMessage.value),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
        actions: [
          IconButton(
            onPressed: _handleEditNote,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Note',
          ),
          IconButton(
            onPressed: _handleDeleteNote,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Note',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.note.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Date
              Text(
                DateFormat(
                  'MMMM d, yyyy - hh:mm a',
                ).format(widget.note.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Divider
              Container(height: 1, color: AppColors.divider),
              const SizedBox(height: AppSpacing.lg),

              // Description
              Text(
                widget.note.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.text,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
