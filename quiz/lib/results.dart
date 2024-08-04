import 'package:flutter/material.dart';
import 'package:quiz/data.dart';
import 'package:quiz/summary.dart';

class Result extends StatelessWidget {
  final List<String> chooseAnswer;
  final VoidCallback onRestart; // Add callback for restart functionality

  Result({Key? key, required this.chooseAnswer, required this.onRestart}) : super(key: key);

  List<Map<String, Object>> getSummary() {
    final List<Map<String, Object>> summary = [];
    for (var i = 0; i < chooseAnswer.length; i++) {
      summary.add({
        'question_index': i,
        'question': data[i].question,
        'correctAnswer': data[i].answer.isNotEmpty ? data[i].answer[0] : 'N/A',
        'user_answer': chooseAnswer[i],
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Summary(getSummary()),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onRestart, // Call the restart callback
              child: const Text(
                'Restart',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
