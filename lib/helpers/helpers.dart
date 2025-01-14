import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dioP;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';

class Helpers {
  static Route createRoute(Widget screen,
      {Offset begin = const Offset(1.0, 0.0),
      Offset end = const Offset(0.0, 0.0)}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static Future<Map<String, dynamic>> getUserInfo(BuildContext context) async {
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    try {
      final resp = await http.get(
        Uri.parse(
          'https://dannyluna17.pythonanywhere.com/trivi/version',
        ),
        headers: {
          "Content-Type": "application/json",
        },
      );
      final currentV = jsonDecode(resp.body)["version"];
      if (packageInfo.version != currentV) {
        PopUps.updatePopUp(context);
        return {"success": false};
      }
    } on ClientException catch (_) {
      toastification.show(
        icon: const Icon(
          Icons.error_outline_outlined,
          size: 35,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
        title: Text(
          "${providerWithoutListen.texts[providerWithoutListen.appLang]["request_error"]} ${_.toString()}",
          style: const TextStyle(fontSize: 10),
        ),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
      );
    }

    Response? resp;

    providerWithoutListen.setGetting(true);

    try {
      resp = await http.get(
        Uri.parse(
          'https://dannyluna17.pythonanywhere.com/trivi/user',
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${providerWithoutListen.jwt}",
        },
      );
      print("REESPUESTA A POST");
      print(jsonDecode(resp.body));
      final newLives = jsonDecode(resp.body)["lives"] as int;
      providerWithoutListen.setlives(newLives);
      unawaited(Hive.box<int>('livesBox').put('lives', newLives));

      final newStars = jsonDecode(resp.body)["stars"] as int;
      providerWithoutListen.setStars(newStars);
      unawaited(Hive.box<int>('starsBox').put('stars', newStars));

      final streak = jsonDecode(resp.body)["streak"] as int;
      providerWithoutListen.setStreak(streak);
      unawaited(Hive.box<int>('streakBox').put('streak', streak));

      final lostDate =
          DateTime.parse(jsonDecode(resp.body)["lost_date"] as String);
      providerWithoutListen.setLostDate(lostDate);
      unawaited(Hive.box<dynamic>('lostBox').put('lost_date', lostDate));

      final models = jsonDecode(resp.body)["models"] as List;
      providerWithoutListen.setModels(models);

      final topics = jsonDecode(resp.body)["topics"] as List;
      providerWithoutListen.resetTopics();
      for (List<dynamic> topic in topics) {
        providerWithoutListen.addTopic(
            topic[0] as String,
            topic[1] as String,
            topic[2] as String,
            topic[3] as String,
            topic[4] as String,
            context);
      }

      if (providerWithoutListen.topicsBoxes.length == 1 ||
          providerWithoutListen.realTopicsBoxes.length == 1) {
        await Helpers.addDefaultTopics(context);
      }

      if (!kIsWeb) {
        final customerInfo = await Purchases.getCustomerInfo();

        if (customerInfo.entitlements.all["Premium2"]!.isActive) {
          providerWithoutListen.setPremium(true);
        } else {
          providerWithoutListen.setPremium(false);
        }
      } else {
        if (jsonDecode(resp.body)["premium"] == 1) {
          providerWithoutListen.setPremium(true);
        } else {
          providerWithoutListen.setPremium(false);
        }
      }

      dioP.Response<dynamic> response2;
      providerWithoutListen.toggleChecked();
      while (true) {
        try {
          final dio = dioP.Dio();
          response2 = await dio.get(
            'https://dannyluna17.pythonanywhere.com/trivi/getprofilepicture',
            options: dioP.Options(
              responseType: dioP.ResponseType.json,
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
      print(response2.data);
      final jsonBody = response2.data;
      if (response2.statusCode == 200) {
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

      // final premium = jsonDecode(resp.body)["premium"] as int;
      // providerWithoutListen.setPre(premium);
      // Hive.box<int>('premiumBox').put('premium', premium);

      providerWithoutListen.setGetting(false);
      return jsonDecode(resp.body);
    } on ClientException catch (_) {
      toastification.show(
        icon: const Icon(
          Icons.error_outline_outlined,
          size: 35,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
        title: Text(
          "${providerWithoutListen.texts[providerWithoutListen.appLang]["request_error"]} ${_.toString()}",
          style: const TextStyle(fontSize: 10),
        ),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
      );
      providerWithoutListen.setGetting(false);
      return {"success": false};
    }
  }

  static Future<void> addDefaultTopics(BuildContext context) async {
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    final defaultTopics = [
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_programacion_python"],
        '🐍'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_ingles_conversacional"],
        '🗣️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_anime_y_manga"],
        '🍣'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_historia_tecnologia"],
        '💡'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_fisica_cuantica"],
        '🔬'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_desarrollo_web"],
        '🌐'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_marketing_digital"],
        '📈'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_biologia_celular"],
        '🧬'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_algebra_lineal"],
        '📐'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_quimica_organica"],
        '⚗️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_historia_videojuegos"],
        '🕹️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_diseno_grafico"],
        '🎨'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_economia_principiantes"],
        '💰'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_historia_arte"],
        '🖼️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_literatura_latinoamericana"],
        '📖'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_redaccion_escritura"],
        '✍️'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_matematicas_financieras"],
        '💹'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_inteligencia_artificial"],
        '🤖'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_gestion_proyectos"],
        '📋'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_fotografia_digital"],
        '📷'
      ],
      [
        providerWithout.texts[providerWithout.appLang]["topic_ciberseguridad"],
        '🔒'
      ],
      [
        providerWithout.texts[providerWithout.appLang]
            ["topic_psicologia_basica"],
        '🧠'
      ],
    ];

    for (final topic in defaultTopics) {
      await http.post(
        Uri.parse("https://dannyluna17.pythonanywhere.com/trivi/addtopic"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${providerWithout.jwt}",
        },
        body: jsonEncode({
          "name": topic[0],
          "emoji": topic[1],
          // TODO: ACÄ USAR EL LENGUAJE POR DeFECTO DEL USER
          "language": providerWithout.appLang,
          "instrucciones": "",
          "file_name": "",
        }),
      );
    }
  }

  static Future<void> deleteTopic(BuildContext context, String name) async {
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    await http.post(
      Uri.parse("https://dannyluna17.pythonanywhere.com/trivi/removetopic"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${providerWithout.jwt}",
      },
      body: jsonEncode({
        "name": name,
      }),
    );
  }

  static Future<int> addlives(BuildContext context, String quantity) async {
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);
    Response? resp;
    try {
      resp = await http.post(
        Uri.parse(
          'https://dannyluna17.pythonanywhere.com/trivi/updateuser',
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${providerWithoutListen.jwt}",
        },
        // ignore: use_build_context_synchronously
        body: jsonEncode({
          'lives': quantity,
          // ignore: use_build_context_synchronously
        }),
      );
      print(jsonDecode(resp.body));
      final newLives = jsonDecode(resp.body)["lives"] as int;
      providerWithoutListen.setlives(newLives);
      await Hive.box<int>('livesBox').put('lives', newLives);
      return newLives;
    } on ClientException catch (_) {
      toastification.show(
        icon: const Icon(
          Icons.error_outline_outlined,
          size: 35,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
        title: Text(
          "${providerWithoutListen.texts[providerWithoutListen.appLang]["error_add_lives"]} ${_.toString()}",
          style: const TextStyle(fontSize: 10),
        ),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
      );
      return -1;
    }
  }

  static Future<int> addStars(BuildContext context, String quantity) async {
    final providerWithoutListen =
        Provider.of<SharedData>(context, listen: false);
    print(providerWithoutListen.jwt);
    Response? resp;
    try {
      resp = await http.post(
        Uri.parse(
          'https://dannyluna17.pythonanywhere.com/trivi/updateuser',
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${providerWithoutListen.jwt}",
        },
        // ignore: use_build_context_synchronously
        body: jsonEncode({
          'stars': quantity,
          // ignore: use_build_context_synchronously
        }),
      );
      print(jsonDecode(resp.body));
      final newStars = jsonDecode(resp.body)["stars"] as int;
      providerWithoutListen.setStars(newStars);
      await Hive.box<int>('starsBox').put('stars', newStars);
      return newStars;
    } on ClientException catch (_) {
      toastification.show(
        icon: const Icon(
          Icons.error_outline_outlined,
          size: 35,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
        title: Text(
          "${providerWithoutListen.texts[providerWithoutListen.appLang]["error_add_stars"]}: ${_.toString()}",
          style: const TextStyle(fontSize: 10),
        ),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
      );
      return -1;
    }
  }

  static void vibrate(type) async {
    if (await Haptics.canVibrate()) {
      await Haptics.vibrate(type);
    }
  }

  static void showToast(
    BuildContext context,
    ToastificationType toastType,
    String message,
    Widget icon,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth > 380) {
      screenWidth = 380;
    }
    Toastification().show(
      context: context,
      type: toastType,
      style: ToastificationStyle.minimal,
      title: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.004),
        child: Row(
          children: [
            icon,
            Container(
              margin: EdgeInsets.only(
                left: screenWidth * 0.02,
                top: screenWidth * 0.01,
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      backgroundColor: const Color(0xffffffff),
      foregroundColor: const Color(0xff000000),
      borderRadius: BorderRadius.circular(12),
      boxShadow: lowModeShadow,
      showProgressBar: false,
    );
  }

  static Future<void> getPrices(BuildContext context) async {
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    Offerings offerings;
    Future.delayed(Duration.zero, () async {
      offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.monthly != null) {
        StoreProduct monthly = offerings.current!.monthly!.storeProduct;
        StoreProduct annual = offerings.current!.annual!.storeProduct;

        if (annual.defaultOption!.pricingPhases[0].offerPaymentMode ==
            OfferPaymentMode.freeTrial) {
          providerWithout.setFreeTrial(true);
        } else {
          providerWithout.setFreeTrial(false);
        }

        for (SubscriptionOption option in annual.subscriptionOptions!) {
          print(option.pricingPhases[0].offerPaymentMode);
          if (option.pricingPhases[0].offerPaymentMode ==
              OfferPaymentMode.discountedRecurringPayment) {
            providerWithout.setDiscAnnualPrice(
                option.pricingPhases[0].price.amountMicros / 1000000);
          }
        }

        for (SubscriptionOption option in monthly.subscriptionOptions!) {
          if (option.pricingPhases[0].offerPaymentMode ==
              OfferPaymentMode.discountedRecurringPayment) {
            providerWithout.setDiscMonthlyPrice(
                option.pricingPhases[0].price.amountMicros / 1000000);
          }
        }

        if (providerWithout.discAnnualPrice == 0) {
          providerWithout.setDiscAnnualPrice(annual.price);
        }

        providerWithout.setAnnualPrice(annual.priceString);
        providerWithout.setMonthlyPrice(monthly.priceString);

        // print(providerWithout.annualPrice);
        // print(providerWithout.monthlyPrice);
        // print((providerWithout.discAnnualPrice / 12).toString());
        // print(providerWithout.discAnnualPrice);
        // print(providerWithout.discMonthlyPrice);
      }
    });
  }
}
