import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/model/note.dart';

import 'package:sqflite/sqflite.dart' as sql;

import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();

  final db = await sql.openDatabase(
    path.join(dbPath, 'notes_list.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, content TEXT)');
    },
    version: 1,
  );

  return db;
}

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]);

  Future<void> loadNotes() async {
    final db = await _getDatabase();
    final data = await db.query('notes');

    final notes = data
        .map(
          (e) => Note(
            id: e['id'] as String,
            title: e['title'] as String,
            content: e['content'] as String,
          ),
        )
        .toList()
        .reversed
        .toList();

    state = notes;
  }

  void addNote(String title, String content) async {
    final note = Note(title: title, content: content);

    final db = await _getDatabase();

    await db.insert('notes', {
      'id': note.id,
      'title': note.title,
      'content': note.content,
    });

    state = [note, ...state];
  }

  void deleteNote(String id) async {
    final db = await _getDatabase();

    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    state = state.where((element) => element.id != id).toList();
  }
}

final noteProiver = StateNotifierProvider<NoteNotifier, List<Note>>(
  (ref) => NoteNotifier(),
);
