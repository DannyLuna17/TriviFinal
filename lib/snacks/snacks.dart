import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/widgets/widgets.dart';

class Snacks {
  static SnackBar failSnackBar(BuildContext context) {
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);
    final providerWith = Provider.of<SharedData>(context, listen: false);
    String answer;
    final dio = Dio();

    providerWithoutListen.setProgress(
      providerWithoutListen.progressValue + 1 / providerWithoutListen.nPreg,
    );

    try {
      final answerId = int.parse(
        providerWithoutListen.questionsAndAnswers[0]['questions']
                [providerWithoutListen.actualQuestion]['answer']
            .toString(),
      );

      answer = providerWithoutListen.questionsAndAnswers[0]['questions']
              [providerWithoutListen.actualQuestion]['options'][answerId]
          .toString();
    } on Error {
      answer = providerWithoutListen.questionsAndAnswers[0]['questions']
              [providerWithoutListen.actualQuestion]['answer']
          .toString();
    }

    return SnackBar(
      dismissDirection: DismissDirection.none,
      duration: const Duration(seconds: 9999999),
      backgroundColor: const Color.fromRGBO(255, 223, 224, 1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(234, 43, 43, 1),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: providerWithoutListen.nightMode
                      ? Colors.black
                      : Colors.white,
                  size: 40,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  providerWith.texts[providerWith.appLang]["incorrect"],
                  style: const TextStyle(
                    color: Color.fromRGBO(234, 43, 43, 1),
                    fontSize: 35,
                  ),
                ),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.1,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                '${providerWith.texts[providerWith.appLang]["rightAnswer"]}: $answer',
                style: const TextStyle(
                  color: Color.fromRGBO(234, 43, 43, 1),
                  fontSize: 22,
                  fontFamily: 'FredokaRegular',
                ),
              ),
            ),
          ),
          Text(
            '${providerWith.texts[providerWith.appLang]["comments"]}:',
            style: const TextStyle(
              color: Color.fromRGBO(234, 43, 43, 1),
              fontSize: 27.5,
              fontFamily: 'Fredoka',
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.17,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                providerWithoutListen.questionsAndAnswers[0]['questions']
                        [providerWithoutListen.actualQuestion]['explanation']
                    .toString(),
                style: const TextStyle(
                  color: Color.fromRGBO(234, 43, 43, 1),
                  fontSize: 22,
                  fontFamily: 'FredokaRegular',
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
              bottom: 10,
            ),
            child: CustomButtonWidget(
              fullBorder: false,
              label: providerWith.texts[providerWith.appLang]["continue"],
              onTap: () {
                if (providerWithoutListen.vibration)
                  Helpers.vibrate(HapticsType.success);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                if (providerWithoutListen.lives < 1) {
                  providerWithoutListen.stopWatchTimer.onStopTimer();

                  PopUps.gameOverPopUp(context);
                } else {
                  if (providerWithoutListen.actualQuestion + 1 <
                      providerWithoutListen.nPreg) {
                    providerWithoutListen
                      ..setActualQuestion(
                        providerWithoutListen.actualQuestion + 1,
                      )
                      ..setAnswer(0);
                  } else {
                    providerWithoutListen.stopWatchTimer.onStopTimer();

                    unawaited(
                      dio.post(
                        'https://dannyluna17.pythonanywhere.com/trivi/updatestreak',
                        options: Options(
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization':
                                'Bearer ${providerWithoutListen.jwt}',
                          },
                        ),
                      ),
                    );
                    Helpers.getUserInfo(context);

                    PopUps.gameOverPopUp(context);
                  }
                }
              },
              fontColor:
                  providerWithoutListen.nightMode ? Colors.black : Colors.white,
              colorNormal: const Color.fromRGBO(234, 43, 43, 1),
              colorPressed: const Color.fromRGBO(234, 43, 43, 1),
              backNormal: const Color.fromRGBO(255, 75, 75, 1),
              backPressed: const Color.fromRGBO(255, 75, 75, 1),
            ),
          ),
        ],
      ),
    );
  }

  static SnackBar successSnackBar(BuildContext context) {
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);
    String answer;
    final dio = Dio();
    final providerWith = Provider.of<SharedData>(context, listen: false);
    providerWithoutListen.setProgress(
      providerWithoutListen.progressValue + 1 / providerWithoutListen.nPreg,
    );
    try {
      final answerId = int.parse(
        providerWithoutListen.questionsAndAnswers[0]['questions']
                [providerWithoutListen.actualQuestion]['answer']
            .toString(),
      );

      answer = providerWithoutListen.questionsAndAnswers[0]['questions']
              [providerWithoutListen.actualQuestion]['options'][answerId]
          .toString();
    } on Error {
      answer = providerWithoutListen.questionsAndAnswers[0]['questions']
              [providerWithoutListen.actualQuestion]['answer']
          .toString();
    }

    return SnackBar(
      behavior: SnackBarBehavior.fixed,
      dismissDirection: DismissDirection.none,
      duration: const Duration(seconds: 9999999),
      backgroundColor: const Color.fromRGBO(215, 255, 184, 1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(88, 167, 0, 1),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: providerWithoutListen.nightMode
                      ? Colors.black
                      : Colors.white,
                  size: 40,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  providerWith.texts != null
                      ? providerWith.texts[providerWith.appLang]["correct"]
                      : "Loading...",
                  style: const TextStyle(
                    color: Color.fromRGBO(88, 167, 0, 1),
                    fontSize: 35,
                  ),
                ),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.1,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                '${providerWith.texts != null ? providerWith.texts[providerWith.appLang]["rightAnswer"] : "Loading..."}: $answer',
                style: const TextStyle(
                  color: Color.fromRGBO(88, 167, 0, 1),
                  fontSize: 22,
                  fontFamily: 'FredokaRegular',
                ),
              ),
            ),
          ),
          Text(
            '${providerWith.texts != null ? providerWith.texts[providerWith.appLang]["comments"] : "Loading..."}:',
            style: const TextStyle(
              color: Color.fromRGBO(88, 167, 0, 1),
              fontSize: 27.5,
              fontFamily: 'Fredoka',
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.17,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                providerWithoutListen.questionsAndAnswers[0]['questions']
                        [providerWithoutListen.actualQuestion]['explanation']
                    .toString(),
                style: const TextStyle(
                  color: Color.fromRGBO(88, 167, 0, 1),
                  fontSize: 22,
                  fontFamily: 'FredokaRegular',
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
              bottom: 10,
            ),
            child: CustomButtonWidget(
              fullBorder: false,
              label: providerWith.texts != null
                  ? providerWith.texts[providerWith.appLang]["continue"]
                  : "Loading...",
              onTap: () {
                if (providerWithoutListen.vibration)
                  Helpers.vibrate(HapticsType.success);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                if (providerWithoutListen.actualQuestion + 1 <
                    providerWithoutListen.nPreg) {
                  providerWithoutListen
                    ..setActualQuestion(
                      providerWithoutListen.actualQuestion + 1,
                    )
                    ..setAnswer(0);
                } else {
                  providerWithoutListen.stopWatchTimer.onStopTimer();

                  dio.post(
                    'https://dannyluna17.pythonanywhere.com/trivi/updatestreak',
                    options: Options(
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ${providerWithoutListen.jwt}',
                      },
                    ),
                  );
                  Helpers.getUserInfo(context);

                  PopUps.gameOverPopUp(context);
                  // providerWithoutListen.setActualQuestion(0);
                  // providerWithoutListen.setAnswer(0);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute<void>(
                  //     builder: (context) => const MainScreen(),
                  //   ),
                  // );
                }

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              fontColor:
                  providerWithoutListen.nightMode ? Colors.black : Colors.white,
              colorNormal: const Color.fromRGBO(88, 167, 0, 1),
              colorPressed: const Color.fromRGBO(88, 167, 0, 1),
              backNormal: const Color.fromRGBO(97, 224, 2, 1),
              backPressed: const Color.fromRGBO(97, 224, 2, 1),
            ),
          ),
        ],
      ),
    );
  }

  static SnackBar loginAndrRegisterSnackBar(
      BuildContext context, bool isLogin, BuildContext buildContext) {
    final userController = TextEditingController();
    final passwordController = TextEditingController();
    final loginFormKey = GlobalKey<FormState>();
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    return SnackBar(
      dismissDirection: DismissDirection.none,
      duration: const Duration(seconds: 9999999),
      backgroundColor: providerWithout.nightMode
          ? const Color.fromARGB(255, 38, 37, 37)
          : const Color.fromARGB(255, 240, 238, 238),
      content: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: loginFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: CloseButton(
                    style: const ButtonStyle(
                      iconSize: WidgetStatePropertyAll(40),
                    ),
                    onPressed: () {
                      if (providerWithout.vibration)
                        Helpers.vibrate(HapticsType.selection);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        } else if (buildContext.mounted) {
                          ScaffoldMessenger.of(buildContext)
                              .hideCurrentSnackBar();
                        }
                      });

                      providerWithoutListen.changeSnackShown(false);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    isLogin
                        ? providerWithout.texts != null
                            ? providerWithout.texts[providerWithout.appLang]
                                ["login"]
                            : "Loading..."
                        : providerWithout.texts != null
                            ? providerWithout.texts[providerWithout.appLang]
                                ["register"]
                            : "Loading...",
                    style: TextStyle(
                      fontSize: 25,
                      color: providerWithout.nightMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: CustomTextFormFieldWidget(
                textController: userController,
                validator: (value) {
                  if (value!.isEmpty) {
                    //
                    return providerWithout.texts[providerWithout.appLang]
                        ["userInputEmpty"];
                  } else if (value.length < 4) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["userMin4"];
                  } else if (value.length > 20) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["userMax20"];
                  } else if (value.contains('"') == true) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["userNoQuotes"];
                  } else if (value.contains(r'\') == true) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["userNoSlashes"];
                  } else if (value.contains('/') == true) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["userNoSlashes"];
                  } else if (value.length > 20) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["userLessThan20"];
                  } else if (value.contains(' ')) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["userNoSpaces"];
                  } else {
                    return null;
                  }
                },
                hintText: providerWithout.texts[providerWithout.appLang]
                    ["userHint"],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: CustomTextFormFieldWidget(
                textController: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["passwordInputEmpty"];
                  }
                  value = Uri.encodeComponent(value);
                  if (value.length < 6) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["passwordMin6"];
                  } else if (value.contains('@') == false &&
                      value.contains('-') == false &&
                      value.contains('.') == false &&
                      value.contains(',') == false &&
                      value.contains(';') == false &&
                      value.contains(' ') == false &&
                      value.contains('!') == false &&
                      value.contains('#') == false &&
                      value.contains(r'$') == false &&
                      value.contains('%') == false &&
                      value.contains('^') == false &&
                      value.contains('&') == false &&
                      value.contains('*') == false &&
                      value.contains('(') == false &&
                      value.contains(')') == false &&
                      value.contains('+') == false &&
                      value.contains('=') == false &&
                      value.contains('/') == false &&
                      value.contains(':') == false &&
                      value.contains('<') == false &&
                      value.contains('>') == false &&
                      value.contains('?') == false) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["passwordOneSpecial"];
                  } else if (value.toLowerCase() == value) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["passwordOneUpper"];
                  } else if (value.toUpperCase() == value) {
                    return providerWithout.texts[providerWithout.appLang]
                        ["passwordOneLower"];
                  } else {
                    return null;
                  }
                },
                hintText: providerWithout.texts[providerWithout.appLang]
                    ["passwordHint"],
              ),
            ),
            RememberWidget(providerWithoutListen: providerWithoutListen),
            Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: CustomButtonWidget(
                label: providerWithout.texts[providerWithout.appLang]
                    ["continue"],
                colorNormal: providerWithoutListen.nightMode
                    ? const Color.fromARGB(255, 62, 60, 60)
                    : const Color.fromARGB(255, 186, 185, 185),
                onTap: () async {
                  if (providerWithout.vibration)
                    Helpers.vibrate(HapticsType.success);

                  if (loginFormKey.currentState!.validate()) {
                    unawaited(PopUps.loadingPopUp(context));

                    final apiUri =
                        'https://dannyluna17.pythonanywhere.com/trivi/${isLogin ? "login" : "register"}';
                    String appUserId;
                    if (!kIsWeb) {
                      final customerInfo = await Purchases.getCustomerInfo();
                      appUserId = customerInfo.originalAppUserId;
                      print('PREVIEW $appUserId');
                    } else {
                      appUserId = '';
                    }
                    final response = await http.post(
                      Uri.parse(apiUri),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        'userName': Uri.encodeComponent(userController.text),
                        'pwd': Uri.encodeComponent(passwordController.text),
                        'remember': providerWithoutListen.remember,
                        'app_user_id': appUserId,
                      }),
                    );
                    final decodedBody = jsonDecode(response.body);
                    print('DECODEDBODY');
                    print(decodedBody);

                    if (response.statusCode == 200 &&
                        decodedBody['success'] == true) {
                      if (providerWithout.vibration)
                        Helpers.vibrate(HapticsType.success);

                      if (context.mounted && Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          if (!isLogin) {
                            Helpers.addDefaultTopics(context);
                          }
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        } else if (buildContext.mounted) {
                          if (!isLogin) {
                            Helpers.addDefaultTopics(buildContext);
                          }
                          ScaffoldMessenger.of(buildContext)
                              .hideCurrentSnackBar();
                        } else {
                          print("NADA");
                        }
                      });

                      providerWithoutListen.changeSnackShown(false);

                      // Navegar a main
                      // if (context.mounted) {
                      //   Navigator.of(context).pushReplacement(
                      //       Helpers.createRoute(
                      //           MainScreen(builderContext: context)));
                      // }

                      providerWithoutListen
                          .setJwt(decodedBody['access_token'] as String);
                      await Hive.box<String>('jwtBox')
                          .put('jwt', decodedBody['access_token'] as String);

                      providerWithoutListen.setAppUserId(
                        (decodedBody['app_user_id'] ?? '') as String,
                      );
                      await Hive.box<String>('appIdBox').put(
                        'id',
                        (decodedBody['app_user_id'] ?? '') as String,
                      );
                      print(
                          "AFTER ${Hive.box<String>("appIdBox").get("id", defaultValue: "")}");

                      await Hive.box<String>('userBox')
                          .put('user', userController.text);
                      providerWithoutListen.setUser(userController.text);

                      // ignore: use_build_context_synchronously
                      // Navigator.pop(context);
                      print(decodedBody['created_at']);

                      // ignore: use_build_context_synchronously
                      unawaited(
                        Hive.box<int>('dateBox').put(
                          'date',
                          DateTime.parse(
                            decodedBody['created_at'].toString(),
                          ).microsecondsSinceEpoch,
                        ),
                      );
                      providerWithoutListen.setDate(
                        DateTime.parse(
                          decodedBody['created_at'].toString(),
                        ).microsecondsSinceEpoch,
                      );

                      await Hive.box<int>('starsBox')
                          .put('stars', decodedBody['stars'] as int);
                      providerWithoutListen.setStars(
                        decodedBody['stars'] as int,
                      );
                      await Hive.box<int>('livesBox')
                          .put('lives', decodedBody['lives'] as int);
                      providerWithoutListen.setlives(
                        decodedBody['lives'] as int,
                      );
                      await Hive.box<int>('streakBox')
                          .put('streak', decodedBody['streak'] as int);
                      providerWithoutListen
                          .setStreak(decodedBody['streak'] as int);
                      Future.delayed(const Duration(seconds: 1), () async {
                        await Helpers.getUserInfo(buildContext);
                      });
                    } else {
                      if (providerWithout.vibration)
                        Helpers.vibrate(HapticsType.error);

                      if (decodedBody['error'].contains('Incorrect Password') ==
                          false) {
                        userController.text = '';
                      }
                      passwordController.text = '';

                      Navigator.pop(context);
                      Toastification().show(
                        alignment: Alignment.topCenter,
                        style: ToastificationStyle.minimal,
                        showProgressBar: true,
                        title: Text(providerWithout
                            .texts[providerWithout.appLang]["error"]),
                        description: Text(decodedBody['error'].toString()),
                        autoCloseDuration: const Duration(seconds: 4),
                        type: ToastificationType.error,
                      );
                    }
                  } else {
                    passwordController.text = '';
                    userController.text = '';
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RememberWidget extends StatelessWidget {
  const RememberWidget({
    required this.providerWithoutListen,
    super.key,
  });

  final SharedData providerWithoutListen;

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          if (providerWithoutListen.vibration)
            Helpers.vibrate(HapticsType.selection);

          providerWithoutListen.setRemember(!providerWithoutListen.remember);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              providerWith.texts[providerWith.appLang]["remember"],
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Theme(
              data: ThemeData(
                primaryColor: const Color.fromRGBO(78, 211, 255, 1),
                colorScheme: const ColorScheme(
                  brightness: Brightness.light,
                  primary: Color.fromRGBO(78, 211, 255, 1),
                  onPrimary: Color.fromRGBO(78, 211, 255, 1),
                  secondary: Color.fromRGBO(78, 211, 255, 1),
                  onSecondary: Color.fromRGBO(78, 211, 255, 1),
                  error: Color.fromRGBO(78, 211, 255, 1),
                  onError: Color.fromRGBO(78, 211, 255, 1),
                  surface: Color.fromRGBO(78, 211, 255, 1),
                  onSurface: Color.fromRGBO(78, 211, 255, 1),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 5, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: const Color.fromRGBO(78, 211, 255, 1),
                        focusColor: const Color.fromRGBO(78, 211, 255, 1),
                        overlayColor: const WidgetStatePropertyAll(
                          Color.fromRGBO(78, 211, 255, 1),
                        ),
                        hoverColor: const Color.fromRGBO(78, 211, 255, 1),
                        // fillColor: WidgetStatePropertyAll(const Color.fromRGBO(78, 211, 255, 1)),
                        value: Provider.of<SharedData>(context).remember,
                        onChanged: null,
                      ),
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
