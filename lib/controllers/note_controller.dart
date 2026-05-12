import 'package:get/get.dart';
import '../data/models/note_model.dart';
import '../data/services/api_service.dart';

class NoteController extends GetxController {
  final notes = <NoteModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedNote = Rx<NoteModel?>(null);

  Future<void> fetchNotes(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedNotes = await ApiService.getUserNotes(userId);
      notes.value = fetchedNotes;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addNote({
    required String userId,
    required String title,
    required String description,
  }) async {
    try {
      if (title.isEmpty) {
        errorMessage.value = 'Title cannot be empty';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final newNote = await ApiService.createNote(
        userId: userId,
        title: title,
        description: description,
      );

      notes.add(newNote);
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> editNote({
    required String id,
    required String title,
    required String description,
  }) async {
    try {
      if (title.isEmpty) {
        errorMessage.value = 'Title cannot be empty';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final updatedNote = await ApiService.updateNote(
        id: id,
        title: title,
        description: description,
      );

      final index = notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        notes[index] = updatedNote;
      }

      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteNote(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await ApiService.deleteNote(id);
      if (success) {
        notes.removeWhere((n) => n.id == id);
      }

      return success;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void selectNote(NoteModel note) {
    selectedNote.value = note;
  }

  void clearSelection() {
    selectedNote.value = null;
  }
}
