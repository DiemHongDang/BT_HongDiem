import 'package:flutter/material.dart';
class TextWidget extends StatelessWidget {
  final String text;
  final colorText;
  final colorBox;
  final textAlign;
  final weightBox;
  EdgeInsetsGeometry? marginBox;
  TextWidget({Key? key, required this.text,required this.colorText, required this.colorBox, required this.textAlign, required this.weightBox, this.marginBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: weightBox,
      padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
      margin: marginBox,
      decoration: BoxDecoration(
          color: colorBox
      ),
      child: Text(text,
        textAlign: textAlign,
        style: TextStyle(
          color:colorText,
        ),),
    );
  }


}
