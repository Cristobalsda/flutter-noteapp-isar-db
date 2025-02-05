import 'package:flutter/material.dart';
import 'package:flutter_application_isar_db/models/note.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
  //* INITIALIZE THE DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  //* LIST OF NOTE
  final List<Note> currentNote = [];
  //* CREATE
  Future<void> addNote(String textFromUser) async {
    //* crete a new note object
    final newNote = Note()..text = textFromUser;
    //* save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //*re-read from db
    fetchNotes();
  }

  //* READ
  Future<void> fetchNotes() async {
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNote.clear();
    currentNote.addAll(fetchNotes);
    notifyListeners();
  }

  //* UPDATE
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  //* DELETE
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
