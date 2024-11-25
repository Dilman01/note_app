part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

final class LoadNotes extends NoteEvent {}

final class AddNote extends NoteEvent {
  final String title;
  final String content;

  AddNote({required this.title, required this.content});
}

final class DeleteNote extends NoteEvent {
  final String id;

  DeleteNote({required this.id});
}
