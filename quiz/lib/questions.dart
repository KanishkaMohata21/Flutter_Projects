import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz/answerButton.dart';
import 'package:quiz/data.dart';
import 'package:quiz/question.dart';

class Questions extends StatefulWidget {
  const Questions({super.key, required this.chooseAnswer});
  final void Function(String answer) chooseAnswer;

  @override
  State<Questions> createState() => _QuestionState();
}

class _QuestionState extends State<Questions> {
  var currentQuestionIndex = 0;

  void answerQuestion(String answer) {
    widget.chooseAnswer(answer);
    setState(() {
      currentQuestionIndex = currentQuestionIndex + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = data[currentQuestionIndex];
    return Container(
      margin: EdgeInsets.all(30),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.question,
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 201, 153, 251),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...currentQuestion.getShuffledList().map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10), // Adjust the space between buttons
                child: Answerbutton(item, () => answerQuestion(item)),
              );
            }),
          ],
        ),
      ),
    );
  }
}
