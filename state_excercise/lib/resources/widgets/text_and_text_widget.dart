import 'package:flutter/material.dart';
class TextAndTextWidget extends StatelessWidget {
  final String titleText;
  final String contentText;
  final textContentBoxColor;
  final alignContentText;

  const TextAndTextWidget({Key? key, required this.titleText, required this.contentText, required this.textContentBoxColor, required this.alignContentText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(titleText),
          ),
          Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                color: textContentBoxColor,
                child: Text(contentText,
                  textAlign: alignContentText,
                ),
              )
          )
        ],
      ),
    );
  }
}
