import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double velocity;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Duration pauseAfterRound;

  const AnimatedText({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.velocity = 40,
    this.blankSpace = 50,
    this.startPadding = 10,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(seconds: 1),
    this.pauseAfterRound = const Duration(seconds: 1),
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth); // ✅ Fixed: added maxWidth

        final isOverflowing = textPainter.width < constraints.maxWidth;

        if (isOverflowing) {
          return Text(
            text,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        //  Fixed: Wrap Marquee in SizedBox with fixed height
        return SizedBox(
          height: fontSize * 1.5, // Height based on font size
          child: Marquee(
            text: text,
            style: textStyle,
            velocity: velocity,
            blankSpace: blankSpace,
            startPadding: startPadding,
            scrollAxis: Axis.horizontal,
            pauseAfterRound: pauseAfterRound,
            accelerationDuration: accelerationDuration,
            decelerationDuration: decelerationDuration,
            accelerationCurve: Curves.linear,
            decelerationCurve: Curves.linear,
          ),
        );
      },
    );
  }
}
