import 'package:flutter/material.dart';
import '../../../core/base/base_animated_widget.dart';
import '../../../core/constants/app_animations.dart';

/// Fade in animation widget.
class FadeInAnimation extends BaseAnimatedWidget {
  /// Creates a [FadeInAnimation]
  const FadeInAnimation({
    super.key,
    required super.child,
    super.duration = AppAnimations.normal,
    super.curve = AppAnimations.easeInOut,
    super.delay = Duration.zero,
    super.autoStart = true,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends BaseAnimatedWidgetState<FadeInAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(opacity: animation.value, child: widget.child);
      },
    );
  }
}

/// Slide in animation widget.
class SlideInAnimation extends BaseAnimatedWidget {
  /// Creates a [SlideInAnimation]
  const SlideInAnimation({
    super.key,
    required super.child,
    this.offsetFrom = AppAnimations.slideFromBottom,
    super.duration = AppAnimations.normal,
    super.curve = AppAnimations.easeInOut,
    super.delay = Duration.zero,
    super.autoStart = true,
  });

  /// The offset to slide from.
  final Offset offsetFrom;

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends BaseAnimatedWidgetState<SlideInAnimation> {
  late Animation<Offset> slideAnimation;

  @override
  void setupCustomAnimations() {
    slideAnimation = Tween<Offset>(
      begin: widget.offsetFrom,
      end: Offset.zero,
    ).animate(animation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return SlideTransition(position: slideAnimation, child: widget.child);
      },
    );
  }
}

/// Scale in animation widget.
class ScaleInAnimation extends BaseAnimatedWidget {
  /// Creates a [ScaleInAnimation]
  const ScaleInAnimation({
    super.key,
    required super.child,
    this.scaleFrom = AppAnimations.scaleFrom,
    super.duration = AppAnimations.normal,
    super.curve = AppAnimations.easeInOut,
    super.delay = Duration.zero,
    super.autoStart = true,
  });

  /// The scale to start from.
  final double scaleFrom;

  @override
  State<ScaleInAnimation> createState() => _ScaleInAnimationState();
}

class _ScaleInAnimationState extends BaseAnimatedWidgetState<ScaleInAnimation> {
  late Animation<double> scaleAnimation;

  @override
  void setupCustomAnimations() {
    scaleAnimation = Tween<double>(
      begin: widget.scaleFrom,
      end: AppAnimations.scaleTo,
    ).animate(animation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Combined fade and slide animation widget.
class FadeSlideInAnimation extends BaseAnimatedWidget {
  /// Creates a [FadeSlideInAnimation]
  const FadeSlideInAnimation({
    super.key,
    required super.child,
    this.offsetFrom = AppAnimations.slideFromBottom,
    super.duration = AppAnimations.normal,
    super.curve = AppAnimations.easeInOut,
    super.delay = Duration.zero,
    super.autoStart = true,
  });

  /// The offset to slide from.
  final Offset offsetFrom;

  @override
  State<FadeSlideInAnimation> createState() => _FadeSlideInAnimationState();
}

class _FadeSlideInAnimationState
    extends BaseAnimatedWidgetState<FadeSlideInAnimation> {
  late Animation<Offset> slideAnimation;

  @override
  void setupCustomAnimations() {
    slideAnimation = Tween<Offset>(
      begin: widget.offsetFrom,
      end: Offset.zero,
    ).animate(animation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: SlideTransition(position: slideAnimation, child: widget.child),
        );
      },
    );
  }
}

/// Staggered list animation widget.
class StaggeredListAnimation extends StatelessWidget {
  /// Creates a [StaggeredListAnimation]
  const StaggeredListAnimation({
    super.key,
    required this.children,
    this.staggerDelay = AppAnimations.mediumStagger,
    this.duration = AppAnimations.normal,
    this.curve = AppAnimations.easeInOut,
    this.initialDelay = Duration.zero,
  });

  /// List of children to animate.
  final List<Widget> children;

  /// Stagger delay between each child.
  final Duration staggerDelay;

  /// Animation duration for each child.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Initial delay before starting animations.
  final Duration initialDelay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        final delay = initialDelay + (staggerDelay * index);

        return FadeSlideInAnimation(
          delay: delay,
          duration: duration,
          curve: curve,
          child: child,
        );
      }).toList(),
    );
  }
}
