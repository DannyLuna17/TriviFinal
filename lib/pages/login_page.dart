import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/snacks/snacks.dart';
import 'package:trivi_app/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.buildContext});

  final BuildContext buildContext;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variable estática para rastrear si las animaciones ya se han reproducido
  static bool _animationsPlayed = false;
  late bool _showAnimations;

  @override
  void initState() {
    super.initState();
    // Determinar si se deben mostrar las animaciones
    if (!_animationsPlayed) {
      _showAnimations = true;
      _animationsPlayed = true;
    } else {
      _showAnimations = false;
    }
  }

  // Método auxiliar para decidir si envolver con DelayedWidget
  Widget _maybeAnimate({
    required Widget child,
    required DelayedAnimations animation,
    required Duration delay,
  }) {
    if (_showAnimations) {
      return DelayedWidget(
        delayDuration: delay,
        animation: animation,
        child: child,
      );
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AccountWidget(
          buildContext: widget.buildContext,
          maybeAnimate: _maybeAnimate,
        ),
      ),
    );
  }
}

class AccountWidget extends StatelessWidget {
  const AccountWidget({
    super.key,
    required this.buildContext,
    required this.maybeAnimate,
  });

  final BuildContext buildContext;
  final Widget Function({
    required Widget child,
    required DelayedAnimations animation,
    required Duration delay,
  }) maybeAnimate;

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    // Definir una base de duración para los retrasos
    const baseDelay = Duration(milliseconds: 200);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Logo con Animación
          maybeAnimate(
            child: const ShrinkWidget(
              child: SizedBox(
                height: 100,
                child: IntrinsicHeight(
                  child: IntrinsicWidth(
                    child: Image(
                      width: 220,
                      height: 220,
                      image: AssetImage(
                        'assets/logoText.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
            delay: baseDelay,
          ),
          // 2. Botón de Login con Animación
          maybeAnimate(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 175),
              child: CustomButtonWidget(
                label: providerWith.texts != null
                    ? providerWith.texts[providerWith.appLang]["login"]
                    : "Loading...",
                fontColor: providerWith.nightMode
                    ? const Color.fromARGB(255, 189, 182, 182)
                    : Colors.black,
                onTap: () {
                  if (providerWithout.vibration)
                    Helpers.vibrate(HapticsType.success);

                  Provider.of<SharedData>(context, listen: false)
                      .changeSnackShown(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    Snacks.loginAndrRegisterSnackBar(
                        context, true, buildContext),
                  );
                  print('entrando');
                },
              ),
            ),
            animation: DelayedAnimations.SLIDE_FROM_LEFT,
            delay: baseDelay + const Duration(milliseconds: 100),
          ),
          const SizedBox(
            height: 10,
          ),
          // 3. Botón de Register con Animación
          maybeAnimate(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 175),
              child: CustomButtonWidget(
                label: providerWith.texts != null
                    ? providerWith.texts[providerWith.appLang]["register"]
                    : "Loading...",
                backNormal: const Color.fromRGBO(78, 211, 255, 1),
                colorNormal: const Color.fromRGBO(70, 200, 240, 1),
                backPressed: const Color.fromRGBO(78, 211, 255, 1),
                colorPressed: const Color.fromRGBO(78, 211, 255, 1),
                fontColor: providerWith.nightMode ? Colors.black : Colors.white,
                onTap: () {
                  if (providerWithout.vibration)
                    Helpers.vibrate(HapticsType.success);

                  Provider.of<SharedData>(context, listen: false)
                      .changeSnackShown(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    Snacks.loginAndrRegisterSnackBar(
                        context, false, buildContext),
                  );
                },
              ),
            ),
            animation: DelayedAnimations.SLIDE_FROM_RIGHT,
            delay: baseDelay + const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
