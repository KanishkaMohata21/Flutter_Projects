import 'package:flutter/material.dart';
import 'package:quiz/data.dart';

class Summary extends StatelessWidget {
  final List<Map<String, Object>> summary;

  Summary(this.summary, {super.key});

  @override
  Widget build(BuildContext context) {
    int correctAnswersCount = summary.where((data) => data['user_answer'] == data['correctAnswer']).length;
    print(correctAnswersCount);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'You have answered $correctAnswersCount questions correctly',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: summary.map((data) {
              bool isCorrect = data['user_answer'] == data['correctAnswer'];

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCorrect ? Colors.green : Colors.red, // Green for correct, red for incorrect
                      ),
                      child: Center(
                        child: Text(
                          '${((data['question_index'] as int) + 1).toString()}', // Increment index here
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question: ${data['question']}',
                            style: const TextStyle(
                              color: Colors.white, // Text color for dark background
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Your Answer: ${data['user_answer']}',
                            style: const TextStyle(
                              color: Colors.grey, // Slightly lighter text
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Correct Answer: ${data['correctAnswer']}',
                            style: const TextStyle(
                              color: Colors.grey, // Slightly lighter text
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
