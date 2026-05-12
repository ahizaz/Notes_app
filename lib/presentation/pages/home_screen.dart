import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/note_controller.dart';
import '../../data/models/note_model.dart';
import '../../utils/app_theme.dart';
import '../widgets/app_confirm_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NoteController noteController;
  late final AuthController authController;
  final DateFormat _dateFormat = DateFormat('MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    noteController = Get.put(NoteController());

    // Fetch notes when screen loads
    if (authController.currentUser.value != null) {
      noteController.fetchNotes(authController.currentUser.value!.id);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    );

    if (confirmed == true) {
      await authController.logout();
      if (mounted) {
        context.goNamed('login');
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('My Notes'),
      elevation: 0,
      actions: [IconButton(icon: const Icon(Icons.logout), onPressed: _logout)],
    );
  }

  Widget _buildBody() {
    if (noteController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (noteController.notes.isEmpty) {
      return _buildEmptyState();
    }

    return _buildNoteList();
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt_outlined,
            size: 80,
            color: Color.fromARGB(128, 117, 117, 117),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'No notes yet',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Create your first note to get started',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: noteController.notes.length,
      itemBuilder: (context, index) {
        final note = noteController.notes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNoteCard(NoteModel note) {
    final formattedDate = _dateFormat.format(note.createdAt);

    return GestureDetector(
      onTap: () {
        context.pushNamed('note-detail', extra: note);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        context.pushNamed('edit-note', extra: note);
                        return;
                      }

                      if (value == 'delete') {
                        _showDeleteDialog(note);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppColors.error),
                            SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                note.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(NoteModel note) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Delete Note',
      content: 'Are you sure you want to delete this note?',
      confirmText: 'Delete',
    );

    if (confirmed == true) {
      final success = await noteController.deleteNote(note.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        context.pushNamed('add-note');
      },
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(_buildBody),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
}
