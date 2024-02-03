import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/model/note.dart';

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]);

  void addNote(String title, String content) {
    state = [Note(title: title, content: content), ...state];
  }

  void deleteNote(String id) {
    state = state.where((element) => element.id != id).toList();
  }
}

final noteProiver = StateNotifierProvider<NoteNotifier, List<Note>>(
  (ref) => NoteNotifier(),
);
