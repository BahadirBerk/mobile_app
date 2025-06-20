import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../providers/notes_provider.dart';
import '../../../models/note.dart';
import '../widgets/note_editor.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;
  const NoteDetailScreen({super.key, this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late quill.QuillController _controller;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _controller = widget.note == null
        ? quill.QuillController.basic()
        : quill.QuillController(
            document: quill.Document()..insert(0, widget.note!.content),
            selection: const TextSelection.collapsed(offset: 0),
          );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final content = _controller.document.toPlainText();
    final note = Note(
      id: widget.note?.id,
      title: _titleController.text,
      content: content,
      createdAt: widget.note?.createdAt,
    );
    final provider = context.read<NotesProvider>();
    if (widget.note == null) {
      await provider.addNote(note);
    } else {
      await provider.updateNote(note);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await context.read<NotesProvider>().deleteNote(widget.note!);
                if (mounted) Navigator.pop(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 8),
            Expanded(child: NoteEditor(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
