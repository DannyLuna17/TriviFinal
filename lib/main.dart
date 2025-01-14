import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/routes/routes.dart';
import 'package:trivi_app/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura la inicialización de los bindings

  await Hive.initFlutter(); // trtttt

  await Hive.openBox<bool>("nightBox");
  await Hive.openBox<String>('userBox');
  await Hive.openBox<String>('jwtBox');
  await Hive.openBox<String>("tokenBox");
  await Hive.openBox<int>("starsBox");
  await Hive.openBox<int>("streakBox");
  await Hive.openBox<int>("dateBox");
  await Hive.openBox<int>("livesBox");
  await Hive.openBox<List<Widget>>("topicsBox");
  await Hive.openBox<dynamic>("lostBox");
  await Hive.openBox<String>("appIdBox");
  await Hive.openBox<String>("appLangBox");
  await Hive.openBox<bool>("isFirstBox");
  await Hive.openBox<bool>("soundBox");
  await Hive.openBox<bool>("vibrationBox");

  await initPlatformState();

  String texts = await rootBundle.loadString('assets/texts.json');
  Map<String, dynamic> textsJson = jsonDecode(texts);

  SharedData sharedData = SharedData();
  if (sharedData.isFirst) {
    String lang = (await Devicelocale.currentLocale ?? "en").substring(0, 2);
    final langs = ["de", "en", "es", "fr", "it", "nl", "pt", "ru", "tr"];

    if (langs.contains(lang)) {
      sharedData.setAppLang(lang);
    }else{
      sharedData.setAppLang("en");
    }
    Hive.box<String>("appLangBox").put("appLang", lang);
  }
  sharedData.setTexts(textsJson);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SharedData>.value(value: sharedData),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initPlatformState() async {
  if (!kIsWeb) {
    Appodeal.initialize(
      appKey: "6482478619404c1cf263300ecb5a8c2fcf08b34c0252dec3",
      adTypes: [
        AppodealAdType.Interstitial,
        AppodealAdType.RewardedVideo,
      ],
      onInitializationFinished: print,
    );
    Appodeal.setLogLevel(Appodeal.LogLevelVerbose);
    Appodeal.setAutoCache(AppodealAdType.All, true);
    Appodeal.setAdRevenueCallbacks(
      onAdRevenueReceive: print,
    );

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration("goog_HCTxZeYhtOXpHPdxVGLyotTXRHT")
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
      await Purchases.configure(configuration);
    } else if (Platform.isIOS) {
      // Configuración para iOS si es necesario
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Precarga de imágenes
    precacheImage(const AssetImage('assets/logoText.png'), context);
    final langs = ["de", "en", "es", "fr", "it", "nl", "pt", "ru", "tr"];
    for (final lang in langs) {
      final loader = SvgAssetLoader('assets/$lang.svg');
      svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }

    return ToastificationWrapper(
      child: Consumer<SharedData>(
        builder: (context, sharedData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Trivi App',
            routes: Routes.routes,
            initialRoute: "main",
            theme:
                sharedData.nightMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          );
        },
      ),
    );
  }
}
