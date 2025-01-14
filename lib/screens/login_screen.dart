import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.buildContext});

  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: DelayedWidget(
                delayDuration: const Duration(milliseconds: 200),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const Align(
                          child: Icon(
                            Icons.account_circle,
                            size: 200,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 65),
                            margin: const EdgeInsets.only(right: 15, top: 10),
                            child: CustomButtonWidget(
                              child: const Icon(FlutterIcons.moon_ent),
                              onTap: () {
                                if (providerWithout.vibration)
                                  Helpers.vibrate(HapticsType.selection);

                                Provider.of<SharedData>(context, listen: false)
                                    .toggleNightMode();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      providerWith.texts != null
                          ? providerWith.texts[providerWith.appLang]
                              ["challengeWithTriviApp"]
                          : "Loading...",
                    ),
                    Expanded(child: Container()),
                    Shimmer(
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        child: SingupButtonWidget(buildContext: buildContext),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 25,
                        left: 15,
                        right: 15,
                      ),
                      child: LoginButtonWidget(buildContext: buildContext),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
