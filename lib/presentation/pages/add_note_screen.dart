import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/note_controller.dart';
import '../../utils/app_theme.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final NoteController noteController;
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    noteController = Get.find<NoteController>();
    authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleAddNote() async {
    if (_formKey.currentState!.validate()) {
      final userId = authController.currentUser.value?.id ?? '';
      final success = await noteController.addNote(
        userId: userId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (success && mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note created successfully'),
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
        title: const Text('Create Note'),
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

                // Title Field
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Note Title',
                    prefixIcon: const Icon(Icons.title),
                    fillColor: AppColors.surface,
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  maxLines: 10,
                  minLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Note Description',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.md),
                      child: Icon(Icons.description),
                    ),
                    alignLabelWithHint: true,
                    fillColor: AppColors.surface,
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Save Button
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        noteController.isLoading.value ? null : _handleAddNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    child: noteController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Create Note',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
