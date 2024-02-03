import 'package:flutter/material.dart';
import 'package:note_app/screens/home_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: NoteApp(),
    ),
  );
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xff252525)),
        scaffoldBackgroundColor: const Color(0xff252525),
      ),
      home: const HomeScreen(),
    );
  }
}
