import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';

class LangButtonWidget extends StatefulWidget {
  const LangButtonWidget({
    required this.name,
    required this.code,
    required this.index,
    super.key,
  });

  final String name;
  final String code;
  final int index;

  @override
  State<LangButtonWidget> createState() => _LangButtonWidgetState();
}

class _LangButtonWidgetState extends State<LangButtonWidget> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    final providerWithout = Provider.of<SharedData>(context, listen: false);
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

    return GestureDetector(
      onTap: () async {
        if (providerWithout.vibration) Helpers.vibrate(HapticsType.success);

        providerWithout.setAppLang(langs[widget.index][0]);
        Hive.box<String>("appLangBox").put("appLang", langs[widget.index][0]);

        Navigator.pop(context);
      },
      onPanDown: (details) {
        setState(() {
          isDown = !isDown;
        });
      },
      onPanEnd: (details) {
        setState(() {
          isDown = !isDown;
        });
      },
      onPanCancel: () {
        setState(() {
          isDown = !isDown;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 27.5, vertical: 5),
        decoration: BoxDecoration(
          color: Provider.of<SharedData>(context).nightMode
              ? Colors.black
              : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border(
            bottom: BorderSide(
              color: const Color.fromRGBO(229, 229, 229, 1),
              width: isDown ? 2 : 5,
            ),
            top: const BorderSide(
              color: Color.fromRGBO(229, 229, 229, 1),
              width: 2,
            ),
            right: const BorderSide(
              color: Color.fromRGBO(229, 229, 229, 1),
              width: 2,
            ),
            left: const BorderSide(
              color: Color.fromRGBO(229, 229, 229, 1),
              width: 2,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(11),
          margin: const EdgeInsets.only(top: 0),
          child: Center(
            child: Container(
                padding: EdgeInsets.only(
                  top: isDown ? 8.5 : 4.5,
                  bottom: 4,
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: SvgPicture.asset(
                        "assets/${widget.code}.svg",
                        width: 30,
                        height: 36,
                        semanticsLabel: 'Language Logo',
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.name,
                      style: const TextStyle(fontSize: 22),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
