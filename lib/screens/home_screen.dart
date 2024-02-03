import 'package:flutter/material.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/widgets/note_container.dart';
import 'package:note_app/provider/note_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
//  late Future<void> _notesLoad;

  @override
  void initState() {
    super.initState();

    ref.read(noteProiver.notifier).loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(noteProiver);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Note App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) => NoteContainer(
          id: notes[index].id,
          title: notes[index].title,
          content: notes[index].content,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddNoteScreen(),
            ),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
