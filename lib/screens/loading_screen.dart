import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/screens/login_screen.dart';
import 'package:trivi_app/screens/questions_screen.dart';
import 'package:dio/dio.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, required this.buildContext});

  final BuildContext buildContext;
  @override
  Widget build(BuildContext context) {
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    if (!providerWithout.loaded && !providerWithout.loading) {
      providerWithout.setLoading(true);

      Future.delayed(const Duration(milliseconds: 1), () async {
        providerWithoutListen.setAnswer(0);
        final filename =
            providerWithoutListen.selectedFilename.replaceAll(RegExp(' '), "_");
        String extraInfo = '';
        print(filename);
        if (filename != "") {
          final rs = await Dio().get<List<int>>(
            "https://dannyluna17.pythonanywhere.com/trivi/getfile/$filename",
            options: Options(
              responseType: ResponseType.bytes,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${providerWithoutListen.jwt}",
              },
            ),
          );

          final fileBytes = rs.data;

          final document = PdfDocument(inputBytes: fileBytes);

          extraInfo = PdfTextExtractor(document).extractText();
          document.dispose();
        }
        final quantity = providerWithoutListen.nPreg;
        final topic = providerWithoutListen.topicSelected;
        final instrucciones = providerWithoutListen.instrucciones;
        final language = providerWithoutListen.selectedLang;
        final difficulty = providerWithoutListen.diffSelected == 0
            ? providerWith.texts[providerWith.appLang]["difficultyEasy"]
            : providerWithoutListen.diffSelected == 1
                ? providerWith.texts[providerWith.appLang]["difficultyMedium"]
                : providerWith.texts[providerWith.appLang]["difficultyHard"];

        final response2 = await http.get(
          Uri.parse(
            'https://dannyluna17.pythonanywhere.com/keys',
          ),
          headers: {
            'accept': 'application/json',
          },
        );

        final keys = jsonDecode(response2.body)['keys'] as List<dynamic>;
        var randomKey = keys[Random().nextInt(keys.length)];
        print(randomKey);

        final prompt =
            '''You are a trivia question creator. If it is provided you must write the questions based on user base information and instructions/indications. You must respond ONLY with a VALID JSON structure following the format below. Do not include any additional text. If necessary, you can respond in any language.

**Example:**
{
  "questions": [
    {
      "question": "What is the first number in the Fibonacci sequence?",
      "options": ["1", "2", "3", "4"],
      "answer": "0", // Answer´s index (starts in 0)
      "explanation": "A brief explanation of the answer as feedback."
    }
    // Additional questions follow the same format.
  ]
}

**Additional Information:**
{
  "total_questions": $quantity,
  "topic": "$topic",
  "language": "$language",
  "difficulty": "$difficulty",
  "base_information": "$extraInfo",
  "user_indications": "$instrucciones"
}

**IMPORTANT:** THE RESPONSE MUST BE ONLY A VALID JSON WITHOUT ANY COMMENTS OR ADDITIONAL TEXT.

''';

        final payload = {
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'model': providerWithout.model == 0
              ? providerWithout.models[0] as String
              : providerWithout.models[1] as String,
        };
        final headers = {
          'Authorization': 'Bearer $randomKey',
          'Content-Type': 'application/json',
        };

        print("hola");

        final attempts = providerWithout.attempts;

        while (attempts < 10) {
          try {
            providerWithout.setAttempts(attempts + 1);
            final response = await http.post(
              Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
              headers: headers,
              body: jsonEncode(payload),
            );

            print(response.body);

            final jsonResponse = jsonDecode(
              // ignore: avoid_dynamic_calls
              jsonDecode(response.body)['choices'][0]['message']['content']
                  .toString()
                  .replaceAll('Ã¡', 'á')
                  .replaceAll('Ã³', 'ó')
                  .replaceAll('Ã­', 'í')
                  .replaceAll('Ã±', 'ñ')
                  .replaceAll('Ã¨', 'é')
                  .replaceAll('Ã©', 'é')
                  .replaceAll('Ã§', 'ç')
                  .replaceAll('Ãº', 'ú')
                  .replaceAll('Ã¸', 'ü')
                  .replaceAll('Â', '')
                  .replaceAll('Ã¶', 'ö'),
            ) as Map<String, dynamic>;
            print(jsonResponse);

            // ignore: use_build_context_synchronously
            providerWithoutListen.setQuestionsAndAnswers(jsonResponse);
            providerWithoutListen.stopWatchTimer.onStartTimer();
            providerWithoutListen.setCorrectAnswers(0);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return QuestionsScreen(buildContext: context);
            }));
            providerWithout.setAttempts(11);
            break;
          } catch (e) {
            providerWithout.setLoading(false);
            randomKey = keys[Random().nextInt(keys.length)];
            print(randomKey);
            print(e);
            Navigator.of(context).pushReplacement(
                Helpers.createRoute(LoginScreen(buildContext: context)));
          }
        }
      });
    }
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  if (providerWithout.vibration)
                    Helpers.vibrate(HapticsType.selection);

                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: const Icon(
                    Icons.close_outlined,
                    size: 45,
                    color: Color.fromRGBO(195, 195, 195, 1),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: DelayedWidget(
              delayDuration: const Duration(milliseconds: 200),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 65,
                    width: 65,
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(78, 211, 255, 1),
                      strokeWidth: 8.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    providerWith.texts[providerWith.appLang]["loading"],
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
