import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typing_text/typing_text.dart';
import 'package:ui/widgets/typography/typography.dart';

/// A reusable widget for form steps with animated typing text and content reveal
class AnimatedFormStep extends StatefulWidget {
  /// The main title text to be animated
  final String title;

  /// Optional intro text that appears before the title
  final String? introText;

  /// Optional description text that appears after the title
  final String? descriptionText;

  /// The child widget to be displayed after the typing animation (form field, etc)
  final Widget content;

  /// Optional focus node to request focus after animation completes
  final FocusNode? focusNode;

  /// Variation for the title typography
  final TypographyVariation titleVariation;

  /// Variation for the intro text typography
  final TypographyVariation introVariation;

  /// Variation for the description text typography
  final TypographyVariation descriptionVariation;

  /// Duration for the title typing animation
  final Duration titleDuration;

  /// Duration for the intro text typing animation
  final Duration introDuration;

  /// Duration for the description text typing animation
  final Duration descriptionDuration;

  /// Duration for content fade-in animation
  final Duration fadeDuration;

  /// Delay before requesting focus
  final Duration focusDelay;

  /// Padding for the content widget
  final EdgeInsetsGeometry contentPadding;

  /// Optional callback when all animations complete
  final VoidCallback? onAnimationsComplete;

  /// Whether to show all components at once without progressive animation
  /// If true, all text and content appear immediately
  /// If false (default), components appear progressively with typing animations
  final bool noAnimation;

  final VoidCallback? scrollToBottom;

  /// Optional key for the typing text widget
  final Key? typingKey;

  const AnimatedFormStep({
    super.key,
    required this.title,
    this.introText,
    this.descriptionText,
    required this.content,
    this.scrollToBottom,
    this.focusNode,
    this.titleVariation = TypographyVariation.displayMedium,
    this.introVariation = TypographyVariation.bodySmall,
    this.descriptionVariation = TypographyVariation.bodySmall,
    this.titleDuration = const Duration(milliseconds: 800),
    this.introDuration = const Duration(milliseconds: 1200),
    this.descriptionDuration = const Duration(milliseconds: 1000),
    this.fadeDuration = const Duration(milliseconds: 500),
    this.focusDelay = const Duration(milliseconds: 500),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 0),
    this.onAnimationsComplete,
    this.noAnimation = false,
    this.typingKey,
  });

  @override
  State<AnimatedFormStep> createState() => _AnimatedFormStepState();
}

class _AnimatedFormStepState extends State<AnimatedFormStep> {
  bool _showIntro = false;
  bool _showTitle = false;
  bool _showDescription = false;
  bool _showContent = false;

