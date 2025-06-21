import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteEditor extends StatefulWidget {
  final quill.QuillController controller;
  const NoteEditor({Key? key, required this.controller}) : super(key: key);

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─────────── TOOLBAR ───────────
        quill.QuillSimpleToolbar(
          controller: widget.controller,
          config: const quill.QuillSimpleToolbarConfig(),
        ),

        // ─────────── EDITÖR ────────────
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: quill.QuillEditor.basic(
              controller: widget.controller,
              config: const quill.QuillEditorConfig(
                scrollable: true,
                autoFocus: false,
                expands: true,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
