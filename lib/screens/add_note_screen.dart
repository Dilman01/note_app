import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/bloc/note_bloc.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  void saveNote() {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      context.read<NoteBloc>().add(
            AddNote(
              title: titleController.text,
              content: contentController.text,
            ),
          );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool value = true;
    return PopScope(
      canPop: value,
      onPopInvokedWithResult: (didPop, result) async {
        if (titleController.text.isNotEmpty &&
            contentController.text.isNotEmpty) {
          value = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text(
                  'Save the note?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                backgroundColor: const Color(0xff252525),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      saveNote();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'Add Note',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => saveNote(),
              icon: const Icon(
                Icons.save_rounded,
                size: 30,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: double.infinity,
                child: TextField(
                  controller: titleController,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'TITLE',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 35,
                    ),
                    contentPadding: EdgeInsets.all(10),
                    border: UnderlineInputBorder(),
                    focusColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 400,
                width: double.infinity,
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  controller: contentController,
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: 'Write your note here.....',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ElevatedButton(
                  onPressed: () => saveNote(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