  // Animation opacity states
  bool _introOpacityVisible = false;
  bool _titleOpacityVisible = false;
  bool _descriptionOpacityVisible = false;
  bool _contentOpacityVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.noAnimation) {
      _showAllImmediately();
    } else {
      _startAnimationSequence();
    }
  }

  void _showAllImmediately() {
    // Show all components immediately without animation
    setState(() {
      _showIntro = widget.introText != null;
      _showTitle = true;
      _showDescription = widget.descriptionText != null;
      _showContent = true;
      _introOpacityVisible = widget.introText != null;
      _titleOpacityVisible = true;
      _descriptionOpacityVisible = widget.descriptionText != null;
      _contentOpacityVisible = true;
    });

    // Request focus immediately if needed
    if (widget.focusNode != null && !widget.noAnimation) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) widget.focusNode?.requestFocus();
      });
    }

    // Notify parent after this frame to avoid triggering ancestor rebuilds during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onAnimationsComplete?.call();
    });
  }

  void _startAnimationSequence() {
    // Reset all animation states
    setState(() {
      _showIntro = false;
      _showTitle = false;
      _showDescription = false;
      _showContent = false;
      _introOpacityVisible = false;
      _titleOpacityVisible = false;
      _descriptionOpacityVisible = false;
      _contentOpacityVisible = false;
    });

    // Start the animation sequence based on which text elements are present
    if (widget.introText != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() => _showIntro = true);
          // Start opacity animation after a brief delay
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) {
              setState(() => _introOpacityVisible = true);
              // Scroll after intro becomes visible
              Future.delayed(
                widget.introDuration + const Duration(milliseconds: 100),
                () {
                  widget.scrollToBottom?.call();
                },
              );
            }
          });
        }
      });
    } else {
      // No intro text, start with title
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() => _showTitle = true);
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) {
              setState(() => _titleOpacityVisible = true);
              // Scroll after title becomes visible
              Future.delayed(
                widget.titleDuration + const Duration(milliseconds: 100),
                () {
                  widget.scrollToBottom?.call();
                },
              );
            }
          });
        }
      });
    }
  }

  void _onIntroComplete() {
    if (mounted) {
      setState(() => _showTitle = true);
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() => _titleOpacityVisible = true);
          // Scroll after title becomes visible
          Future.delayed(
            widget.titleDuration + const Duration(milliseconds: 100),
            () {
              widget.scrollToBottom?.call();
            },
          );
        }
      });
    }
  }

  void _onTitleComplete() {
    if (widget.descriptionText != null) {
      if (mounted) {
        setState(() => _showDescription = true);
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            setState(() => _descriptionOpacityVisible = true);
            // Scroll after description becomes visible
            Future.delayed(
              widget.descriptionDuration + const Duration(milliseconds: 100),
              () {
                widget.scrollToBottom?.call();
              },
            );
          }
        });
      }
    } else {
      _finalizeAnimation();
    }
  }

  void _onDescriptionComplete() {
    _finalizeAnimation();
  }

  void _finalizeAnimation() {
    if (mounted) {
      setState(() => _showContent = true);

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() => _contentOpacityVisible = true);
          // Scroll after content opacity is set
          Future.delayed(const Duration(milliseconds: 100), () {
            widget.scrollToBottom?.call();
          });
        }
      });

      if (widget.focusNode != null && !widget.noAnimation) {
        Future.delayed(widget.focusDelay, () {
          if (mounted) widget.focusNode?.requestFocus();
        });
      }

      // Notify parent when all animations are complete
      widget.onAnimationsComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // If showing all at once, use static Typography instead of TypingText
    if (widget.noAnimation) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Intro text (optional)
          if (widget.introText != null) ...[
            Typography(widget.introText!, variation: widget.introVariation),
            const SizedBox(height: 24),
          ],

          // Title text
          Typography(widget.title, variation: widget.titleVariation),
          const SizedBox(height: 16),

          // Description text (optional)
          if (widget.descriptionText != null) ...[
            Typography(
              widget.descriptionText!,
              variation: widget.descriptionVariation,
            ),
            const SizedBox(height: 16),
          ],

          // Content
          Padding(padding: widget.contentPadding, child: widget.content),
        ],
      );
    }

    // Progressive animation mode
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Intro text (optional) - only show when intro should be visible
        if (widget.introText != null && _showIntro) ...[
          AnimatedOpacity(
            opacity: _introOpacityVisible ? 1.0 : 0.0,
            duration: widget.fadeDuration,
            child: TypingText(
              key: widget.typingKey,
              text: widget.introText!,
              variation: widget.introVariation,
              duration: widget.introDuration,
              onTypingComplete: _onIntroComplete,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Title text - only show when title should be visible
        if (_showTitle) ...[
          AnimatedOpacity(
            opacity: _titleOpacityVisible ? 1.0 : 0.0,
            duration: widget.fadeDuration,
            child: TypingText(
              text: widget.title,
              variation: widget.titleVariation,
              duration: widget.titleDuration,
              onTypingComplete: _onTitleComplete,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Description text (optional) - only show when description should be visible
        if (widget.descriptionText != null && _showDescription) ...[
          AnimatedOpacity(
            opacity: _descriptionOpacityVisible ? 1.0 : 0.0,
            duration: widget.fadeDuration,
            child: TypingText(
              text: widget.descriptionText!,
              variation: widget.descriptionVariation,
              duration: widget.descriptionDuration,
              onTypingComplete: _onDescriptionComplete,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Content with animation - only show when content should be visible
        if (_showContent)
          AnimatedOpacity(
            opacity: _contentOpacityVisible ? 1.0 : 0.0,
            duration: widget.fadeDuration,
            curve: Curves.easeInOut,
            child: Padding(
              padding: widget.contentPadding,
              child: widget.content,
            ),
          ),
      ],
    );
  }
}
