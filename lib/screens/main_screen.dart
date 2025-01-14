import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/pages/pages.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:delayed_widget/delayed_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.builderContext});

  final BuildContext builderContext;

  @override
  Widget build(BuildContext context) {
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    final providerWith = Provider.of<SharedData>(context);
    if (providerWithout.isFirst) {
      Provider.of<SharedData>(context, listen: false).setCurrentPage(HomePage(
        buildContext: context,
      ));
      Provider.of<SharedData>(context, listen: false).setFirst(false);
      Hive.box<bool>("isFirstBox").put("isFirst", false);
    }
    return Scaffold(
      extendBody: true,
      body: Provider.of<SharedData>(context).currentPage,
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(78, 211, 255, 1),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        notchMargin: 5,
        shape: const CircularNotchedRectangle(),
        child: DelayedWidget(
          delayDuration: const Duration(milliseconds: 300),
          animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: IconButton(
                  onPressed: () {
                    if (providerWithout.vibration)
                      Helpers.vibrate(HapticsType.selection);

                    if (providerWithout.jwt != "") Helpers.getUserInfo(context);

                    providerWithout
                        .setCurrentPage(HomePage(buildContext: builderContext));
                  },
                  icon: Icon(
                    Icons.home,
                    size: 40,
                    color: Provider.of<SharedData>(context).nightMode
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 75),
                child: IconButton(
                  onPressed: () {
                    if (providerWithout.vibration)
                      Helpers.vibrate(HapticsType.selection);

                    providerWithout
                      ..toggleLeaderLoaded()
                      ..setCurrentPage(const LeaderboardPage());
                  },
                  icon: Icon(
                    Icons.leaderboard_rounded,
                    size: 40,
                    color: Provider.of<SharedData>(context).nightMode
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (providerWithout.vibration)
                    Helpers.vibrate(HapticsType.selection);

                  providerWithout.setCurrentPage(
                    ProfilePage(
                      buildContext: context,
                    ),
                  );
                },
                icon: Icon(
                  Icons.person,
                  size: 40,
                  color: Provider.of<SharedData>(context).nightMode
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (providerWithout.vibration)
                    Helpers.vibrate(HapticsType.selection);

                  providerWithout.setCurrentPage(const ConfigurationPage());
                },
                icon: Icon(
                  Icons.settings_outlined,
                  size: 40,
                  color: Provider.of<SharedData>(context).nightMode
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: providerWith.snackShown
          ? null
          : DelayedWidget(
              delayDuration: const Duration(milliseconds: 500),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(78, 211, 255, 1),
                shape: CircleBorder(
                  side: BorderSide(
                    color: Provider.of<SharedData>(context).nightMode
                        ? Colors.black
                        : Colors.white,
                    width: 5,
                  ),
                ),
                onPressed: () {
                  if (providerWithout.jwt == "") {
                    if (providerWithout.vibration)
                      Helpers.vibrate(HapticsType.selection);

                    providerWithout.setCurrentPage(
                      ProfilePage(
                        buildContext: context,
                      ),
                    );
                  } else {
                    if (providerWithout.vibration)
                      Helpers.vibrate(HapticsType.success);

                    providerWithout.setCurrentPage(HomePage(
                      buildContext: builderContext,
                    ));
                    Future.delayed(const Duration(milliseconds: 100), () {
                      providerWithout.setUploadedFiles([]);
                      // ignore: use_build_context_synchronously
                      PopUps.addPoUp(context);
                    });
                  }
                },
                elevation: 0,
                child: Icon(
                  Icons.add,
                  size: 45,
                  color: Provider.of<SharedData>(context).nightMode
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
