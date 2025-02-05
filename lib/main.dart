import 'package:flutter/material.dart';
import 'package:flutter_application_isar_db/models/note_database.dart';
import 'package:flutter_application_isar_db/pages/notes_page.dart';
import 'package:provider/provider.dart';

void main() async {
  //* initialize note isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}
