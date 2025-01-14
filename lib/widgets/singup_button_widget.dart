import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/snacks/snacks.dart';
import 'package:trivi_app/widgets/widgets.dart';

class SingupButtonWidget extends StatelessWidget {
  const SingupButtonWidget(
    {
    super.key,
    required this.buildContext,
  });

  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    return CustomButtonWidget(
      label: providerWith.texts != null ? providerWith.texts[providerWith.appLang]["register"] : "Loading...",
      backNormal: const Color.fromRGBO(78, 211, 255, 1),
      colorNormal: const Color.fromRGBO(70, 200, 240, 1),
      backPressed: const Color.fromRGBO(78, 211, 255, 1),
      colorPressed: const Color.fromRGBO(78, 211, 255, 1),
      fontColor: Provider.of<SharedData>(context, listen: false).nightMode
          ? Colors.black
          : Colors.white,
      onTap: () {
                                    if (providerWithout.vibration) Helpers.vibrate(HapticsType.success);

        Navigator.pop(context);

        Provider.of<SharedData>(context, listen: false).changeSnackShown(true);
        ScaffoldMessenger.of(context).showSnackBar(
          Snacks.loginAndrRegisterSnackBar(context, false, buildContext),
        );
      },
    );
  }
}
