import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';

class NumPregWidget extends StatelessWidget {
  const NumPregWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: const Icon(
            Icons.remove_circle_outline_sharp,
            size: 30,
          ),
          onTap: () {
                                        if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

            Provider.of<SharedData>(context, listen: false).setNPreg(
                Provider.of<SharedData>(context, listen: false).nPreg - 1,
                context);
          },
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          Provider.of<SharedData>(context).nPreg.toString(),
          style: const TextStyle(fontSize: 35),
        ),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          child: const Icon(
            Icons.add_circle_outline_outlined,
            size: 30,
          ),
          onTap: () {
                                        if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

            Provider.of<SharedData>(context, listen: false).setNPreg(
                Provider.of<SharedData>(context, listen: false).nPreg + 1,
                context);
          },
        ),
      ],
    );
  }
}
