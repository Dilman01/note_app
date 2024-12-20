import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:note_app/bloc/note_bloc.dart';
import 'package:note_app/screens/note_screen.dart';

class NoteContainer extends StatelessWidget {
  const NoteContainer({
    super.key,
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    List<dynamic> colors = const [
      Color(0xffFD99FF),
      Color(0xffFF9E9E),
      Color(0xff91F48F),
      Color(0xffFFF599),
      Color(0xff9EFFFF),
      Color(0xffB69CFF)
    ];
    Random random = Random();
    int randomIndex = random.nextInt(colors.length);
    Color randomColor = colors[randomIndex];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteScreen(
              title: title,
              content: content,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Dismissible(
          key: Key(title),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direction) {
            context.read<NoteBloc>().add(DeleteNote(id: id));
          },
          direction: DismissDirection.endToStart,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: randomColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () {
                  context.read<NoteBloc>().add(DeleteNote(id: id));
                },
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
