import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/bloc/note_bloc.dart';
import 'package:note_app/screens/home_screen.dart';

void main() {
  runApp(
    const NoteApp(),
  );
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteBloc>(
      create: (context) => NoteBloc()
        ..add(
          LoadNotes(),
        ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff252525),
          ),
          scaffoldBackgroundColor: const Color(0xff252525),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
