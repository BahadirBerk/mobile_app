import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/notes/providers/notes_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'services/ai_api_service.dart';
import 'features/notes/screens/notes_list_screen.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BrainyNoteApp());
}

class BrainyNoteApp extends StatelessWidget {
  const BrainyNoteApp({super.key});

  // This should be loaded from a secure source, e.g. --dart-define
  static const openAiApiKey =
      String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotesProvider(
            AiApiService(apiKey: openAiApiKey),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Brainy Note',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('tr', ''),
        ],
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const NotesListScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
