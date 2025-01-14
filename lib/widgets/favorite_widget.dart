import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({
    super.key,
  });

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    return GestureDetector(
      onTap: () {
                                    if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

        setState(() {
          isEnabled = !isEnabled;
        });
      },
      child: Icon(
        isEnabled ? FlutterIcons.heart_faw : FlutterIcons.heart_faw5,
        size: 25,
        color: const Color.fromRGBO(78, 211, 255, 1),
      ),
    );
  }
}
