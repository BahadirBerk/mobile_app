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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2E8B57).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Simplified Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF2E8B57).withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Bold Button
                _buildToolbarButton(
                  icon: Icons.format_bold,
                  isActive: false,
                  onPressed: () {
                    widget.controller.formatSelection(quill.Attribute.bold);
                  },
                ),
                const SizedBox(width: 8),
                
                // Italic Button
                _buildToolbarButton(
                  icon: Icons.format_italic,
                  isActive: false,
                  onPressed: () {
                    widget.controller.formatSelection(quill.Attribute.italic);
                  },
                ),
                const SizedBox(width: 8),
                
                // Bullet List Button
                _buildToolbarButton(
                  icon: Icons.format_list_bulleted,
                  isActive: false,
                  onPressed: () {
                    widget.controller.formatSelection(quill.Attribute.ul);
                  },
                ),
                const SizedBox(width: 8),
                
                // Checkbox Button
                _buildToolbarButton(
                  icon: Icons.check_box_outline_blank,
                  isActive: false,
                  onPressed: () {
                    widget.controller.formatSelection(quill.Attribute.checked);
                  },
                ),
              ],
            ),
          ),

          // Editor
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: quill.QuillEditor(
                controller: widget.controller,
                scrollController: _scrollController,
                focusNode: _focusNode,
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
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive 
            ? const Color(0xFF2E8B57).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive 
              ? const Color(0xFF2E8B57)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: isActive 
              ? const Color(0xFF2E8B57)
              : Colors.grey[600],
        ),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
      ),
    );
  }
}
