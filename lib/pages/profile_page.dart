import 'package:delayed_widget/delayed_widget.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/widgets/custom_box_widget.dart';
import 'package:trivi_app/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.buildContext});

  final BuildContext buildContext;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker picker = ImagePicker();
  final Dio dio = Dio();

  // Variable estática para rastrear si las animaciones ya se han reproducido
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

    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false); // chaleBola

    if (providerWithoutListen.profileBase64 == '' &&
        providerWithoutListen.checked == false) {
      Future.delayed(const Duration(milliseconds: 100), () async {
        if (providerWithoutListen.jwt != "") {
          Response response;
          providerWithoutListen.toggleChecked();
          while (true) {
            try {
              response = await dio.get(
                'https://dannyluna17.pythonanywhere.com/trivi/getprofilepicture',
                options: Options(
                  responseType: ResponseType.json,
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${providerWithoutListen.jwt}',
                  },
                ),
              );
              break;
            } catch (e) {
              print(e);
              providerWithoutListen.setprofileBase64('');
            }
          }
          print(response.data);
          final jsonBody = response.data;
          if (response.statusCode == 200) {
            final base64img = jsonBody['base64img'];
            print(base64img);
            if (jsonBody.toString().contains('not found') ||
                base64img.toString().contains('Bad Request')) {
              // ignore: use_build_context_synchronously
              providerWithoutListen.setprofileBase64('');
            } else {
              // ignore: use_build_context_synchronously
              providerWithoutListen.setprofileBase64(base64img.toString());
            }
          }
        } else {
          providerWithoutListen.setprofileBase64('');
        }
        // ignore: use_build_context_synchronously
      });
    }

    if (Provider.of<SharedData>(context, listen: false).topicsBoxes.length ==
            1 ||
        Provider.of<SharedData>(context, listen: false)
                .realTopicsBoxes
                .length ==
            1) {
      Helpers.addDefaultTopics(context);
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
    final providerWith = Provider.of<SharedData>(context);
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);

    return providerWithoutListen.jwt == ''
        ? LoginPage(
            buildContext: widget.buildContext,
          )
        : SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // 1. Título de Perfil con Animación
                  _maybeAnimate(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        providerWith.texts != null
                            ? providerWith.texts[providerWith.appLang]
                                ["profileTitle"]
                            : "Loading...",
                        style: const TextStyle(
                            fontSize: 25.5, fontFamily: 'Fredoka'),
                      ),
                    ),
                    animation: DelayedAnimations.SLIDE_FROM_TOP,
                    delay: const Duration(milliseconds: 0),
                  ),
                  const Divider(),

                  // 2. Avatar con Animación
                  _maybeAnimate(
                    child: TapScaleAnimation(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (providerWithoutListen.vibration)
                              Helpers.vibrate(HapticsType.selection);

                            PopUps.profileDialog(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Provider.of<SharedData>(context)
                                        .nightMode
                                    ? Colors.white30
                                    : const Color.fromARGB(255, 231, 226, 226),
                                width: 5,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage: providerWith.profileBase64 != ''
                                  ? MemoryImage(
                                      base64Decode(
                                        providerWith.profileBase64,
                                      ),
                                    )
                                  : null,
                              radius: 65,
                              backgroundColor:
                                  const Color.fromRGBO(100, 216, 255, 1),
                              child: Stack(
                                children: [
                                  Align(
                                    child: providerWith.profileBase64 != ''
                                        ? Container()
                                        : providerWith.checked == true
                                            ? Text(
                                                providerWith.user[0],
                                                style: TextStyle(
                                                  fontSize: 70,
                                                  color: providerWith.nightMode
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                              )
                                            : const CircularProgressIndicator(
                                                color: Color.fromRGBO(
                                                    189, 239, 255, 1),
                                                strokeWidth: 8.5,
                                              ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (providerWithoutListen.vibration)
                                          Helpers.vibrate(
                                              HapticsType.selection);

                                        final pickedFile =
                                            await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );

                                        if (pickedFile != null) {
                                          final base64img = base64Encode(
                                            await pickedFile.readAsBytes(),
                                          );
                                          // ignore: use_build_context_synchronously
                                          providerWithoutListen
                                              .setprofileBase64(base64img);
                                          // ignore: use_build_context_synchronously
                                          Response? resp;
                                          resp = await dio.post(
                                            'https://dannyluna17.pythonanywhere.com/trivi/updateuser',
                                            data: {
                                              'base64Data': base64img,
                                              // ignore: use_build_context_synchronously
                                            },
                                            options: Options(
                                              headers: {
                                                'Content-Type':
                                                    'application/json',
                                                'Authorization':
                                                    'Bearer ${providerWithoutListen.jwt}',
                                              },
                                              responseType: ResponseType.json,
                                            ),
                                          );
                                          print(resp.data);
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: providerWith.nightMode
                                              ? Colors.black
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: providerWith.nightMode
                                                ? Colors.white60
                                                : Colors.black26,
                                            width: 3,
                                          ),
                                        ),
                                        child: const Icon(
                                          FlutterIcons.pen_faw5s,
                                          size: 20.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    animation: DelayedAnimations.SLIDE_FROM_LEFT,
                    delay: const Duration(milliseconds: 100),
                  ),

                  // 3. Nombre de Usuario con Animación
                  _maybeAnimate(
                    child: Text(
                      providerWith.user,
                      style:
                          const TextStyle(fontSize: 35, fontFamily: 'Fredoka'),
                    ),
                    animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                    delay: const Duration(milliseconds: 200),
                  ),

                  // 4. Fecha de Registro con Animación
                  _maybeAnimate(
                    child: Text(
                      '${providerWith.texts != null ? providerWith.texts[providerWith.appLang]["joinedDate"] : "Loading..."} '
                      '${DateTime.fromMicrosecondsSinceEpoch(providerWith.date).toString().substring(0, 10)}',
                    ),
                    animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                    delay: const Duration(milliseconds: 300),
                  ),

                  const Divider(),

                  // 5. Sección de Estadísticas con Animación
                  _maybeAnimate(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            providerWith.texts != null
                                ? providerWith.texts[providerWith.appLang]
                                    ["stats"]
                                : "Loading...",
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Fredoka',
                              color: Color.fromRGBO(206, 206, 206, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    animation: DelayedAnimations.SLIDE_FROM_LEFT,
                    delay: const Duration(milliseconds: 400),
                  ),

                  // 6. Estadísticas Detalladas con Animación
                  _maybeAnimate(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TapScaleAnimation(
                                onTap: () {},
                                child: CustomBoxWidget(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        FlutterIcons.fire_alt_faw5s,
                                        color: Color.fromRGBO(255, 150, 0, 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          '${providerWith.texts != null ? providerWith.texts[providerWith.appLang]["streak"] : "Loading..."} '
                                          '${providerWith.streak}',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Fredoka',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TapScaleAnimation(
                                onTap: () {},
                                child: CustomBoxWidget(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        FlutterIcons.star_ant,
                                        color: Colors.amber,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          '${providerWith.texts != null ? providerWith.texts[providerWith.appLang]["stars"] : "Loading..."} '
                                          '${providerWith.stars}',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Fredoka',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TapScaleAnimation(
                                onTap: () {},
                                child: CustomBoxWidget(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        FlutterIcons.heart_ant,
                                        color: Color.fromRGBO(255, 75, 75, 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          '${providerWith.texts != null ? providerWith.texts[providerWith.appLang]["lives"] : "Loading..."} '
                                          '${providerWith.lives}',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Fredoka',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    animation: DelayedAnimations.SLIDE_FROM_LEFT,
                    delay: const Duration(milliseconds: 500),
                  ),
                ],
              ),
            ),
          );
  }
}
