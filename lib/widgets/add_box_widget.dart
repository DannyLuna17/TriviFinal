import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/pages/pages.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/widgets/widgets.dart';

class AddBoxWidget extends StatelessWidget {
  const AddBoxWidget({
    super.key,
    this.buildContext,
  });

  final BuildContext? buildContext;

  @override
  Widget build(BuildContext context) {
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    final providerWith = Provider.of<SharedData>(context);
    return ShrinkWidget(
      shrinkScale: 0.95,
      child: GestureDetector(
        onTap: () {
          if (providerWithout.jwt == "") {
            toastification.show(
              icon: const Icon(
                // info_circle_faw info_circle_faw5s   info_oct
                FlutterIcons.info_oct,
                size: 45,
              ),
              type: ToastificationType.info,
              style: ToastificationStyle.minimal,
              title: Text(
                providerWith.texts != null
                    ? providerWith.texts[providerWith.appLang]["loginAdvice"]
                    : "Loading...",
                style: const TextStyle(fontSize: 15),
              ),
              alignment: Alignment.topCenter,
              autoCloseDuration: const Duration(seconds: 4),
            );
                                        if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

            providerWithout.setCurrentPage(
              ProfilePage(
                buildContext: buildContext ?? context,
              ),
            );
          } else {
                                        if (providerWithout.vibration) Helpers.vibrate(HapticsType.success);

            providerWithout.setUploadedFiles([]);
            PopUps.addPoUp(context);
          }
        },
        child: const GridBoxWidget(
          child: Icon(
            Icons.add_circle_outlined,
            size: 70,
          ),
        ),
      ),
    );
  }
}
