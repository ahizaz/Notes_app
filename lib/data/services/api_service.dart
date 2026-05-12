import 'dart:async';
import '../models/user_model.dart';
import '../models/note_model.dart';

class ApiService {
  // Using a mock API server. You can replace with your own server URL
  static const String baseUrl = 'https://api.example.com';
  
  // For demo purposes, we'll use a simple in-memory database
  // In production, replace this with actual API calls
  static final Map<String, dynamic> _mockDatabase = {
    'users': [],
    'notes': [],
  };

  // Auth APIs
  static Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if user already exists
      final users = _mockDatabase['users'] as List;
      final userExists = users.any((u) => u['email'] == email);

      if (userExists) {
        throw Exception('User already exists');
      }

      // Create new user
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password, // In production, hash the password
        createdAt: DateTime.now(),
      );

      _mockDatabase['users']!.add(newUser.toJson());

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      final users = _mockDatabase['users'] as List;
      final userJson = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );

      if (userJson == null) {
        throw Exception('Invalid email or password');
      }

      return UserModel.fromJson(userJson);
    } catch (e) {
      rethrow;
    }
  }

  // Note APIs
  static Future<List<NoteModel>> getUserNotes(String userId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      final notes = _mockDatabase['notes'] as List;
      final userNotes = notes
          .where((n) => n['userId'] == userId)
          .map((n) => NoteModel.fromJson(n))
          .toList();

      return userNotes;
    } catch (e) {
      rethrow;
    }
  }

  static Future<NoteModel> createNote({
    required String userId,
    required String title,
    required String description,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      final newNote = NoteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        title: title,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _mockDatabase['notes']!.add(newNote.toJson());

      return newNote;
    } catch (e) {
      rethrow;
    }
  }

  static Future<NoteModel> updateNote({
    required String id,
    required String title,
    required String description,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      final notes = _mockDatabase['notes'] as List;
      final noteIndex = notes.indexWhere((n) => n['id'] == id);

      if (noteIndex == -1) {
        throw Exception('Note not found');
      }

      final oldNote = NoteModel.fromJson(notes[noteIndex]);
      final updatedNote = oldNote.copyWith(
        title: title,
        description: description,
        updatedAt: DateTime.now(),
      );

      notes[noteIndex] = updatedNote.toJson();

      return updatedNote;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteNote(String id) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      final notes = _mockDatabase['notes'] as List;
      notes.removeWhere((n) => n['id'] == id);

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
