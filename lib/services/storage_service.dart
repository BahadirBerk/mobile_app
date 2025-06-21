import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

/// Service responsible for local data storage using JSON files.
class StorageService {
  static final StorageService instance = StorageService._internal();
  StorageService._internal();

  static const String _notesFileName = 'notes.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _notesFile async {
    final path = await _localPath;
    return File('$path/$_notesFileName');
  }

  Future<List<Note>> fetchNotes() async {
    try {
      final file = await _notesFile;
      if (!await file.exists()) {
        return [];
      }

      final String contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      
      return jsonList.map((json) => Note.fromMap(json)).toList();
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  Future<int> insertNote(Note note) async {
    try {
      final notes = await fetchNotes();
      final maxId = notes.isEmpty 
          ? 0 
          : notes.map((n) => n.id ?? 0).reduce((a, b) => a > b ? a : b);
      final newNote = note.copyWith(id: maxId + 1);
      
      notes.add(newNote);
      await _saveNotes(notes);
      
      return newNote.id ?? 0;
    } catch (e) {
      print('Error inserting note: $e');
      return -1;
    }
  }

  Future<int> updateNote(Note note) async {
    try {
      final notes = await fetchNotes();
      final index = notes.indexWhere((n) => n.id == note.id);
      
      if (index != -1) {
        notes[index] = note;
        await _saveNotes(notes);
        return 1;
      }
      return 0;
    } catch (e) {
      print('Error updating note: $e');
      return 0;
    }
  }

  Future<int> deleteNote(int id) async {
    try {
      final notes = await fetchNotes();
      notes.removeWhere((note) => note.id == id);
      await _saveNotes(notes);
      return 1;
    } catch (e) {
      print('Error deleting note: $e');
      return 0;
    }
  }

  Future<void> _saveNotes(List<Note> notes) async {
    try {
      final file = await _notesFile;
      final jsonList = notes.map((note) => note.toMap()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving notes: $e');
    }
  }
}
