import 'package:flutter/material.dart';
import 'package:quiz/data.dart';
import 'package:quiz/questions.dart';
import 'package:quiz/results.dart';
import 'package:quiz/start_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  Widget? activeScreen;
  List<String> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    activeScreen = StartScreen(switchScreen);
  }

  void switchScreen() {
    setState(() {
      activeScreen = Questions(chooseAnswer: chooseAnswer);
    });
  }

  void chooseAnswer(String answer) {
    setState(() {
      selectedAnswers.add(answer);
      if (selectedAnswers.length == data.length) {
        activeScreen = Result(
          chooseAnswer: selectedAnswers,
          onRestart: restartQuiz, // Pass the restart function
        );
      }
      print(selectedAnswers);
    });
  }

  void restartQuiz() {
    setState(() {
      selectedAnswers = [];
      activeScreen = StartScreen(switchScreen); // Reset the screen to StartScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: activeScreen,
        ),
      ),
    );
  }
}
