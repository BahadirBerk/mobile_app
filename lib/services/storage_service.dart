import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note.dart';
import '../utils/encryption.dart';

/// Service responsible for local data storage.
class StorageService {
  static const _dbName = 'notes.db';
  static const _dbVersion = 1;
  static const _tableName = 'notes';

  static final StorageService instance = StorageService._internal();
  Database? _database;

  StorageService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            created_at TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    // Encrypt content before saving.
    final encrypted = Encryption.encrypt(note.content);
    return db.insert(_tableName, note.copyWith(content: encrypted).toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    final encrypted = Encryption.encrypt(note.content);
    return db.update(
      _tableName,
      note.copyWith(content: encrypted).toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> fetchNotes() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'created_at DESC');
    return [
      for (final m in maps)
        Note.fromMap(m).copyWith(
          content: Encryption.decrypt(m['content'] as String),
        )
    ];
  }
}

extension on Note {
  Note copyWith({int? id, String? title, String? content, DateTime? createdAt}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
