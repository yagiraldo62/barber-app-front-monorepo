import 'package:flutter/material.dart';
import 'package:ui/widgets/typography/typography.dart';
import 'package:ui/widgets/typing_text/typing_text.dart';
import 'package:utils/log.dart';

/// A widget that displays a series of messages in sequence with typing animation.
/// Each message can have its own duration and spacing after it.
class SequentialTypingMessagesItem {
  final String text;
  final TypographyVariation variation;
  final Duration duration;
  final double spacingAfter;

  const SequentialTypingMessagesItem({
    required this.text,
    this.variation = TypographyVariation.bodyMedium,
    this.duration = const Duration(milliseconds: 600),
    this.spacingAfter = 16.0,
  });
}

class SequentialTypingMessages extends StatefulWidget {
  /// Called when all messages have been displayed and animations have completed
  final VoidCallback? onComplete;

  /// List of message configurations to display in sequence
  final List<SequentialTypingMessagesItem> messages;

  /// Delay before calling onComplete after the last message is shown
  final Duration completeDelay;

  /// Whether to start the animation immediately when the widget is built
  final bool startImmediately;

  bool alreadyStarted = false;

  SequentialTypingMessages({
    super.key,
    this.onComplete,
    this.completeDelay = const Duration(milliseconds: 100),
    required this.messages,
    this.startImmediately = false,
  });

  @override
  State<SequentialTypingMessages> createState() =>
      SequentialTypingMessagesState();
}

class SequentialTypingMessagesState extends State<SequentialTypingMessages> {
  int _currentTextIndex = -1;

  @override
  void initState() {
    super.initState();
    if (widget.startImmediately) {
      // Use a post-frame callback to ensure the widget is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Log({'_currentTextIndex': _currentTextIndex});
        if (widget.alreadyStarted) return;

        Log('Starting animation...');
        startAnimation();
        widget.alreadyStarted = true;
      });
    }
  }

  void startAnimation() {
    if (_currentTextIndex == -1) {
      setState(() => _currentTextIndex = 0);
    }
  }

  void _onTypingComplete() {
    final lastIndex = widget.messages.length - 1;

    if (_currentTextIndex < lastIndex) {
      // Not the last message, move to the next one
      setState(() {
        _currentTextIndex++;
      });
    } else if (_currentTextIndex == lastIndex) {
      // This is the last message and it has finished typing
      Future.delayed(widget.completeDelay, () {
        widget.onComplete?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTextIndex == -1) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildMessageWidgets(),
    );
  }

  List<Widget> _buildMessageWidgets() {
    final List<Widget> widgets = [];

    for (int i = 0; i <= _currentTextIndex && i < widget.messages.length; i++) {
      final message = widget.messages[i];

      // Add the typing text widget
      widgets.add(
        TypingText(
          text: message.text,
          variation: message.variation,
          duration: message.duration,
          onTypingComplete: i == _currentTextIndex ? _onTypingComplete : null,
        ),
      );

      // Add spacing after message if not the last one or if spacing is specified
      if (message.spacingAfter > 0) {
        widgets.add(SizedBox(height: message.spacingAfter));
      }
    }

    return widgets;
  }
}
