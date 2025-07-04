import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';

class TypingText extends StatefulWidget {
  final String text;
  final TypographyVariation variation;
  final VoidCallback? onTypingComplete;
  final Duration duration;
  final bool autoStart;

  const TypingText({
    super.key,
    required this.text,
    required this.variation,
    this.onTypingComplete,
    this.duration = const Duration(milliseconds: 1000),
    this.autoStart = true,
  });
  @override
  State<TypingText> createState() => TypingTextState();
}

class TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onTypingComplete?.call();
        }
      });

    _typingAnimation = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_controller);

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  void startTyping() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TypingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, child) {
        return Typography(
          widget.text.substring(0, _typingAnimation.value),
          variation: widget.variation,
        );
      },
    );
  }
}
