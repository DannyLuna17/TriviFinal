import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({
    super.key,
    this.onTap,
  });

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    return GestureDetector(
      onTap: () {
                                    if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

        onTap!() ?? Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: const Icon(
          Icons.close_outlined,
          size: 45,
          color: Color.fromRGBO(195, 195, 195, 1),
        ),
      ),
    );
  }
}
