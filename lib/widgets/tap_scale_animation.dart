import 'package:flutter/material.dart';

class TapScaleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Function onTap;

  const TapScaleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    required this.onTap,
  });

  @override
  _TapScaleAnimationState createState() => _TapScaleAnimationState();
}

class _TapScaleAnimationState extends State<TapScaleAnimation>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
