import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/snacks/snacks.dart';
import 'package:trivi_app/widgets/widgets.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    super.key,
    required this.buildContext
  });

  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    return CustomButtonWidget(
      label: Provider.of<SharedData>(context)
          .texts[Provider.of<SharedData>(context).appLang]["login"],
      fontColor: Provider.of<SharedData>(context).nightMode
          ? const Color.fromARGB(255, 189, 182, 182)
          : Colors.black,
      onTap: () {
                                    if (providerWithout.vibration) Helpers.vibrate(HapticsType.success);

        Navigator.pop(context);
        Provider.of<SharedData>(context, listen: false).changeSnackShown(true);
        ScaffoldMessenger.of(context).showSnackBar(
          Snacks.loginAndrRegisterSnackBar(context, true, buildContext),
        );
        print('entrando');
      },
    );
  }
}
