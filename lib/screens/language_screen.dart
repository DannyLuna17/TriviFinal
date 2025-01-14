import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/widgets/lang_button_widget.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<List<dynamic>> langs = [
      ["es", "Español", 0],
      ["en", "English", 1],
      ["pt", "Português", 2],
      ["fr", "Français", 3],
      ["de", "Deutsch", 4],
      ["it", "Italiano", 5],
      ["ru", "Русский", 6],
      ["tr", "Türkçe", 7],
      ["nl", "Nederlands", 8]
    ];
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    final providerWith = Provider.of<SharedData>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (providerWithout.vibration)
                        Helpers.vibrate(HapticsType.selection);

                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, left: 5),
                      child: const Icon(
                        Icons.close_outlined,
                        size: 45,
                        color: Color.fromRGBO(195, 195, 195, 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      providerWith.texts[providerWith.appLang]["language"],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (providerWithout.vibration)
                        Helpers.vibrate(HapticsType.selection);

                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, left: 5),
                      child: const Icon(
                        Icons.close_outlined,
                        size: 45,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      providerWith.texts[providerWith.appLang]
                          ["choose_language"],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              for (List lang in langs)
                Container(
                    margin: const EdgeInsets.only(top: 2.5),
                    child: LangButtonWidget(
                        name: lang[1], code: lang[0], index: lang[2])),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
