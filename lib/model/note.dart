import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String title;
  final String content;

  Note({
    required this.title,
    required this.content,
    String? id,
  }) : id = id ?? const Uuid().v4();
}
