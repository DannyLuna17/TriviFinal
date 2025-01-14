import 'package:badges/badges.dart' as badges;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/pages/profile_page.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/screens/premium_screen.dart';
import 'package:trivi_app/widgets/unlimited_lives_widget.dart';
import 'package:trivi_app/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.buildContext});

  final BuildContext? buildContext;

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static bool _animationsPlayed = false;
  late bool _showAnimations;

  @override
  void initState() {
    super.initState();
    if (!_animationsPlayed) {
      _showAnimations = true;
      _animationsPlayed = true;
    } else {
      _showAnimations = false;
    }
  }

  Widget _animatedBox({
    required Widget child,
    required int index,
    required Duration baseDelay,
  }) {
    if (_showAnimations) {
      return AnimatedScaleBox(
        delay: baseDelay + Duration(milliseconds: 150 * index),
        duration: const Duration(milliseconds: 400),
        child: child,
      );
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    if (providerWithout.realTopicsBoxes.length == 1 &&
        !providerWithout.isGetting &&
        providerWithout.jwt != "") {
      Helpers.getUserInfo(context);
    }

    final defaultTopics = [
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_programacion_python"],
        '🐍'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_ingles_conversacional"],
        '🗣️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_anime_y_manga"],
        '🍣'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_historia_tecnologia"],
        '💡'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_fisica_cuantica"],
        '🔬'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_desarrollo_web"],
        '🌐'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_marketing_digital"],
        '📈'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_biologia_celular"],
        '🧬'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_algebra_lineal"],
        '📐'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_quimica_organica"],
        '⚗️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_historia_videojuegos"],
        '🕹️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_diseno_grafico"],
        '🎨'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_economia_principiantes"],
        '💰'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_historia_arte"],
        '🖼️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_literatura_latinoamericana"],
        '📖'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_redaccion_escritura"],
        '✍️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_matematicas_financieras"],
        '💹'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_inteligencia_artificial"],
        '🤖'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_gestion_proyectos"],
        '📋'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_fotografia_digital"],
        '📷'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_ciberseguridad"],
        '🔒'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_psicologia_basica"],
        '🧠'
      ],
    ];

    if (providerWithout.jwt == "") {
      providerWithout.setTopics([
        AddBoxWidget(
          buildContext: widget.buildContext,
        ),
        for (List defaultTopic in defaultTopics)
          SubjectBoxWidget(
            topicName: defaultTopic[0],
            emoji: defaultTopic[1],
            instrucciones: '',
            language: providerWithout.appLang,
            filename: "",
            buildContext: context,
          )
      ]);
    }

    const baseDelay = Duration(milliseconds: 200);

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.55,
                1,
              ],
              colors: [
                Color.fromRGBO(157, 231, 255, 1),
                Color.fromRGBO(105, 182, 208, 1),
              ],
            ),
          ),
        ),
        SafeArea(
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: const Color.fromRGBO(78, 211, 255, 1),
            strokeWidth: 4,
            onRefresh: () async {
              if (!providerWithout.isGetting && providerWithout.jwt != "") {
                await Helpers.getUserInfo(context);
              }
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShrinkWidget(
                          child: Row(
                            children: [
                              const Icon(
                                FlutterIcons.fire_alt_faw5s,
                                color: Color.fromRGBO(255, 150, 0, 1),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                Provider.of<SharedData>(context)
                                    .streak
                                    .toString(),
                                style: const TextStyle(
                                  color: Color.fromRGBO(255, 150, 0, 1),
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ShrinkWidget(
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(
                                FlutterIcons.star_ant,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                Provider.of<SharedData>(context)
                                    .stars
                                    .toString(),
                                style: const TextStyle(
                                  color: Color.fromRGBO(255, 170, 52, 1),
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        providerWith.isPremium
                            ? const UnlimitedLivesWidget()
                            : ShrinkWidget(
                                onPressed: () {
                                  if (providerWithout.vibration)
                                    Helpers.vibrate(HapticsType.success);

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
                                            ? providerWith
                                                    .texts[providerWith.appLang]
                                                ["loginAdvice"]
                                            : "Loading...",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      alignment: Alignment.topCenter,
                                      autoCloseDuration:
                                          const Duration(seconds: 4),
                                    );
                                    if (providerWithout.vibration)
                                      Helpers.vibrate(HapticsType.selection);

                                    providerWithout.setCurrentPage(
                                      ProfilePage(
                                        buildContext: context,
                                      ),
                                    );
                                  } else {
                                    PopUps.livesPopup(context);
                                  }
                                },
                                child: badges.Badge(
                                  badgeAnimation:
                                      const badges.BadgeAnimation.rotation(
                                    animationDuration: Duration(seconds: 2),
                                    colorChangeAnimationDuration:
                                        Duration(seconds: 1),
                                    loopAnimation: true,
                                    curve: Curves.fastOutSlowIn,
                                    colorChangeAnimationCurve:
                                        Curves.easeInCubic,
                                  ),
                                  showBadge: providerWith.lives < 5,
                                  badgeContent: const Text(
                                    '1',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      const Icon(
                                        FlutterIcons.heart_ant,
                                        color: Color.fromRGBO(255, 75, 75, 1),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        providerWith.lives.toString(),
                                        style: const TextStyle(
                                          color: Color.fromRGBO(255, 75, 75, 1),
                                          fontSize: 25,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ShrinkWidget(
                          onPressed: () {
                            if (providerWithout.vibration)
                              Helpers.vibrate(HapticsType.success);

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
                                      ? providerWith.texts[providerWith.appLang]
                                          ["loginAdvice"]
                                      : "Loading...",
                                  style: const TextStyle(fontSize: 15),
                                ),
                                alignment: Alignment.topCenter,
                                autoCloseDuration: const Duration(seconds: 4),
                              );
                              if (providerWithout.vibration)
                                Helpers.vibrate(HapticsType.selection);

                              providerWithout.setCurrentPage(
                                ProfilePage(
                                  buildContext: context,
                                ),
                              );
                            } else {
                              if (!kIsWeb) {
                                Helpers.getPrices(context);
                              }
                              Provider.of<SharedData>(context, listen: false)
                                  .setSubIndex(0);

                              Navigator.of(context)
                                  .push(Helpers.createRoute(PremiumScreen(
                                buildContext: widget.buildContext ?? context,
                              )));
                            }
                          },
                          child: const PremiumWidget(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Animación de cajas
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      children: providerWith.realTopicsBoxes
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final widget = entry.value;
                        if (widget is AddBoxWidget) return widget;
                        return _animatedBox(
                          child: widget,
                          index: index,
                          baseDelay: baseDelay,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedScaleBox extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedScaleBox({
    super.key,
    required this.child,
    required this.delay,
    required this.duration,
  });

  @override
  State<AnimatedScaleBox> createState() => _AnimatedScaleBoxState();
}

class _AnimatedScaleBoxState extends State<AnimatedScaleBox> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      setState(() {
        _visible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _visible ? 1.0 : 0.0,
      duration: widget.duration,
      curve: Curves.easeOut,
      child: widget.child,
    );
  }
}
