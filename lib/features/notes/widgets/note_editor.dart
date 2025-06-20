import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Rich text editor widget using flutter_quill.
class NoteEditor extends StatefulWidget {
  final quill.QuillController controller;
  const NoteEditor({super.key, required this.controller});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        quill.QuillToolbar.basic(controller: widget.controller),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: quill.QuillEditor.basic(
              controller: widget.controller,
              readOnly: false,
            ),
          ),
        ),
      ],
    );
  }
}
