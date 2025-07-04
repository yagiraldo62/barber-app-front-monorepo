import 'package:flutter/material.dart';
import 'package:ui/widgets/typography/typography.dart';
import 'package:ui/widgets/typing_text/typing_text.dart';

class Greet extends StatefulWidget {
  final VoidCallback? onGreetComplete;
  final String name;

  const Greet({super.key, this.onGreetComplete, this.name = ''});

  @override
  State<Greet> createState() => _GreetState();
}

class _GreetState extends State<Greet> {
  final handKey = GlobalKey<_AnimatedWavingHandState>();
  final nameKey = GlobalKey<TypingTextState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            TypingText(
              text: 'Hola, ',
              variation: TypographyVariation.bodyMedium,
              duration: const Duration(milliseconds: 500),
              onTypingComplete: () {
                // Start typing the name after "Hola, " is complete
                nameKey.currentState?.startTyping();
              },
            ),
            TypingText(
              key: nameKey,
              text: widget.name,
              variation: TypographyVariation.displayMedium,
              autoStart: false, // Don't start automatically
              duration: const Duration(milliseconds: 500),
              onTypingComplete: () {
                handKey.currentState?.show();
              },
            ),
          ],
        ),
        const SizedBox(width: 8),
        _AnimatedWavingHand(
          key: handKey,
          onWaveComplete: widget.onGreetComplete,
        ),
      ],
    );
  }
}

class _AnimatedWavingHand extends StatefulWidget {
  final VoidCallback? onWaveComplete;

  const _AnimatedWavingHand({super.key, this.onWaveComplete});

  @override
  State<_AnimatedWavingHand> createState() => _AnimatedWavingHandState();
}

class _AnimatedWavingHandState extends State<_AnimatedWavingHand>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;

  void show() {
    setState(() => _isVisible = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: _WavingHand(onWaveComplete: widget.onWaveComplete),
    );
  }
}

class _WavingHand extends StatefulWidget {
  final VoidCallback? onWaveComplete;

  const _WavingHand({this.onWaveComplete});

  @override
  State<_WavingHand> createState() => _WavingHandState();
}

class _WavingHandState extends State<_WavingHand>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _waveCount = 0;
  final int _maxWaves = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _waveCount++;
        if (_waveCount >= _maxWaves) {
          _controller.stop();
          widget.onWaveComplete?.call();
        } else {
          _controller.forward();
        }
      }
    });

    _animation = Tween<double>(begin: -0.0, end: 0.1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      alignment: Alignment.bottomRight,
      turns: _animation,
      child: const Text(
        '👋',
        style: TextStyle(
          fontSize: 24,
          // Don't specify color - let the emoji use its natural colors
        ),
      ),
    );
  }
}
