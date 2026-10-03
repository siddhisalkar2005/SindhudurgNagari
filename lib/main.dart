import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
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
      ),
      home: const WelcomeScreen(),
    );
  }
}