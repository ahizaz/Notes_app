import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/note_controller.dart';
import '../../data/models/note_model.dart';
import '../../utils/app_theme.dart';
import '../widgets/app_loading_button.dart';
import '../widgets/app_text_form_field.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;

  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  final noteController = Get.find<NoteController>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController =
        TextEditingController(text: widget.note.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleUpdateNote() async {
    if (_formKey.currentState!.validate()) {
      final success = await noteController.editNote(
        id: widget.note.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (success && mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note updated successfully'),
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
        title: const Text('Edit Note'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),

                AppTextFormField(
                  controller: _titleController,
                  hintText: 'Note Title',
                  prefixIcon: const Icon(Icons.title),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  maxLines: null,
                  fillColor: AppColors.surface,
                  borderRadius: AppBorderRadius.md,
                  borderColor: AppColors.divider,
                  enabledBorderColor: AppColors.divider,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextFormField(
                  controller: _descriptionController,
                  hintText: 'Note Description',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md),
                    child: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  maxLines: 10,
                  minLines: 5,
                  alignLabelWithHint: true,
                  fillColor: AppColors.surface,
                  borderRadius: AppBorderRadius.md,
                  borderColor: AppColors.divider,
                  enabledBorderColor: AppColors.divider,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Update Button
                Obx(
                  () => AppLoadingButton(
                    label: 'Update Note',
                    isLoading: noteController.isLoading.value,
                    onPressed: noteController.isLoading.value
                        ? null
                        : _handleUpdateNote,
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
