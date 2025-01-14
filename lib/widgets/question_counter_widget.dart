import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/widgets/shrink_widget.dart';

class QuestionCounterWidget extends StatelessWidget {
  const QuestionCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);

    return ShrinkWidget(
      //
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(240, 241, 246, 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  if (providerWithoutListen.vibration)
                    Helpers.vibrate(HapticsType.selection);

                  providerWithoutListen.setNPreg(
                      providerWithoutListen.nPreg - 1, context);
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "-",
                    style: TextStyle(fontSize: 26),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  top: 3,
                  bottom: 6,
                  right: 25,
                  left: 25,
                ),
                child: AnimatedFlipCounter(
                  curve: Curves.bounceOut,
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Provider.of<SharedData>(context).nPreg,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  if (!providerWithoutListen.isPremium &&
                      providerWithoutListen.nPreg == 10) {
                    // MOSTRA TOAST DICIENDO QUE ES EL LIMITE DE FREE
                    toastification.show(
                      icon: const Icon(
                        Icons.error_outline_outlined,
                        size: 35,
                      ),
                      type: ToastificationType.error,
                      style: ToastificationStyle.minimal,
                      title: Text(
                        providerWithoutListen
                                .texts[providerWithoutListen.appLang]
                            ["free_plan_question_limit"],
                        style: const TextStyle(fontSize: 10),
                      ),
                      alignment: Alignment.topCenter,
                      autoCloseDuration: const Duration(seconds: 4),
                    );
                    // TODO: MOSTRAR EL POPUP DE PREMIUM MEJORADO CON NUEVOS BEENEFICIOS ACA JUNTO CON EL TOAST
                    PopUps.premiumPopUp(context);
                  } else if (providerWithoutListen.isPremium &&
                      providerWithoutListen.nPreg == 100) {
                    toastification.show(
                      icon: const Icon(
                        Icons.error_outline_outlined,
                        size: 35,
                      ),
                      type: ToastificationType.error,
                      style: ToastificationStyle.minimal,
                      title: Text(
                        providerWithoutListen
                                .texts[providerWithoutListen.appLang]
                            ["premium_question_limit"],
                        style: const TextStyle(fontSize: 10),
                      ),
                      alignment: Alignment.topCenter,
                      autoCloseDuration: const Duration(seconds: 4),
                    );
                  } else {
                    if (providerWithoutListen.vibration)
                      Helpers.vibrate(HapticsType.selection);

                    providerWithoutListen.setNPreg(
                        providerWithoutListen.nPreg + 1, context);
                  }
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "+",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
