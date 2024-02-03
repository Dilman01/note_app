import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../model/note.dart';

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
        'CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, content TEXT)');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'notes_list.db',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  Future<int> createNote(String id, String title, String content) async {
    final db = await SQLHelper.db();

    final data = {'id': id, 'title': title, 'content': content};

    final rowID = await db.insert(
      'notes',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return rowID;
  }

  Future<List<Note>> getNotes() async {
    final db = await SQLHelper.db();

    final list = await db.query('notes');

    final notes = list
        .map(
          (e) => Note(
            id: e['id'] as String,
            title: e['title'] as String,
            content: e['content'] as String,
          ),
        )
        .toList();

    return notes;
  }

  Future<void> deleteNote(String id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Something went wrong when deleting a Note: $e');
    }
  }
}
