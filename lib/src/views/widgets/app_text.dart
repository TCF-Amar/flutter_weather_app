import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final bool bold;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  const AppText({
    super.key,
   required this.text,
    this.bold = false,
    this.color = const Color.fromARGB(221, 47, 47, 47),
    this.fontSize = 16,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
