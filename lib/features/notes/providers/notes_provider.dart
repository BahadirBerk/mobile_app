import 'package:flutter/foundation.dart';
import '../../../models/note.dart';
import '../../../services/storage_service.dart';
import '../../../services/ai_api_service.dart';

/// Provider for managing notes state.
class NotesProvider extends ChangeNotifier {
  final StorageService _storage = StorageService.instance;
  final AiApiService _aiApiService;

  NotesProvider(this._aiApiService);

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await _storage.fetchNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _storage.insertNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    if (note.id != null) {
      await _storage.updateNote(note);
      await loadNotes();
    }
  }

  Future<void> deleteNote(Note note) async {
    if (note.id != null) {
      await _storage.deleteNote(note.id!);
      await loadNotes();
    }
  }

  Future<String> summarize(Note note) async {
    return _aiApiService.summarize(note.content);
  }

  Future<String> keywords(Note note) async {
    return _aiApiService.extractKeywords(note.content);
  }

  Future<String> generateQuestions(Note note) async {
    return _aiApiService.generateQuestions(note.content);
  }
}
