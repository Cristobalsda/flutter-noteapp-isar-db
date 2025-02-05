import 'package:flutter/material.dart';
import 'package:flutter_application_isar_db/models/note.dart';
import 'package:flutter_application_isar_db/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //* on app startup, fetch existing notes
    readNotes();
  }

  //* create note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              //* add to db
              context.read<NoteDatabase>().addNote(textController.text);
              //* clear controller
              textController.clear();
              //* pop dialog box
              Navigator.pop(context);
            },
            child: const Text('Create'),
          )
        ],
      ),
    );
  }

  //* read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //* update a note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update note'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          //* Update note in db
          MaterialButton(
            onPressed: () {
              //* update note in db
              context
                  .read<NoteDatabase>()
                  .updateNote(note.id, textController.text);
              //* clear controller
              textController.clear();
              //* pop dialog box
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  //* delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    //*Note database
    final noteDatabase = context.watch<NoteDatabase>();

    //* Current notes
    List<Note> currentNote = noteDatabase.currentNote;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNote.length,
        itemBuilder: (context, index) {
          //* get individual note
          final note = currentNote[index];

          //* list title UI
          return ListTile(
            title: Text(note.text),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //*Edit button
                IconButton(
                  onPressed: () => updateNote(note),
                  icon: const Icon(Icons.edit),
                ),
                //*Delted button
                IconButton(
                  onPressed: () => deleteNote(note.id),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
