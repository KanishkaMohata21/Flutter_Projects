import 'package:flutter/material.dart';
import 'dart:math';

class Dice extends StatefulWidget {
  Dice({super.key});
  @override
  State<Dice> createState(){
    return _DiceState();
  }
}

class _DiceState extends State<Dice> {
  String diceImage = 'assets/Images/dice-1.png'; 

  void rollDice() {
   int randomFace = Random().nextInt(6)+1;
    setState(() {
     print(randomFace);
      diceImage = 'assets/Images/dice-$randomFace.png'; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'KDice',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold ,color: Colors.white),
        ),
        const SizedBox(height: 20),
        Image.asset(
          diceImage, 
          width: 150,
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: rollDice,
          child: const Text('Roll Dice'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 28),
          ),
        ),
      ],
    );
  }
}
