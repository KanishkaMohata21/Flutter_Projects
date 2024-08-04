import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen( this.startQuiz,{ Key? key}) : super(key: key);
  
  final void Function() startQuiz;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            '../assets/quiz-logo.png', // Ensure this path is correct in your pubspec.yaml
            width: 250,
            color: const Color.fromARGB(150, 255, 255, 255),
          ),
          const SizedBox(height: 55),
          const Text(
            'Learn Flutter the fun way',  
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          OutlinedButton.icon(
            onPressed: startQuiz,
            icon: const Icon(Icons.arrow_circle_right_rounded),
            label: const Text('Start Now'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
