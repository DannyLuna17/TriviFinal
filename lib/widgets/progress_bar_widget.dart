import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/providers/shared_data.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    super.key,
  });

  Color _getTextColor(Color backgroundColor) {
    // Calcula el brillo para determinar si usar un color claro u oscuro
    double brightness = (backgroundColor.r * 0.299 +
            backgroundColor.g * 0.587 +
            backgroundColor.b * 0.114) /
        255;
    return brightness < 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    const progressColor = Color.fromRGBO(78, 211, 255, 1);
    final textColor = _getTextColor(progressColor);
    return Expanded(
      child: Stack(
        alignment: Alignment.center, // Centra el contenido dentro del Stack
        children: [
          AnimatedProgressBar(
            progress: providerWith.progressValue,
            progressColor: progressColor,
            backgroundColor: Colors.grey.shade300,
          ),
          // Container(
          //   height: 22.5,
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade300,
          //     borderRadius: BorderRadius.circular(15),
          //   ),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(15),
          //     child: LinearProgressIndicator(
          //       color: progressColor,
          //       backgroundColor: Colors.grey.shade300,
          //       value: providerWith.progressValue,
          //     ),
          //   ),
          // ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedFlipCounter(
                  curve: Curves.bounceOut,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor, // Aplica el color calculado dinámicamente
                  ),
                  value: providerWith.actualQuestion,
                ),
                Text(
                  " / ${providerWithout.nPreg}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor, // Aplica el color calculado dinámicamente
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressBar extends StatefulWidget {
  final double progress; // valor entre 0 y 1
  final Color progressColor;
  final Color backgroundColor;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> {
  double oldProgress = 0.0;

  @override
  void didUpdateWidget(covariant AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualiza el valor anterior solamente cuando cambie el progress
    if (oldWidget.progress != widget.progress) {
      oldProgress = oldWidget.progress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      // El tween va desde oldProgress hasta el widget.progress actual
      tween: Tween<double>(begin: oldProgress, end: widget.progress),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) {
        return Container(
          height: 22.5,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: LinearProgressIndicator(
              color: widget.progressColor,
              backgroundColor: widget.backgroundColor,
              value: value,
            ),
          ),
        );
      },
    );
  }
}
