import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  const AnimatedText({
    super.key,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle,
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
        .slide();
  }
}
