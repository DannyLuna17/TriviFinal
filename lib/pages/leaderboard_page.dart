import 'package:delayed_widget/delayed_widget.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/providers/shared_data.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
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

    if (!providerWithoutListen.leaderLoaded &&
        !providerWithoutListen.leaderLoading) {
      providerWithoutListen.toggleLeaderLoading();
      Future.delayed(const Duration(microseconds: 1), () async {
        final response = await http.get(
          Uri.parse(
            'https://dannyluna17.pythonanywhere.com/trivi/leaderboard/',
          ),
        );
        print(jsonDecode(response.body));

        final users = jsonDecode(response.body)['data'] as List;

        final leaderboardItems = [
          for (final List user in users)
            _LeaderboardItemWidget(
              userName: user[0].toString(),
              userScore: user[1].toString(),
              position:
                  (users.indexWhere((userInfo) => userInfo[0] == user[0]) + 1)
                      .toString(),
            ),
        ];
        providerWithoutListen
          ..toggleLeaderLoaded()
          ..setLeaderboardItems(leaderboardItems);
      });
      providerWithoutListen.toggleLeaderLoading();
    }

    // Definir una base de duración para los retrasos
    const baseDelay = Duration(milliseconds: 200);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Título de Leaderboard: SLIDE_FROM_TOP
            _maybeAnimate(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  providerWith.texts != null
                      ? providerWith.texts[providerWith.appLang]["leaderboard"]
                      : "Loading...",
                  style: const TextStyle(fontSize: 25.5, fontFamily: 'Fredoka'),
                ),
              ),
              animation: DelayedAnimations.SLIDE_FROM_TOP,
              delay: baseDelay,
            ),

            const Divider(),

            // 2. Contenedor de Loader o Leaderboard Items
            _maybeAnimate(
              child: providerWith.leaderLoaded
                  ? Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children:
                              Provider.of<SharedData>(context).leaderboardItems,
                        ),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Ocupa todo el ancho de la pantalla
                        height: MediaQuery.of(context).size.height * 0.88,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: const CircularProgressIndicator(
                                color: Color.fromRGBO(78, 211, 255, 1),
                                strokeWidth: 9.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              animation: DelayedAnimations.SLIDE_FROM_LEFT,
              delay: baseDelay + const Duration(milliseconds: 100),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardItemWidget extends StatelessWidget {
  const _LeaderboardItemWidget({
    required this.userName,
    required this.userScore,
    required this.position,
  });

  final String userName;
  final String userScore;
  final String position;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color.fromRGBO(100, 216, 255, 1),
      const Color.fromRGBO(255, 100, 216, 1),
      const Color.fromRGBO(216, 255, 100, 1),
      const Color.fromRGBO(216, 100, 255, 1),
      const Color.fromRGBO(255, 216, 100, 1),
      const Color.fromRGBO(100, 255, 216, 1),
    ];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Row(
            children: [
              Text(
                position,
                style: const TextStyle(
                  fontSize: 35,
                  fontFamily: 'Fredoka',
                  color: Color.fromRGBO(100, 216, 255, 1),
                ),
              ),
              const SizedBox(width: 20),
              CircleAvatar(
                backgroundColor: colors[Random().nextInt(colors.length)],
                child: Text(
                  userName[0],
                  style: TextStyle(
                    fontSize: 24,
                    color: Provider.of<SharedData>(context).nightMode
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'FredokaRegular',
                  color: Color.fromRGBO(100, 216, 255, 1),
                ),
              ),
              const Spacer(),
              const Icon(
                FlutterIcons.star_ant,
                color: Colors.amber,
              ),
              const SizedBox(width: 3),
              Text(
                userScore,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'FredokaRegular',
                  color: Color.fromRGBO(100, 216, 255, 1),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
