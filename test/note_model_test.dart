import 'package:flutter_test/flutter_test.dart';
import '../lib/models/note.dart';

void main() {
  test('Note toMap and fromMap', () {
    final note = Note(title: 't', content: 'c');
    final map = note.toMap();
    final restored = Note.fromMap(map);
    expect(restored.title, note.title);
    expect(restored.content, note.content);
  });
}
