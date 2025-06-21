
/// Data model for a note.
class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert a note to a map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create a [Note] object from a map.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
