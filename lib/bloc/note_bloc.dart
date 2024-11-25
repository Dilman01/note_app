import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:note_app/model/note.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

part 'note_event.dart';
part 'note_state.dart';

Future<sql.Database> _getDatabase() async {
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

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<LoadNotes>(_loadNotes);
    on<AddNote>(_addNote);
    on<DeleteNote>(_deleteNote);
  }

  void _loadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());

    try {
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

      emit(NoteLoaded(notes: notes));
    } catch (e) {
      emit(NoteFailure(message: e.toString()));
    }
  }

  void _addNote(AddNote event, Emitter<NoteState> emit) async {
    if (state is! NoteLoaded) return;

    final currentState = state as NoteLoaded;
    final newNote = Note(
      title: event.title,
      content: event.content,
    );

    try {
      final db = await _getDatabase();
      await db.insert('notes', {
        'id': newNote.id,
        'title': newNote.title,
        'content': newNote.content,
      });

      final updatedNotes = [newNote, ...currentState.notes];
      emit(NoteLoaded(notes: updatedNotes));
    } catch (e) {
      emit(NoteFailure(message: e.toString()));
    }
  }

  void _deleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    if (state is! NoteLoaded) return;

    final currentState = state as NoteLoaded;

    try {
      final db = await _getDatabase();
      await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [event.id],
      );

      final updatedNotes =
          currentState.notes.where((note) => note.id != event.id).toList();

      emit(NoteLoaded(notes: updatedNotes));
    } catch (e) {
      emit(NoteFailure(message: 'Failed to delete note: $e'));
    }
  }
}
