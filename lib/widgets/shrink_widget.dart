import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';

class ShrinkWidget extends StatefulWidget {
  const ShrinkWidget({
    required this.child,
    super.key,
    this.onPressed,
    this.shrinkScale = 0.9,
  });
  final Widget child;
  final Function? onPressed;
  final double shrinkScale;

  @override
  ShrinkWidgetState createState() => ShrinkWidgetState();
}

class ShrinkWidgetState extends State<ShrinkWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 25),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Function onPressed;

    widget.onPressed ?? () {};

    widget.onPressed == null
        ? onPressed = () {}
        : onPressed = widget.onPressed!;
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    return GestureDetector(
      onTap: () {
                                    if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

        _controller.forward();
        Future.delayed(const Duration(milliseconds: 100), () {
          _controller.reverse();
        });
        onPressed();
      },
      onTapDown: (details) => _controller.forward(),
      onTapUp: (details) {
        _controller.reverse();
      },
      onPanStart: (details) => _controller.forward(),
      onPanDown: (details) => _controller.forward(),
      onPanCancel: () => _controller.reverse(),
      onPanEnd: (d) => _controller.reverse(),
      // onPanDown: (details) => _controller.forward(),
      // onPanEnd: (details) => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1,
          end: widget.shrinkScale,
        ).animate(_controller),
        child: widget.child,
      ),
    );
  }
}
