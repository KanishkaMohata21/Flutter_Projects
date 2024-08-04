import 'package:dice/dice.dart';
import 'package:flutter/material.dart';
import 'package:dice/styled_text.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key});

  // Define the rollDice function if you plan to add logic
  void rollDice() {
    // Logic for rolling dice
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 26, 2, 80),
            Color.fromARGB(255, 45, 7, 98),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Dice()
      ),
    );
  }
}
