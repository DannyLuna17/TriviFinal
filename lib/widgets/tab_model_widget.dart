import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/screens/premium_screen.dart';

class TabModelWidget extends StatelessWidget {
  const TabModelWidget(
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
        if (tabId == 1 && !providerWithout.isPremium) {
          providerWithout.setSubIndex(0);
          if (providerWithout.vibration) Helpers.vibrate(HapticsType.success);

          // PopUps.premiumPopUp(context);
          // Navigator.pushReplacementNamed(context, "premium");
          if (!kIsWeb) {
            Helpers.getPrices(context);
          }

          final toastification = Toastification();

          toastification.show(
            icon: const Icon(
              // info_circle_faw info_circle_faw5s   info_oct
              FlutterIcons.info_oct,
              size: 22,
            ),
            type: ToastificationType.info,
            style: ToastificationStyle.minimal,
            title: Text(
              providerWithout.texts[providerWithout.appLang]
                  ["premium_subscription_required"],
              style: const TextStyle(fontSize: 12),
            ),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 4),
          );
          Navigator.push(context, MaterialPageRoute(builder: (builderContext) {
            return PremiumScreen(buildContext: context);
          }));
        } else {
          if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

          providerWithout.setModel(tabId);
        }
      },
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: Provider.of<SharedData>(context).nightMode
                ? Colors.white
                : Colors.black,
            width: tabId == Provider.of<SharedData>(context).model ? 2.7 : 1.5,
          ),
          gradient: LinearGradient(
              colors: tabId == 1
                  ? [
                      const Color.fromRGBO(38, 221, 134, 1),
                      const Color.fromRGBO(38, 138, 255, 1),
                      const Color.fromRGBO(234, 89, 255, 1),
                    ]
                  : [
                      // const Color.fromRGBO(78, 211, 255, 1),
                      // const Color.fromRGBO(2, 168, 224, 1),
                      const Color.fromARGB(128, 227, 222, 222),
                      const Color.fromARGB(128, 178, 172, 172),
                    ]),
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
                  color: tabId == 0 ? Colors.black : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
