import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/notes/providers/notes_provider.dart';
import 'services/ai_api_service.dart';
import 'features/notes/screens/notes_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BrainyNoteApp());
}

class BrainyNoteApp extends StatelessWidget {
  const BrainyNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesProvider(
            AiApiService(apiKey: 'YOUR_OPENAI_API_KEY'),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Brainy Note',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const NotesListScreen(),
      ),
    );
  }
}
