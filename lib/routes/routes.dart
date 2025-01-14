import 'package:flutter/material.dart';
import 'package:trivi_app/screens/premium_screen.dart';
import 'package:trivi_app/screens/screens.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    'main': (context) {
      return MainScreen(
        builderContext: context,
      );
    },
    'login': (_) => LoginScreen(
          buildContext: _,
        ),
    'premium': (_) => PremiumScreen(
          buildContext: _,
        ),
    'loading': (_) => LoadingScreen(
          buildContext: _,
        ),
  };
}
