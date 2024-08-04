import 'package:flutter/material.dart';

class Answerbutton extends StatelessWidget {
  const Answerbutton(this.answer,this.ontap,{super.key});
  final String answer;
  final void Function() ontap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:ontap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 33, 1, 95),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding:const EdgeInsets.symmetric(vertical: 10, horizontal:40)
      ),
      child: Text(answer,textAlign: TextAlign.center,),
    );
  }
}
