import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/screens/screens.dart';
import 'package:trivi_app/snacks/snacks.dart';
import 'package:trivi_app/widgets/widgets.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
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
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    final providerWith = Provider.of<SharedData>(context);

    // Añadir temas por defecto si es necesario
    if (providerWithout.topicsBoxes.length == 1 ||
        providerWithout.realTopicsBoxes.length == 1) {
      Helpers.addDefaultTopics(context);
    }

    // Definir una base de duración para los retrasos
    const baseDelay = Duration(milliseconds: 200);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. Título de Configuración: SLIDE_FROM_TOP
              _maybeAnimate(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    providerWith.texts != null
                        ? providerWith.texts[providerWith.appLang]["settings"]
                        : "Loading...",
                    style: const TextStyle(
                      fontSize: 25.5,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
                animation: DelayedAnimations.SLIDE_FROM_TOP,
                delay: baseDelay,
              ),

              const Divider(
                thickness: 2,
              ),

              // 2. Contenedor de Configuración: SLIDE_FROM_LEFT
              _maybeAnimate(
                child: Container(
                  margin: const EdgeInsets.all(12.5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: providerWith.nightMode
                            ? const Color.fromARGB(255, 48, 46, 46)
                            : const Color.fromARGB(255, 239, 236, 236),
                        width: 3,
                      ),
                      vertical: BorderSide(
                        color: providerWith.nightMode
                            ? const Color.fromARGB(255, 48, 46, 46)
                            : const Color.fromARGB(255, 239, 236, 236),
                        width: 5,
                      ),
                    ),
                    color: providerWith.nightMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Subtítulo dentro del contenedor
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                              providerWith.texts != null
                                  ? providerWith.texts[providerWith.appLang]
                                      ["settings"]
                                  : "Loading...",
                              style: const TextStyle(
                                fontSize: 17.5,
                                fontFamily: 'Fredoka',
                                color: Color.fromRGBO(206, 206, 206, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                      ),

                      // 3. Elemento de Configuración: SLIDE_FROM_LEFT
                      _maybeAnimate(
                        child: _SettingsItemWidget(
                          title: providerWith.texts != null
                              ? providerWith.texts[providerWith.appLang]
                                  ["darkMode"]
                              : "Loading...",
                          status: providerWith.nightMode,
                          onChanged: (value) {
                            if (providerWithout.vibration)
                              Helpers.vibrate(HapticsType.selection);

                            providerWithout.toggleNightMode();
                            Hive.box<bool>("nightBox")
                                .put("night", providerWithout.nightMode);
                          },
                        ),
                        animation: DelayedAnimations.SLIDE_FROM_LEFT,
                        delay: baseDelay + const Duration(milliseconds: 200),
                      ),

                      const Divider(
                        thickness: 2,
                      ),

                      // 4. Elemento de Configuración: SLIDE_FROM_RIGHT
                      _maybeAnimate(
                        child: _SettingsItemWidget(
                          title: providerWith.texts != null
                              ? providerWith.texts[providerWith.appLang]
                                  ["soundEffects"]
                              : "Loading...",
                          status: providerWith.sound,
                          onChanged: (value) {
                            if (providerWithout.vibration)
                              Helpers.vibrate(HapticsType.selection);

                            providerWithout.setSound(!providerWithout.sound);
                            Hive.box<bool>("soundBox")
                                .put("sound", providerWithout.sound);
                          },
                        ),
                        animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                        delay: baseDelay + const Duration(milliseconds: 300),
                      ),

                      const Divider(
                        thickness: 2,
                      ),

                      // 5. Elemento de Configuración: SLIDE_FROM_LEFT
                      _maybeAnimate(
                        child: _SettingsItemWidget(
                          title: providerWith.texts != null
                              ? providerWith.texts[providerWith.appLang]
                                  ["vibration"]
                              : "Loading...",
                          status: providerWith.vibration,
                          onChanged: (value) {
                            if (providerWithout.vibration)
                              Helpers.vibrate(HapticsType.selection);

                            providerWithout
                                .setVibration(!providerWithout.vibration);
                            Hive.box<bool>("vibrationBox")
                                .put("vibration", providerWithout.vibration);
                          },
                        ),
                        animation: DelayedAnimations.SLIDE_FROM_LEFT,
                        delay: baseDelay + const Duration(milliseconds: 400),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomButtonWidget(
                        expandible: false,
                        fontColor: Provider.of<SharedData>(context).nightMode
                            ? const Color.fromARGB(255, 189, 182, 182)
                            : Colors.black,
                        onTap: () {
                          if (providerWithout.vibration)
                            Helpers.vibrate(HapticsType.success);

                          Navigator.of(context).push(Helpers.createRoute(
                              const LanguageScreen(),
                              begin: const Offset(0, 1),
                              end: const Offset(0, 0)));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text.rich(
                            TextSpan(
                                text: providerWith.texts[providerWith.appLang]
                                    ["language"],
                                style: const TextStyle(
                                    fontSize: 24.5,
                                    color: Color.fromRGBO(86, 85, 85, 1)),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.top,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 7.5),
                                      child: SvgPicture.asset(
                                        "assets/${providerWithout.appLang}.svg",
                                        width: 27,
                                        height: 34,
                                        semanticsLabel: 'Language Logo',
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                animation: DelayedAnimations.SLIDE_FROM_LEFT,
                delay: baseDelay + const Duration(milliseconds: 100),
              ),

              // 6. Botones de Logout/Login/Register: SLIDE_FROM_BOTTOM
              _maybeAnimate(
                child: providerWith.jwt != ""
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 50,
                        ),
                        child: CustomButtonWidget(
                          fontColor: providerWith.nightMode
                              ? const Color.fromARGB(255, 225, 220, 220)
                              : const Color.fromARGB(255, 150, 145, 145),
                          label: providerWith.texts != null
                              ? providerWith.texts[providerWith.appLang]
                                  ["logout"]
                              : "Loading...",
                          onTap: () {
                            if (providerWithout.vibration)
                              Helpers.vibrate(HapticsType.success);

                            providerWithout.setJwt("");
                            Hive.box<String>("jwtBox").put("jwt", "");
                          },
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 7. Botón de Login: SLIDE_FROM_BOTTOM
                          _maybeAnimate(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 175),
                              child: CustomButtonWidget(
                                label: providerWith.texts != null
                                    ? providerWith.texts[providerWith.appLang]
                                        ["login"]
                                    : "Loading...",
                                fontColor: providerWith.nightMode
                                    ? const Color.fromARGB(255, 189, 182, 182)
                                    : Colors.black,
                                onTap: () {
                                  if (providerWithout.vibration)
                                    Helpers.vibrate(HapticsType.success);

                                  providerWithout.changeSnackShown(true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    Snacks.loginAndrRegisterSnackBar(
                                        context, true, context),
                                  );
                                },
                              ),
                            ),
                            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                            delay:
                                baseDelay + const Duration(milliseconds: 200),
                          ),

                          const SizedBox(height: 10),

                          // 8. Botón de Register: SLIDE_FROM_BOTTOM
                          _maybeAnimate(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 175),
                              child: CustomButtonWidget(
                                label: providerWith.texts != null
                                    ? providerWith.texts[providerWith.appLang]
                                        ["register"]
                                    : "Loading...",
                                backNormal:
                                    const Color.fromRGBO(78, 211, 255, 1),
                                colorNormal:
                                    const Color.fromRGBO(70, 200, 240, 1),
                                backPressed:
                                    const Color.fromRGBO(78, 211, 255, 1),
                                colorPressed:
                                    const Color.fromRGBO(78, 211, 255, 1),
                                fontColor: providerWith.nightMode
                                    ? Colors.black
                                    : Colors.white,
                                onTap: () {
                                  if (providerWithout.vibration)
                                    Helpers.vibrate(HapticsType.success);

                                  providerWithout.changeSnackShown(true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    Snacks.loginAndrRegisterSnackBar(
                                        context, false, context),
                                  );
                                },
                              ),
                            ),
                            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                            delay:
                                baseDelay + const Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                delay: baseDelay + const Duration(milliseconds: 400),
              ),

              const SizedBox(height: 5),

              // 9. Texto de Agradecimientos: SLIDE_FROM_BOTTOM
              _maybeAnimate(
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        providerWith.texts != null
                            ? providerWith.texts[providerWith.appLang]
                                ["acknowledgments"]
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(100, 216, 255, 1),
                        ),
                      ),
                    ),
                  ],
                ),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                delay: baseDelay + const Duration(milliseconds: 800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsItemWidget extends StatelessWidget {
  const _SettingsItemWidget({
    required this.title,
    required this.status,
    required this.onChanged,
  });

  final String title;
  final bool status;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'FredokaRegular',
              color: Provider.of<SharedData>(context).nightMode
                  ? const Color.fromARGB(255, 219, 215, 215)
                  : Colors.black,
            ),
          ),
        ),
        Switch.adaptive(
          activeColor: const Color.fromRGBO(100, 216, 255, 1),
          value: status,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
