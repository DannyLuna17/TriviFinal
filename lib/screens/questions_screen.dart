import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/screens/main_screen.dart';
import 'package:trivi_app/snacks/snacks.dart';
import 'package:trivi_app/widgets/widgets.dart';
import 'package:delayed_widget/delayed_widget.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({
    super.key,
    required this.buildContext,
  });

  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    final questionsAndAnswers =
        providerWith.questionsAndAnswers[0]['questions'];
    final actualQuestion = providerWith.actualQuestion;
    final questionsAnswersWithoutListen =
        providerWithout.questionsAndAnswers[0]['questions'];
    final currentQuestion = providerWithout.actualQuestion;
    final selectedAnswer = providerWithout.selectedAnswer;

    providerWithout.setLoaded(true);
    providerWithout.setLoading(false);

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: DelayedWidget(
              delayDuration: const Duration(milliseconds: 100),
              animation: DelayedAnimations.SLIDE_FROM_LEFT,
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    CloseButtonWidget(
                      onTap: () => Navigator.of(context)
                          .push(Helpers.createRoute(MainScreen(
                        builderContext: buildContext,
                      ))),
                    ),
                    const ProgressBarWidget(),
                    const SizedBox(
                      width: 5,
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        const Icon(
                          FlutterIcons.star_ant,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          providerWith.stars.toString(),
                          style: const TextStyle(
                            color: Color.fromRGBO(255, 170, 52, 1),
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    Row(
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
                          // TODO ; QUESTIONS NUMBER
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: DelayedWidget(
              delayDuration: const Duration(milliseconds: 300),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _MultipleQuestionWidget(
                      question: questionsAndAnswers[actualQuestion]['question']
                          .toString(),
                      answers: questionsAndAnswers[actualQuestion]['options']
                          as List<dynamic>,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(thickness: 1.7),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: DelayedWidget(
              delayDuration: const Duration(milliseconds: 500),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: CustomButtonWidget(
                label: providerWith.texts[providerWith.appLang]["continue"],
                isEnabled: providerWith.selectedAnswer != 0,
                onTap: () async {
                  final isCorrect =
                      questionsAnswersWithoutListen[currentQuestion]['options']
                              [selectedAnswer - 1] ==
                          questionsAnswersWithoutListen[currentQuestion]
                              ['answer'];
                  final isCorrect2 = (selectedAnswer - 1).toString() ==
                      questionsAnswersWithoutListen[currentQuestion]['answer']
                          .toString();
                  print("Primero $isCorrect Segundo $isCorrect2");
                  print(
                    "A: ${questionsAnswersWithoutListen[currentQuestion]['options'][selectedAnswer - 1]} B: ${questionsAnswersWithoutListen[currentQuestion]['answer']}",
                  );
                  print(
                    "C: ${selectedAnswer - 1} D: ${questionsAnswersWithoutListen[currentQuestion]['answer']}",
                  );
                  print(providerWithout.questionsAndAnswers);

                  if (isCorrect || isCorrect2) {
                    if (providerWithout.vibration)
                      Helpers.vibrate(HapticsType.success);

                    providerWithout
                        .setCorrectAnswers(providerWithout.correctAnswers + 1);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(Snacks.successSnackBar(context));
                    await Helpers.addStars(context, '+20');
                  } else {
                    if (providerWithout.vibration)
                      Helpers.vibrate(HapticsType.error);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(Snacks.failSnackBar(context));
                    unawaited(Helpers.addlives(context, '-1'));
                  }
                  // ignore: curly_braces_in_flow_control_structures
                  if (!kIsWeb) if (await Appodeal.canShow(
                          AppodealAdType.Interstitial) &&
                      providerWithout.actualQuestion % 4 == 0 &&
                      providerWithout.actualQuestion != 0) {
                    Appodeal.setInterstitialCallbacks(
                      onInterstitialShown: () =>
                          providerWithout.stopWatchTimer.onStopTimer(),
                      onInterstitialShowFailed: () =>
                          print("LOLAZO FALLIDO INICIANDO"),
                      onInterstitialClosed: (closed) =>
                          providerWithout.stopWatchTimer.onStartTimer(),
                      onInterstitialFailedToLoad: () =>
                          print("LOLAZO NO PUDO CARGARRRRRRRRRRRRRRR"),
                    );
                    await Appodeal.show(AppodealAdType.Interstitial);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MultipleQuestionWidget extends StatelessWidget {
  const _MultipleQuestionWidget({
    required this.question,
    required this.answers,
  });

  final String question;
  final List<dynamic> answers;

  @override
  Widget build(BuildContext context) {
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    final providerWith = Provider.of<SharedData>(context);

    return DelayedWidget(
      delayDuration: const Duration(milliseconds: 100),
      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            providerWith.texts[providerWith.appLang]["selectTheCorrectOption"],
            style: const TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: providerWith.nightMode ? Colors.black : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: const Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(229, 229, 229, 1),
                  width: 4,
                ),
                top: BorderSide(
                  color: Color.fromRGBO(229, 229, 229, 1),
                  width: 2,
                ),
                right: BorderSide(
                  color: Color.fromRGBO(229, 229, 229, 1),
                  width: 2,
                ),
                left: BorderSide(
                  color: Color.fromRGBO(229, 229, 229, 1),
                  width: 2,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text.rich(
                TextSpan(
                  text: question,
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'FredokaRegular',
                  ),
                  children: [
                    WidgetSpan(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: GestureDetector(
                          onTap: () {
                            try {
                              providerWithout.flutterTts.speak(question);
                            } catch (error) {
                              print(error);
                            }
                          },
                          child: const Icon(
                            Icons.volume_up_sharp,
                            size: 30,
                            color: Color.fromRGBO(78, 211, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < answers.length; i++)
            AnswerButtonWidget(
              label: answers[i].toString(),
              id: i + 1,
            ),
        ],
      ),
    );
  }
}
