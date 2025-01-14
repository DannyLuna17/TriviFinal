import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';

class TabWidget extends StatelessWidget {
  const TabWidget(
      {required this.label,
      required this.tabId,
      super.key,
      required this.buildContext});

  final BuildContext buildContext;
  final String label;
  final int tabId;

  @override
  Widget build(BuildContext context) {
    final width = label.length * 15.0;
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    return GestureDetector(
      onTap: () {
                                    if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

        Provider.of<SharedData>(context, listen: false).setDifficulty(tabId);
      },
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: Provider.of<SharedData>(context).nightMode
                ? Colors.white
                : Colors.black,
            width: 1.5,
          ),
          gradient: LinearGradient(
            colors: tabId == Provider.of<SharedData>(context).diffSelected
                ? [
                    const Color.fromRGBO(78, 211, 255, 1),
                    const Color.fromRGBO(2, 168, 224, 1),
                  ]
                : [
                    if (Provider.of<SharedData>(context).nightMode)
                      Colors.black
                    else
                      Colors.white,
                    if (Provider.of<SharedData>(context).nightMode)
                      Colors.black
                    else
                      Colors.white,
                  ],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Center(
            child: Text(
            label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20 + width / 105,
                color: tabId == Provider.of<SharedData>(context).diffSelected
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
