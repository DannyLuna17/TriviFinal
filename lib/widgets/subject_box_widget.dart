import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/pages/pages.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/widgets/widgets.dart';

class SubjectBoxWidget extends StatelessWidget {
  const SubjectBoxWidget({
    required this.topicName,
    required this.emoji,
    required this.instrucciones,
    required this.filename,
    required this.language,
    this.buildContext,
    super.key,
  });

  final BuildContext? buildContext;
  final String topicName;
  final String emoji;
  final String instrucciones;
  final String filename;
  final String language;

  @override
  Widget build(BuildContext context) {
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);
    final providerWith = Provider.of<SharedData>(context);

    return GestureDetector(
      onTap: () {
        if (providerWithoutListen.jwt == "") {
          if (providerWithoutListen.vibration)
            Helpers.vibrate(HapticsType.selection);

          providerWithoutListen.setCurrentPage(
            ProfilePage(
              buildContext: buildContext!,
            ),
          );

          toastification.show(
            icon: const Icon(
              // info_circle_faw info_circle_faw5s   info_oct
              FlutterIcons.info_oct,
              size: 45,
            ),
            type: ToastificationType.info,
            style: ToastificationStyle.minimal,
            title: Text(
              providerWithoutListen.texts != null
                  ? providerWithoutListen.texts[providerWithoutListen.appLang]
                      ["loginAdvice"]
                  : "Loading...",
              style: const TextStyle(fontSize: 15),
            ),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 4),
          );

          //TODO: SHOW LOGIN POPUP
        } else {
          if (providerWithoutListen.lives <= 0) {
            toastification.show(
              icon: const Icon(
                Icons.error_outline_outlined,
                size: 35,
              ),
              type: ToastificationType.error,
              style: ToastificationStyle.minimal,
              title: Text(
                providerWithoutListen.texts != null
                    ? providerWithoutListen.texts[providerWithoutListen.appLang]
                        ["insufficient_lives"]
                    : "Loading...",
                style: const TextStyle(fontSize: 18),
              ),
              alignment: Alignment.topCenter,
              autoCloseDuration: const Duration(seconds: 4),
            );
            PopUps.livesPopup(context);
          } else {
            if (providerWithoutListen.vibration)
              Helpers.vibrate(HapticsType.selection);

            PopUps.topicPoUp(context);
            Provider.of<SharedData>(context, listen: false).setTopic(topicName);
            Provider.of<SharedData>(context, listen: false)
                .setInstrucciones(instrucciones);
            Provider.of<SharedData>(context, listen: false)
                .setSelectedFilename(filename);
          }
        }
      },
      child: GridBoxWidget(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 2),
              child: Align(
                alignment: Alignment.topRight,
                child: CustomPopup(
                  onBeforePopup: () {
                    providerWithoutListen.setConfirm(false);
                    providerWithoutListen.setDeleting(false);
                  },
                  arrowColor: const Color.fromRGBO(229, 229, 229, 1),
                  barrierColor: Colors.transparent,
                  contentDecoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(17.5)),
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(229, 229, 229, 1),
                        width: 5,
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
                    color: Colors.white,
                  ),
                  content: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);

                            providerWithoutListen.setHint(false);

                            if (providerWithoutListen.jwt != "") {
                              print(filename);

                              if (filename != "") {
                                providerWithoutListen.setUploaded(true);
                                print("UPLOADEDD");
                              }

                              PopUps.editPopup(
                                context,
                                topicName,
                                instrucciones,
                                filename,
                                language,
                                emoji,
                              );
                            } else {
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

                              if (providerWithoutListen.vibration)
                                Helpers.vibrate(HapticsType.selection);

                              providerWithoutListen.setCurrentPage(
                                ProfilePage(
                                  buildContext: buildContext!,
                                ),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                FlutterIcons.edit_2_fea,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Text(
                                  providerWith.texts != null
                                      ? providerWith.texts[providerWith.appLang]
                                          ["edit"]
                                      : "Loading...",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (providerWithoutListen.jwt != "") {
                              if (providerWithoutListen.toConfirm == false) {
                                if (providerWithoutListen.vibration)
                                  Helpers.vibrate(HapticsType.success);

                                providerWithoutListen.setConfirm(true);
                                print("CONFIMRANDO");
                              } else {
                                if (providerWithoutListen.vibration)
                                  Helpers.vibrate(HapticsType.selection);

                                providerWithoutListen
                                  ..setConfirm(false)
                                  ..setDeleting(true);

                                await Helpers.deleteTopic(context, topicName);
                                providerWithoutListen.setDeleting(false);
                                Navigator.pop(context);

                                await Helpers.getUserInfo(context);
                              }
                            } else {
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
                              providerWithoutListen
                                ..setConfirm(false)
                                ..setDeleting(true);
                              providerWithoutListen.popTopics();
                              Navigator.pop(context);
                              providerWithoutListen.setDeleting(false);
                              providerWithoutListen.setCurrentPage(
                                ProfilePage(
                                  buildContext: buildContext!,
                                ),
                              );
                            }
                          },
                          child: DeleteWidget(context: buildContext!),
                        ),
                      ],
                    ),
                  ),
                  child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(FlutterIcons.kebab_vertical_oct)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      topicName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(emoji, style: const TextStyle(fontSize: 30)),
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

class DeleteWidget extends StatelessWidget {
  const DeleteWidget({
    required this.context,
    super.key,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);

    final borrarList = [
      const Icon(
        FlutterIcons.delete_mco,
        color: Color.fromRGBO(255, 75, 75, 1),
      ),
      Container(
        margin: const EdgeInsets.only(left: 5),
        child: Text(
          providerWith.texts != null
              ? providerWith.texts[providerWith.appLang]["delete"]
              : "Loading...",
          style: const TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(255, 75, 75, 1),
          ),
        ),
      ),
    ];

    final confirmarList = [
      Text(
        providerWith.texts != null
            ? providerWith.texts[providerWith.appLang]["confirm"]
            : "Loading...",
        style: const TextStyle(
          fontSize: 18,
          color: Color.fromRGBO(255, 75, 75, 1),
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: providerWith.deleting
          ? [
              const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(78, 211, 255, 1),
                    strokeWidth: 5,
                  ),
                ),
              ),
            ]
          : providerWith.toConfirm
              ? confirmarList
              : borrarList,
    );
  }
}
