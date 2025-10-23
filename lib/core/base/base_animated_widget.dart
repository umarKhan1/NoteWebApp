import 'package:flutter/material.dart';
import '../constants/app_animations.dart';

/// Base class for animated widgets following OOP principles.
abstract class BaseAnimatedWidget extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;
  
  /// Animation duration.
  final Duration duration;
  
  /// Animation curve.
  final Curve curve;
  
  /// Delay before starting animation.
  final Duration delay;
  
  /// Whether to auto-start the animation.
  final bool autoStart;
  
  const BaseAnimatedWidget({
    super.key,
    required this.child,
    this.duration = AppAnimations.normal,
    this.curve = AppAnimations.easeInOut,
    this.delay = Duration.zero,
    this.autoStart = true,
  });
}

/// Base state class for animated widgets.
abstract class BaseAnimatedWidgetState<T extends BaseAnimatedWidget> 
    extends State<T> with SingleTickerProviderStateMixin {
  
  /// Animation controller.
  late AnimationController controller;
  
  /// Animation instance.
  late Animation<double> animation;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    
    if (widget.autoStart) {
      _startAnimation();
    }
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  /// Initialize the animation controller and animation.
  void _initializeAnimation() {
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    animation = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    );
    
    setupCustomAnimations();
  }
  
  /// Start the animation with optional delay.
  void _startAnimation() {
    if (widget.delay.inMilliseconds > 0) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          controller.forward();
        }
      });
    } else {
      controller.forward();
    }
  }
  
  /// Setup custom animations in child classes.
  void setupCustomAnimations() {}
  
  /// Start animation manually.
  void startAnimation() => _startAnimation();
  
  /// Reset animation.
  void resetAnimation() => controller.reset();
  
  /// Reverse animation.
  void reverseAnimation() => controller.reverse();
}
