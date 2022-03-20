import 'package:flutter/material.dart';
class TextAndTextFieldWidget extends StatelessWidget {
  final text;
  final textController;
  final hintText;
  final keyboardType;
  FocusNode? focusNode;

  TextAndTextFieldWidget({Key? key, required this.text, required this.textController, required this.hintText, required this.keyboardType, this.focusNode }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(text),
          ),
          Expanded(
              flex: 3,
              child: TextField(
                  controller: textController,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hintText,
                  ),
                focusNode: focusNode,
              ))
        ],
      ),
    );
  }


}
