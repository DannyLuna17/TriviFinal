import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:trivi_app/widgets/widgets.dart';

class UnlimitedLivesWidget extends StatelessWidget {
  const UnlimitedLivesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShrinkWidget(
      child: Row(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(38, 221, 134, 1),
                Color.fromRGBO(38, 138, 255, 1),
                Color.fromRGBO(234, 89, 255, 1),
              ], // Gradient colors for the icon
            ).createShader(bounds),
            child: const Icon(
              FlutterIcons.heart_ant,
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(38, 221, 134, 1),
                Color.fromRGBO(38, 138, 255, 1),
                Color.fromRGBO(234, 89, 255, 1),
              ],
            ).createShader(bounds),
            child: const Icon(
              FlutterIcons.infinity_faw5s,
            ),
          )
        ],
      ),
    );
  }
}
