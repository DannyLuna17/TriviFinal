import 'dart:convert';
import 'dart:math';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/animations/animations.dart';
import 'package:trivi_app/helpers/gradient_text.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/screens/loading_screen.dart';
import 'package:trivi_app/screens/main_screen.dart';
import 'package:trivi_app/screens/premium_screen.dart';
import 'package:trivi_app/snacks/snacks.dart';
import 'package:trivi_app/widgets/custom_box_widget.dart';
import 'package:trivi_app/widgets/file_uploaded_widget.dart';
import 'package:trivi_app/widgets/question_counter_widget.dart';
import 'package:trivi_app/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class PopUps {
  static Future<void> loadingPopUp(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context, listen: false);

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (builderContext) => Dialog(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: DelayedWidget(
          delayDuration: const Duration(milliseconds: 200),
          animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: Color.fromRGBO(78, 211, 255, 1),
                    strokeWidth: 8.5,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    providerWith.texts[providerWith.appLang]["loading"],
                    style: TextStyle(
                      fontSize: 23,
                      color:
                          providerWith.nightMode ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void loginPoUp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (builderContext) {
        final providerWith = Provider.of<SharedData>(context, listen: false);
        final providerWithout = Provider.of<SharedData>(context, listen: false);
        return Dialog(
          child: DelayedWidget(
            delayDuration: const Duration(milliseconds: 200),
            animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: providerWith.nightMode
                        ? const Color.fromARGB(255, 48, 46, 46)
                        : const Color.fromARGB(255, 239, 236, 236),
                    width: 5,
                  ),
                  vertical: BorderSide(
                    color: providerWith.nightMode
                        ? const Color.fromARGB(255, 48, 46, 46)
                        : const Color.fromARGB(255, 239, 236, 236),
                    width: 3,
                  ),
                ),
                color: providerWith.nightMode ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: IntrinsicWidth(
                  child: IntrinsicHeight(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botones
                          CustomButtonWidget(
                            label: providerWith.texts[providerWith.appLang]
                                ["login"],
                            fontColor: providerWith.nightMode
                                ? const Color.fromARGB(255, 189, 182, 182)
                                : Colors.black,
                            onTap: () {
                              if (providerWithout.vibration)
                                Helpers.vibrate(HapticsType.success);

                              Navigator.pop(context);
                              providerWith.changeSnackShown(true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                Snacks.loginAndrRegisterSnackBar(
                                    context, true, context),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomButtonWidget(
                            label: providerWith.texts[providerWith.appLang]
                                ["register"],
                            backNormal: const Color.fromRGBO(78, 211, 255, 1),
                            colorNormal: const Color.fromRGBO(70, 200, 240, 1),
                            backPressed: const Color.fromRGBO(78, 211, 255, 1),
                            colorPressed: const Color.fromRGBO(78, 211, 255, 1),
                            fontColor: providerWith.nightMode
                                ? Colors.black
                                : Colors.white,
                            onTap: () {
                              if (providerWithout.vibration)
                                Helpers.vibrate(HapticsType.success);

                              Navigator.pop(context);
                              providerWith.changeSnackShown(true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                Snacks.loginAndrRegisterSnackBar(
                                    context, false, context),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void topicPoUp(BuildContext context) {
    Provider.of<SharedData>(context, listen: false).setDifficulty(0);
    showDialog<void>(
      builder: (builderContext) {
        final providerWithout =
            Provider.of<SharedData>(builderContext, listen: false);

        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Provider.of<SharedData>(builderContext, listen: false)
                          .nightMode
                      ? const Color.fromARGB(255, 48, 46, 46)
                      : const Color.fromARGB(255, 239, 236, 236),
                  width: 5,
                ),
                vertical: BorderSide(
                  color: Provider.of<SharedData>(builderContext, listen: false)
                          .nightMode
                      ? const Color.fromARGB(255, 48, 46, 46)
                      : const Color.fromARGB(255, 239, 236, 236),
                  width: 3,
                ),
              ),
              color: Provider.of<SharedData>(builderContext, listen: false)
                      .nightMode
                  ? Colors.black
                  : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    providerWithout.texts[providerWithout.appLang]
                        ["difficulty"],
                    style: const TextStyle(fontSize: 35),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      ShrinkWidget(
                        shrinkScale: 0.96,
                        child: TabWidget(
                          label: providerWithout.texts[providerWithout.appLang]
                              ["beginner"],
                          tabId: 0,
                          buildContext: builderContext,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ShrinkWidget(
                        shrinkScale: 0.96,
                        child: TabWidget(
                          label: providerWithout.texts[providerWithout.appLang]
                              ["intermediate"],
                          buildContext: builderContext,
                          tabId: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ShrinkWidget(
                        shrinkScale: 0.96,
                        child: TabWidget(
                          label: providerWithout.texts[providerWithout.appLang]
                              ["advanced"],
                          buildContext: builderContext,
                          tabId: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    providerWithout.texts[providerWithout.appLang]
                        ["numQuestions"],
                    style: const TextStyle(fontSize: 25),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        const QuestionCounterWidget(),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomPopup(
                          arrowColor: const Color.fromRGBO(38, 138, 255, 1),
                          barrierColor: Colors.transparent,
                          contentDecoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.5)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(38, 138, 255, 1),
                                Color.fromRGBO(234, 89, 255, 1),
                              ],
                            ),
                          ),
                          content: SizedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        providerWithout
                                                .texts[providerWithout.appLang]
                                            ["upTo100QuestionsWithPremiumPlan"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: GestureDetector(
                            child: const GradientText("✨",
                                style: TextStyle(fontSize: 22.5),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(38, 221, 134, 1),
                                    Color.fromRGBO(38, 138, 255, 1),
                                    Color.fromRGBO(234, 89, 255, 1),
                                  ], // Gradient colors for the icon
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    providerWithout.texts[providerWithout.appLang]["iaModel"],
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ShrinkWidget(
                      shrinkScale: 0.96,
                      child: TabModelWidget(
                        label: providerWithout.texts[providerWithout.appLang]
                            ["standard"],
                        tabId: 0,
                        buildContext: context,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ShrinkWidget(
                      shrinkScale: 0.96,
                      child: TabModelWidget(
                        label: providerWithout.texts[providerWithout.appLang]
                            ["advanced"],
                        tabId: 1,
                        buildContext: context,
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButtonWidget(
                    fontColor:
                        Provider.of<SharedData>(builderContext, listen: false)
                                .nightMode
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : const Color.fromARGB(255, 0, 0, 0),
                    onTap: () {
                      if (providerWithout.vibration)
                        Helpers.vibrate(HapticsType.success);

                      Provider.of<SharedData>(builderContext, listen: false)
                          .setLoaded(false);
                      Provider.of<SharedData>(builderContext, listen: false)
                          .setLoading(false);
                      Provider.of<SharedData>(builderContext, listen: false)
                          .setAttempts(0);

                      Provider.of<SharedData>(builderContext, listen: false)
                          .setProgress(
                        0.1 /
                            Provider.of<SharedData>(builderContext,
                                    listen: false)
                                .nPreg,
                      );
                      Navigator.of(builderContext).push(Helpers.createRoute(
                          LoadingScreen(buildContext: builderContext)));
                    },
                    label: providerWithout.texts[providerWithout.appLang]
                        ["continue"],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

  static void livesPopup(BuildContext context) {
    Helpers.getUserInfo(context);
    showDialog<void>(
      builder: (builderContext) {
        final providerWithout = Provider.of<SharedData>(context, listen: false);
        final providerWith = Provider.of<SharedData>(context, listen: false);
        // final providerWith = Provider.of<SharedData>(context, listen: false);

        // final providerWith = Provider.of<SharedData>(context, listen: false);

        final stopWatchTimer = StopWatchTimer(
          mode: StopWatchMode.countDown,
          onChange: (value) {
            if (value == 0 && providerWithout.lives < 5) {
              Helpers.getUserInfo(context);
            }
          },
        );
        // ignore: cascade_invocations
        stopWatchTimer
          ..setPresetTime(
            mSec: (const Duration(minutes: 30) -
                    (DateTime.now().difference(
                      providerWith.lostDate.subtract(const Duration(hours: 5)),
                    )))
                .inMilliseconds,
          )
          ..onStartTimer();

        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color:
                      Provider.of<SharedData>(context, listen: false).nightMode
                          ? const Color.fromARGB(255, 48, 46, 46)
                          : const Color.fromARGB(255, 239, 236, 236),
                  width: 5,
                ),
                vertical: BorderSide(
                  color:
                      Provider.of<SharedData>(context, listen: false).nightMode
                          ? const Color.fromARGB(255, 48, 46, 46)
                          : const Color.fromARGB(255, 239, 236, 236),
                  width: 3,
                ),
              ),
              color: Provider.of<SharedData>(context, listen: false).nightMode
                  ? Colors.black
                  : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 3, bottom: 2),
                        child: Text(
                          providerWith.lives.toString(),
                          style: const TextStyle(
                            color: Color.fromRGBO(255, 75, 75, 1),
                            fontSize: 42,
                          ),
                        ),
                      ),
                      for (int i = 0; i < min(providerWithout.lives, 5); i++)
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: const Icon(
                            FlutterIcons.heart_ant,
                            size: 35,
                            color: Color.fromRGBO(255, 75, 75, 1),
                          ),
                        ),
                      for (int i = 0;
                          i <
                              ((providerWithout.lives < 0)
                                  ? 5
                                  : (5 - providerWithout.lives));
                          i++)
                        Container(
                          margin: const EdgeInsets.only(
                            top: 8,
                            left: 5,
                            right: 5,
                            bottom: 5,
                          ),
                          child: const Icon(
                            FlutterIcons.heart_ant,
                            size: 33,
                            color: Color.fromRGBO(226, 222, 222, 1),
                          ),
                        ),
                    ],
                  ),
                  if (providerWith.lives < 5)
                    Container(
                      margin: const EdgeInsets.only(bottom: 3, top: 3),
                      child: StreamBuilder<int>(
                        stream: stopWatchTimer.rawTime,
                        initialData: 0,
                        builder: (context, snap) {
                          final value = snap.data;
                          final displayTime = StopWatchTimer.getDisplayTime(
                            value!,
                            milliSecond: false,
                            hours: false,
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                                child: const Icon(
                                  FlutterIcons.heart_ant,
                                  color: Color.fromRGBO(255, 75, 75, 1),
                                ),
                              ),
                              const Text(
                                '+1',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 75, 75, 1),
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                '${providerWith.texts[providerWith.appLang]["inTime"]} $displayTime',
                                style: const TextStyle(fontSize: 25),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  else
                    Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomButtonWidget(
                    fullBorder: true,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7.5)),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(38, 221, 134, 1),
                          Color.fromRGBO(38, 138, 255, 1),
                          Color.fromRGBO(234, 89, 255, 1),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (providerWithout.vibration)
                        Helpers.vibrate(HapticsType.selection);

                      // PopUps.premiumPopUp(context);
                      Provider.of<SharedData>(context, listen: false)
                          .setSubIndex(0);

                      Navigator.of(context)
                          .push(Helpers.createRoute(PremiumScreen(
                        buildContext: context,
                      )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: const Icon(
                                FlutterIcons.heart_ant,
                                color: Colors.white,
                              ),
                            ),
                            // infinity_faw5s
                            const Icon(
                              FlutterIcons.infinity_faw5s,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Text(
                          providerWith.texts[providerWith.appLang]
                              ["unlimitedLives"],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: CustomButtonWidget(
                      onTap: () async {
                        if (await Appodeal.canShow(
                                AppodealAdType.RewardedVideo) &&
                            !kIsWeb) {
                          if (providerWithout.vibration)
                            Helpers.vibrate(HapticsType.selection);

                          Appodeal.setRewardedVideoCallbacks(
                            onRewardedVideoShown: () =>
                                providerWithout.stopWatchTimer.onStopTimer(),
                            onRewardedVideoShowFailed: () =>
                                print("LOLAZO FALLIDO INICIANDO"),
                            onRewardedVideoClosed: (closed) =>
                                providerWithout.stopWatchTimer.onStartTimer(),
                            onRewardedVideoFailedToLoad: () =>
                                print("LOLAZO NO PUDO CARGARRRRRRRRRRRRRRR"),
                            onRewardedVideoFinished: (amount, reward) {
                              Helpers.addlives(context, "+1");
                              Helpers.showToast(
                                context,
                                ToastificationType.success,
                                providerWith.texts[providerWith.appLang]
                                    ["purchaseCompleted"],
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 3, right: 3),
                                      child: const Icon(
                                        FlutterIcons.heart_ant,
                                        color: Color.fromRGBO(255, 75, 75, 1),
                                      ),
                                    ),
                                    const Text(
                                      "+1",
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 75, 75, 1),
                                        fontSize: 23,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          await Appodeal.show(AppodealAdType.RewardedVideo);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: const Icon(
                                    FlutterIcons.heart_ant,
                                    color: Color.fromRGBO(255, 75, 75, 1),
                                  ),
                                ),
                                const Text(
                                  '+1',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 75, 75, 1),
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 35),
                            child: Row(
                              children: [
                                Text(
                                  providerWith.texts[providerWith.appLang]
                                      ["free"],
                                  style: const TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            FlutterIcons.video_ent,
                            size: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButtonWidget(
                    onTap: () async {
                      if (providerWithout.stars >= 100) {
                        await Helpers.addStars(context, "-100");
                        await Helpers.addlives(context, "+1");
                        Helpers.showToast(
                          context,
                          ToastificationType.success,
                          providerWith.texts[providerWith.appLang]
                              ["purchaseCompleted"],
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 3, right: 3),
                                child: const Icon(
                                  FlutterIcons.heart_ant,
                                  color: Color.fromRGBO(255, 75, 75, 1),
                                ),
                              ),
                              const Text(
                                "+1",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 75, 75, 1),
                                  fontSize: 23,
                                ),
                              ),
                            ],
                          ),
                        );

                        await Helpers.getUserInfo(context);
                      } else {
                        Helpers.showToast(
                          context,
                          ToastificationType.error,
                          providerWith.texts[providerWith.appLang]
                              ["insufficient"],
                          const Icon(
                            FlutterIcons.star_ant,
                            color: Colors.amber,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: const Icon(
                                  FlutterIcons.heart_ant,
                                  color: Color.fromRGBO(255, 75, 75, 1),
                                ),
                              ),
                              const Text(
                                '+1',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 75, 75, 1),
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          FlutterIcons.cart_outline_mco,
                          size: 35,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            right: 5,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                FlutterIcons.star_ant,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '100',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 170, 52, 1),
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

  static void profileDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (builderContext) => Dialog(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: SizedBox(
          child: CircleAvatar(
            foregroundImage:
                Provider.of<SharedData>(context, listen: false).profileBase64 !=
                        ''
                    ? MemoryImage(
                        base64Decode(
                          Provider.of<SharedData>(context, listen: false)
                              .profileBase64,
                        ),
                      )
                    : null,
            backgroundColor: const Color.fromRGBO(100, 216, 255, 1),
            minRadius: 150,
            maxRadius: 175,
            child: Align(
              child: Provider.of<SharedData>(context, listen: false)
                          .profileBase64 !=
                      ''
                  ? Container()
                  : Text(
                      Provider.of<SharedData>(context, listen: false).user[0],
                      style: TextStyle(
                        fontSize: 70,
                        color: Provider.of<SharedData>(context, listen: false)
                                .nightMode
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  static void addPoUp(BuildContext context) {
    showDialog<void>(
      builder: (builderContext) {
        final textController = TextEditingController();
        final instruccionesTextController = TextEditingController();
        final formKey = GlobalKey<FormState>();
        final dio = Dio();
        final providerWithout = Provider.of<SharedData>(context, listen: false);
        final providerWith = Provider.of<SharedData>(context, listen: false);

        return Dialog(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Provider.of<SharedData>(context, listen: false)
                            .nightMode
                        ? const Color.fromARGB(255, 65, 62, 62)
                        : const Color.fromARGB(255, 239, 236, 236),
                    width: 3,
                  ),
                  vertical: BorderSide(
                    color: Provider.of<SharedData>(context, listen: false)
                            .nightMode
                        ? const Color.fromARGB(255, 65, 62, 62)
                        : const Color.fromARGB(255, 239, 236, 236),
                    width: 2,
                  ),
                ),
                color: Provider.of<SharedData>(context, listen: false).nightMode
                    ? Colors.black
                    : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        providerWith.texts[providerWith.appLang]["addTopic"],
                        style: const TextStyle(fontSize: 35),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormFieldWidget(
                        textController: textController,
                        hintText: providerWith.texts[providerWith.appLang]
                            ["topic"],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return providerWithout
                                .texts[providerWithout.appLang]["enterTopic"];
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (providerWithout.vibration)
                            Helpers.vibrate(HapticsType.success);

                          providerWithout
                              .setHintTopic(!providerWithout.toggleHint);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 3, bottom: 3),
                              child: Text(
                                providerWith.texts[providerWith.appLang]
                                    ["advancedOptions"],
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Icon(
                                providerWith.toggleHint
                                    ? Icons.arrow_drop_down_outlined
                                    : Icons.arrow_drop_up_outlined,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (providerWith.toggleHint)
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 3),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                providerWith.texts[providerWith.appLang]
                                    ["instructQuestions"],
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormFieldWidget(
                                    textController: instruccionesTextController,
                                    validator: null,
                                    hintText:
                                        providerWith.texts[providerWith.appLang]
                                            ["instructions"],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showHintDialog(context);
                                  },
                                  icon: const Icon(
                                    Icons.question_mark_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 3, top: 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                providerWith.texts[providerWith.appLang]
                                    ["knowledgeBase"],
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            providerWith.uploaded
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: providerWith.uploadedFiles
                                        .map(
                                          (PlatformFile file) =>
                                              FileUploadedWidget(
                                            name: file.name,
                                            providerWithout: providerWithout,
                                          ) as Widget,
                                        )
                                        .toList(),
                                  )
                                : Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          Helpers.vibrate(
                                              HapticsType.selection);
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles(
                                            allowMultiple: true,
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'pdf',
                                            ],
                                          );

                                          if (result != null) {
                                            providerWithout.setUploadedFiles(
                                              result.files,
                                            );
                                            // Añadir archivos a  la lista de archivos en svbr arcihv
                                          } else {
                                            // User canceled the picker
                                          }
                                          providerWithout.setUploaded(
                                            !providerWithout.uploaded,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.upload_file,
                                          size: 65,
                                        ),
                                      ),
                                      Text(
                                        providerWith.texts[providerWith.appLang]
                                            ["upload"],
                                        style: const TextStyle(
                                          fontSize: 23,
                                        ),
                                      ),
                                    ],
                                  ),
                            Container(
                              padding: const EdgeInsets.only(left: 3),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                providerWith.texts[providerWith.appLang]
                                    ["language"],
                                style: const TextStyle(fontSize: 23),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 3),
                              alignment: Alignment.centerLeft,
                              child: DropdownButton<String>(
                                value: providerWith.selectedLang,
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: 'Español',
                                    child: Text('Español'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Inglés',
                                    child: Text('English'),
                                  ),
                                ],
                                isExpanded: true,
                                onChanged: (dynamic selectedLang) {
                                  providerWithout.setSelectedLang(
                                    selectedLang.toString(),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        const SizedBox.shrink(),
                      const SizedBox(
                        height: 5,
                      ),
                      ShrinkWidget(
                        onPressed: () async {
                          print(formKey.currentState!.validate());
                          if (formKey.currentState!.validate()) {
                            if (providerWithout.vibration)
                              Helpers.vibrate(HapticsType.success);

                            Navigator.pop(context);

                            String fileName = "";

                            final uploadedFiles = providerWithout.uploadedFiles;

                            final formData = FormData.fromMap({});

                            if (uploadedFiles.isNotEmpty) {
                              if (uploadedFiles[0].bytes != null) {
                                formData.files.add(
                                  MapEntry(
                                    '',
                                    MultipartFile.fromBytes(
                                      uploadedFiles[0].bytes!.toList(),
                                      filename: uploadedFiles[0].name,
                                    ),
                                  ),
                                );
                              }
                              fileName = uploadedFiles[0].name;
                            }

                            // Realizar la solicitud POST
                            final response = await dio.post(
                              'https://dannyluna17.pythonanywhere.com/trivi/uploadfile',
                              data: formData,
                              options: Options(
                                contentType: 'multipart/form-data',
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization':
                                      'Bearer ${providerWithout.jwt}',
                                },
                              ),
                              onSendProgress: (int sent, int total) {
                                // Opcional: Puedes mostrar el progreso de la subida
                                print('Subiendo: $sent / $total bytes');
                              },
                            );

                            print(response.data);

                            final resp = await dio.post(
                              'https://dannyluna17.pythonanywhere.com/trivi/addtopic',
                              options: Options(
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization':
                                      'Bearer ${providerWithout.jwt}',
                                },
                              ),
                              data: {
                                'name': textController.text,
                                'emoji': '🧑',
                                'language': providerWithout.selectedLang,
                                'instrucciones':
                                    instruccionesTextController.text,
                                'file_name': fileName,
                              },
                            );
                            print(resp.data);
                            await Helpers.getUserInfo(context);

                            // Provider.of<SharedData>(context, listen: false)
                            //     .addTopicBox(
                            //   SubjectBoxWidget(
                            //     topicName: textController.text,
                            //     instrucciones: instruccionesTextController.text,
                            //     emoji: '🧑',
                            //   ),
                            // );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromRGBO(78, 211, 255, 1),
                            border: Border.all(
                              color: const Color.fromARGB(255, 236, 231, 231),
                              width: 4,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

  static void editPopup(
    BuildContext context,
    String name,
    String instrucciones,
    String filename,
    String language,
    String emoji,
  ) {
    showDialog<void>(
      builder: (builderContext) {
        final providerWithoutListen =
            Provider.of<SharedData>(context, listen: false);

        final textController = TextEditingController(text: name);
        final instruccionesTextController =
            TextEditingController(text: instrucciones);
        final formKey = GlobalKey<FormState>();
        final dio = Dio();

        if (filename.isNotEmpty) {
          providerWithoutListen.setSelectedFilename(filename);
        }

        if (language.isNotEmpty) {
          providerWithoutListen.setSelectedLang(language);
        }
        final providerWithout = Provider.of<SharedData>(context, listen: false);
        final providerWith = Provider.of<SharedData>(context, listen: false);

        return Dialog(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Provider.of<SharedData>(context, listen: false)
                            .nightMode
                        ? const Color.fromARGB(255, 65, 62, 62)
                        : const Color.fromARGB(255, 239, 236, 236),
                    width: 3,
                  ),
                  vertical: BorderSide(
                    color: Provider.of<SharedData>(context, listen: false)
                            .nightMode
                        ? const Color.fromARGB(255, 65, 62, 62)
                        : const Color.fromARGB(255, 239, 236, 236),
                    width: 2,
                  ),
                ),
                color: Provider.of<SharedData>(context, listen: false).nightMode
                    ? Colors.black
                    : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        providerWith.texts[providerWith.appLang]["editTopic"],
                        style: const TextStyle(fontSize: 35),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormFieldWidget(
                        textController: textController,
                        hintText: providerWith.texts[providerWith.appLang]
                            ["topic"],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return providerWithout
                                .texts[providerWithout.appLang]["enterTopic"];
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => providerWithout
                            .setHintTopic(!providerWithout.toggleHint),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 3, bottom: 3),
                              child: Text(
                                providerWith.texts[providerWith.appLang]
                                    ["advancedOptions"],
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Icon(
                                providerWith.toggleHint
                                    ? Icons.arrow_drop_down_outlined
                                    : Icons.arrow_drop_up_outlined,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (providerWith.toggleHint)
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 3),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                providerWith.texts[providerWith.appLang]
                                    ["instructQuestions"],
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormFieldWidget(
                                    textController: instruccionesTextController,
                                    validator: null,
                                    hintText:
                                        providerWith.texts[providerWith.appLang]
                                            ["instructions"],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showHintDialog(context);
                                  },
                                  icon: const Icon(
                                    Icons.question_mark_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 3, top: 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                providerWith.texts[providerWith.appLang]
                                    ["knowledgeBase"],
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            providerWith.uploaded
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: providerWith.uploadedFiles.isEmpty
                                        ? [
                                            FileUploadedWidget(
                                              name: filename,
                                              providerWithout: providerWithout,
                                            ) as Widget,
                                          ]
                                        : providerWith.uploadedFiles
                                            .map(
                                              (PlatformFile file) =>
                                                  FileUploadedWidget(
                                                name: file.name,
                                                providerWithout:
                                                    providerWithout,
                                              ) as Widget,
                                            )
                                            .toList(),
                                  )
                                : Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          Helpers.vibrate(
                                              HapticsType.selection);
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles(
                                            allowMultiple: true,
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'pdf',
                                            ],
                                          );

                                          if (result != null) {
                                            providerWithout.setUploadedFiles(
                                              result.files,
                                            );
                                            // Añadir archivos a  la lista de archivos en svbr arcihv
                                          } else {
                                            // User canceled the picker
                                          }
                                          providerWithout.setUploaded(
                                            !providerWithout.uploaded,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.upload_file,
                                          size: 65,
                                        ),
                                      ),
                                      Text(
                                        providerWith.texts[providerWith.appLang]
                                            ["upload"],
                                        style: const TextStyle(
                                          fontSize: 23,
                                        ),
                                      ),
                                    ],
                                  ),
                            Container(
                              padding: const EdgeInsets.only(left: 3),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                providerWith.texts[providerWith.appLang]
                                    ["language"],
                                style: const TextStyle(fontSize: 23),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 3),
                              alignment: Alignment.centerLeft,
                              child: DropdownButton<String>(
                                value: providerWith.selectedLang,
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: 'Español',
                                    child: Text('Español'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Inglés',
                                    child: Text('English'),
                                  ),
                                ],
                                isExpanded: true,
                                onChanged: (dynamic selectedLang) {
                                  providerWithout.setSelectedLang(
                                    selectedLang.toString(),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      else
                        const SizedBox.shrink(),
                      const SizedBox(
                        height: 5,
                      ),
                      ShrinkWidget(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (providerWithout.vibration)
                              Helpers.vibrate(HapticsType.success);

                            Navigator.pop(context);

                            final uploadedFiles = providerWithout.uploadedFiles;

                            final formData = FormData.fromMap({});

                            Response? response;

                            if (providerWithout.uploadedFiles.isNotEmpty) {
                              if (uploadedFiles[0].bytes != null) {
                                formData.files.add(
                                  MapEntry(
                                    '',
                                    MultipartFile.fromBytes(
                                      uploadedFiles[0].bytes!.toList(),
                                      filename: uploadedFiles[0].name,
                                    ),
                                  ),
                                );
                              }
                              response = await dio.post(
                                'https://dannyluna17.pythonanywhere.com/trivi/uploadfile',
                                data: formData,
                                options: Options(
                                  contentType: 'multipart/form-data',
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization':
                                        'Bearer ${providerWithout.jwt}',
                                  },
                                ),
                                onSendProgress: (int sent, int total) {
                                  // Opcional: Puedes mostrar el progreso de la subida
                                  print('Subiendo: $sent / $total bytes');
                                },
                              );
                              print(response.data);
                            }

                            // Realizar la solicitud POST

                            final resp = await dio.post(
                              'https://dannyluna17.pythonanywhere.com/trivi/updatetopic',
                              options: Options(
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization':
                                      'Bearer ${providerWithout.jwt}',
                                },
                              ),
                              data: {
                                'new_name': textController.text,
                                'name': name,
                                'emoji': emoji,
                                'instrucciones':
                                    instruccionesTextController.text,
                                'file_name': uploadedFiles.isNotEmpty
                                    ? uploadedFiles[0].name
                                    : "",
                                'language': providerWithout.selectedLang,
                              },
                            );
                            print(resp.data);
                            await Helpers.getUserInfo(context);

                            // Provider.of<SharedData>(context, listen: false)
                            //     .addTopicBox(
                            //   SubjectBoxWidget(
                            //     topicName: textController.text,
                            //     instrucciones: instruccionesTextController.text,
                            //     emoji: '🧑',
                            //   ),
                            // );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromRGBO(78, 211, 255, 1),
                            border: Border.all(
                              color: const Color.fromARGB(255, 236, 231, 231),
                              width: 4,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      context: context,
      barrierDismissible: true,
    );
  }

  static void gameOverPopUp(BuildContext context) {
    showDialog<void>(
      builder: (builderContext) {
        final formKey = GlobalKey<FormState>();
        final providerWithout = Provider.of<SharedData>(context, listen: false);
        final providerWith = Provider.of<SharedData>(context, listen: false);

        return Dialog(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Provider.of<SharedData>(context, listen: false)
                            .nightMode
                        ? const Color.fromARGB(255, 65, 62, 62)
                        : const Color.fromARGB(255, 239, 236, 236),
                    width: 3,
                  ),
                  vertical: BorderSide(
                    color: Provider.of<SharedData>(context, listen: false)
                            .nightMode
                        ? const Color.fromARGB(255, 65, 62, 62)
                        : const Color.fromARGB(255, 239, 236, 236),
                    width: 2,
                  ),
                ),
                color: Provider.of<SharedData>(context, listen: false).nightMode
                    ? Colors.black
                    : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        providerWith.texts[providerWith.appLang]["gameOver"],
                        style: const TextStyle(fontSize: 35),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedCardAppear(
                            delay: const Duration(milliseconds: 100),
                            child: TapScaleAnimation(
                              onTap: () {},
                              child: CustomBoxWidget(
                                border: const Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(252, 203, 1, 1),
                                    width: 4,
                                  ),
                                  top: BorderSide(
                                    color: Color.fromRGBO(252, 203, 1, 1),
                                    width: 7,
                                  ),
                                  right: BorderSide(
                                    color: Color.fromRGBO(252, 203, 1, 1),
                                    width: 4,
                                  ),
                                  left: BorderSide(
                                    color: Color.fromRGBO(252, 203, 1, 1),
                                    width: 4,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        FlutterIcons.star_ant,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 5),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(right: 2, left: 5),
                                        child: Text(
                                          '+',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(255, 170, 52, 1),
                                            fontSize: 28.5,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          (providerWithout.correctAnswers * 20)
                                              .toString(),
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(255, 170, 52, 1),
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedCardAppear(
                            delay: const Duration(milliseconds: 400),
                            child: TapScaleAnimation(
                              onTap: () {},
                              child: CustomBoxWidget(
                                border: const Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(88, 207, 0, 1),
                                    width: 4,
                                  ),
                                  top: BorderSide(
                                    color: Color.fromRGBO(88, 207, 0, 1),
                                    width: 7,
                                  ),
                                  right: BorderSide(
                                    color: Color.fromRGBO(88, 207, 0, 1),
                                    width: 4,
                                  ),
                                  left: BorderSide(
                                    color: Color.fromRGBO(88, 207, 0, 1),
                                    width: 4,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        FlutterIcons.target_fea,
                                        color: Color.fromRGBO(88, 207, 0, 1),
                                      ),
                                      const SizedBox(width: 5),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          (providerWithout.correctAnswers /
                                                  providerWithout.nPreg *
                                                  100)
                                              .round()
                                              .toString(),
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(88, 207, 0, 1),
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          left: 2,
                                          right: 5,
                                          top: 2,
                                        ),
                                        child: Text(
                                          '%',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(88, 207, 0, 1),
                                            fontSize: 28.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedCardAppear(
                            delay: const Duration(milliseconds: 900),
                            child: TapScaleAnimation(
                              onTap: () {},
                              child: CustomBoxWidget(
                                border: const Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(17, 179, 254, 1),
                                    width: 4,
                                  ),
                                  top: BorderSide(
                                    color: Color.fromRGBO(17, 179, 254, 1),
                                    width: 7,
                                  ),
                                  right: BorderSide(
                                    color: Color.fromRGBO(17, 179, 254, 1),
                                    width: 4,
                                  ),
                                  left: BorderSide(
                                    color: Color.fromRGBO(17, 179, 254, 1),
                                    width: 4,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        FlutterIcons.clock_faw5s,
                                        color: Color.fromRGBO(17, 179, 254, 1),
                                      ),
                                      const SizedBox(width: 5),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          StopWatchTimer.getDisplayTime(
                                            providerWithout
                                                .stopWatchTimer.rawTime.value,
                                            hours: providerWithout
                                                    .stopWatchTimer
                                                    .rawTime
                                                    .value >
                                                StopWatchTimer
                                                    .getMilliSecFromMinute(30),
                                            milliSecond: false,
                                          ),
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(17, 179, 254, 1),
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomButtonWidget(
                        scaleValue: 1.05,
                        onTap: () {
                          if (providerWithout.vibration)
                            Helpers.vibrate(HapticsType.success);

                          Navigator.pop(context);
                          Navigator.of(context)
                              .pushReplacement(Helpers.createRoute(MainScreen(
                            builderContext: context,
                          )));
                          providerWithout
                            ..setActualQuestion(0)
                            ..setAnswer(0);
                        },
                        label: providerWith.texts[providerWith.appLang]
                            ["continue"],
                        expandible: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      context: context,
      barrierDismissible: false,
    );
  }

  static void premiumPopUp(BuildContext context) {
    showDialog<void>(
      builder: (builderContext) {
        final providerWithout = Provider.of<SharedData>(context, listen: false);
        final formKey = GlobalKey<FormState>();
        final providerWith = Provider.of<SharedData>(context, listen: false);
        return Dialog(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  stops: [
                    0.55,
                    1,
                  ],
                  colors: [
                    Color.fromRGBO(48, 111, 133, 1),
                    Color.fromRGBO(80, 76, 165, 1),
                  ],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: const [
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: PremiumWidget(),
                              ),
                            ),
                          ],
                          text: providerWith.texts[providerWith.appLang]
                              ["accelerateProgress"],
                          style: const TextStyle(
                              fontSize: 27, color: Colors.white),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          FeatureWidget(
                            label:
                                providerWithout.texts[providerWithout.appLang]
                                    ["learningContent"],
                          ),
                          FeatureWidget(
                              label: providerWithout
                                  .texts[providerWithout.appLang]["noAds"]),
                          FeatureWidget(
                            label:
                                providerWithout.texts[providerWithout.appLang]
                                    ["livesUnlimited"],
                          ),
                          FeatureWidget(
                              label:
                                  providerWithout.texts[providerWithout.appLang]
                                      ["reviewMistakes"]),
                          FeatureWidget(
                            label:
                                providerWithout.texts[providerWithout.appLang]
                                    ["advancedIAModel"],
                          ),
                          FeatureWidget(
                            fontSize: 18,
                            label:
                                providerWithout.texts[providerWithout.appLang]
                                    ["upTo100QuestionsPerGame"],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12.5,
                      ),
                      CustomButtonWidget(
                        onTap: () {
                          if (providerWithout.vibration)
                            Helpers.vibrate(HapticsType.success);

                          Navigator.pop(context);
                          toastification.show(
                            icon: const Icon(
                              FlutterIcons.check_circle_faw5,
                              size: 35,
                            ),
                            type: ToastificationType.success,
                            style: ToastificationStyle.minimal,
                            title: Text(
                              providerWith.texts[providerWith.appLang]
                                  ["purchaseCompleted"],
                              style: const TextStyle(fontSize: 18),
                            ),
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 4),
                          );

                          providerWithout.setPremium(true);
                        },
                        child: Text(
                          providerWith.texts[providerWith.appLang]
                              ["tryFor7Days"],
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

  static void purchasedPopUp(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      builder: (builderContext) {
        final formKey = GlobalKey<FormState>();

        final providerWithout = Provider.of<SharedData>(context, listen: false);
        final providerWith = Provider.of<SharedData>(context, listen: false);
        return Dialog(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  stops: [
                    0.55,
                    1,
                  ],
                  colors: [
                    Color.fromRGBO(48, 111, 133, 1),
                    Color.fromRGBO(80, 76, 165, 1),
                  ],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        providerWith.texts[providerWith.appLang]
                            ["thanksForYourPurchase"],
                        style:
                            const TextStyle(fontSize: 27, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButtonWidget(
                        onTap: () {
                          if (providerWithout.vibration)
                            Helpers.vibrate(HapticsType.success);

                          Navigator.pop(context);
                          Navigator.of(context)
                              .pushReplacement(Helpers.createRoute(MainScreen(
                            builderContext: context,
                          )));

                          providerWithout.setPremium(true);
                        },
                        child: Text(
                          providerWith.texts[providerWith.appLang]
                              ["enjoyYourBenefitsNow"],
                          style: const TextStyle(fontSize: 23),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

  static void updatePopUp(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      builder: (builderContext) {
        final formKey = GlobalKey<FormState>();
        final providerWithout = Provider.of<SharedData>(context, listen: false);

        return Dialog(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  stops: [
                    0.55,
                    1,
                  ],
                  colors: [
                    Color.fromRGBO(48, 111, 133, 1),
                    Color.fromRGBO(80, 76, 165, 1),
                  ],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        providerWithout.texts != null
                            ? providerWithout.texts[providerWithout.appLang]
                                ["update_message"]
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 27,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButtonWidget(
                        onTap: () async {
                          if (providerWithout.vibration)
                            Helpers.vibrate(HapticsType.success);

                          if (!await launchUrl(Uri.parse(
                              "https://play.google.com/store/apps/details?id=com.dannyluna.trivi_app"))) {
                            throw Exception(
                                'Could not launch https://play.google.com/store/apps/details?id=com.dannyluna.trivi_app');
                          }
                        },
                        child: Text(
                          providerWithout.texts != null
                              ? providerWithout.texts[providerWithout.appLang]
                                  ["update_button"]
                              : "Loading...",
                          style: const TextStyle(
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }
}

class FeatureWidget extends StatelessWidget {
  const FeatureWidget({required this.label, this.fontSize = 21, super.key});

  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          FlutterIcons.check_bold_mco,
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            overflow: TextOverflow.ellipsis,
            label,
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

void _showHintDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (builderContext) {
      final providerWith = Provider.of<SharedData>(context, listen: false);
      return Dialog(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.all(15),
          child: Text(
            providerWith.texts[providerWith.appLang]["conditionQuestions"],
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    },
  );
}
