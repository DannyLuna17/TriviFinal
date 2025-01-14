import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';

class AnswerButtonWidget extends StatefulWidget {
  const AnswerButtonWidget({
    required this.label,
    required this.id,
    super.key,
  });

  final String label;
  final int id;

  @override
  State<AnswerButtonWidget> createState() => _AnswerButtonWidgetState();
}

class _AnswerButtonWidgetState extends State<AnswerButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final isDown = Provider.of<SharedData>(context).selectedAnswer == widget.id;
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    return GestureDetector(
      onTap: () async {
                                    if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

        try {
          providerWithout.flutterTts.speak(widget.label);
        } catch (error) {
          print(error);
        }
        if (Provider.of<SharedData>(context, listen: false).selectedAnswer !=
            widget.id) {
                                      if (providerWithout.vibration) Helpers.vibrate(HapticsType.success);

          Provider.of<SharedData>(context, listen: false).setAnswer(widget.id);
        } else {
          Provider.of<SharedData>(context, listen: false).setAnswer(0);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 27.5, vertical: 5),
        decoration: BoxDecoration(
          color: isDown
              ? const Color.fromARGB(255, 137, 226, 255)
              : Provider.of<SharedData>(context).nightMode
                  ? Colors.black
                  : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border(
            bottom: BorderSide(
              color: isDown
                  ? const Color.fromRGBO(206, 206, 206, 1)
                  : const Color.fromRGBO(229, 229, 229, 1),
              width: isDown ? 2 : 4,
            ),
            top: BorderSide(
              color: isDown
                  ? const Color.fromRGBO(206, 206, 206, 1)
                  : const Color.fromRGBO(229, 229, 229, 1),
              width: 2,
            ),
            right: BorderSide(
              color: isDown
                  ? const Color.fromRGBO(206, 206, 206, 1)
                  : const Color.fromRGBO(229, 229, 229, 1),
              width: 2,
            ),
            left: BorderSide(
              color: isDown
                  ? const Color.fromRGBO(206, 206, 206, 1)
                  : const Color.fromRGBO(229, 229, 229, 1),
              width: 2,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(11),
          margin: EdgeInsets.only(top: isDown ? 4 : 0),
          child: Center(
            child: Text.rich(
              TextSpan(
                text: widget.label,
                children: [
                  WidgetSpan(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.volume_up_sharp,
                        size: 30,
                        color: isDown
                            ? const Color.fromRGBO(60, 60, 60, 1)
                            : const Color.fromRGBO(78, 211, 255, 1),
                      ),
                    ),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 23.5,
                color: Color.fromRGBO(60, 60, 60, 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
