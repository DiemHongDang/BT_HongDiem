import 'package:flutter/material.dart';
class ButtonItemWidget extends StatelessWidget {
  final String buttonText;
  final buttonFunction;
  const ButtonItemWidget({Key? key, required this.buttonText, required this.buttonFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        color: Colors.grey,
        padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
        child: Text(buttonText.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      onTap: buttonFunction,
    );
  }
}
