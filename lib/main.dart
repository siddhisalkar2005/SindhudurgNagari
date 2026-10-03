import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SindhudurgNagri());
}

class SindhudurgNagri extends StatelessWidget {
  const SindhudurgNagri({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'SindhudurgNagri',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087E8B),
        ),

        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),

      home: const WelcomeScreen(),
    );
  }
}