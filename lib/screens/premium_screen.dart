import 'dart:convert';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:http/http.dart' as http;
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trivi_app/helpers/gradient_text.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/popups/popups.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/screens/login_screen.dart';
import 'package:trivi_app/widgets/subscription_card_widget.dart';
import 'package:trivi_app/widgets/widgets.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key, required this.buildContext});

  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);

    // Definir una base de duración para los retrasos
    const baseDelay = Duration(milliseconds: 200);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 24, 1),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 1. Encabezado: Fade In
                    DelayedWidget(
                      delayDuration: baseDelay,
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerGradientText(
                            text: 'Trivi Premium',
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(93, 179, 225, 1),
                                Color.fromRGBO(185, 114, 197, 1),
                              ],
                            ),
                            style: TextStyle(
                              fontFamily: "Alyssum",
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            shimmerDuration: Duration(seconds: 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // 2. Texto Descriptivo: Slide From Bottom
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 100),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: Text.rich(
                        TextSpan(text: "", children: [
                          TextSpan(
                              text: providerWith.texts != null
                                  ? providerWith.texts[providerWith.appLang]
                                      ["saveUpTo47Percent"]
                                  : "Loading...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )),
                          TextSpan(
                              text: providerWith.isFreeTrial
                                  ? providerWith.texts[providerWith.appLang]
                                      ["afterYour"]
                                  : "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )),
                          TextSpan(
                              text: providerWith.isFreeTrial
                                  ? providerWith.texts != null
                                      ? providerWith.texts[providerWith.appLang]
                                          ["freeTrial7Days"]
                                      : "Loading..."
                                  : "",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(75, 185, 253, 1))),
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // 3. Tarjeta de Suscripción Anual: Slide From Left
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 300),
                      animation: DelayedAnimations.SLIDE_FROM_LEFT,
                      child: ShrinkWidget(
                        shrinkScale: 0.96,
                        child: SubscriptionCard(
                          isPopular: true,
                          name: providerWith.texts != null
                              ? providerWith.texts[providerWith.appLang]
                                  ["yearlyPlan"]
                              : "Loading...",
                          monthlyValue:
                              (providerWith.discAnnualPrice / 12).toString(),
                          realPrice: providerWith.discAnnualPrice != 0
                              ? "${providerWith.discAnnualPrice}"
                              : "",
                          discountedValue: providerWith.annualPrice,
                          index: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // 4. Tarjeta de Suscripción Mensual: Slide From Right
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 400),
                      animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                      child: ShrinkWidget(
                        shrinkScale: 0.96,
                        child: SubscriptionCard(
                            name: providerWith.texts != null
                                ? providerWith.texts[providerWith.appLang]
                                    ["monthlyPlan"]
                                : "Loading...",
                            index: 1,
                            monthlyValue: providerWith.monthlyPrice),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // 5. Continuar Sin Suscripción: Slide From Bottom
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 500),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: ShrinkWidget(
                        shrinkScale: 0.96,
                        child: SubscriptionCard(
                          name: providerWith.texts != null
                              ? providerWith.texts[providerWith.appLang]
                                  ["continueWithoutSubscription"]
                              : "Loading...",
                          index: 2,
                          monthlyValue: "",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // 6. Texto "Accelerate Progress Premium": Fade In
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 600),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: ShimmerGradientText(
                        text:
                            '${providerWith.texts != null ? providerWith.texts[providerWith.appLang]["accelerateProgress"] : "Loading..."}Premium',
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(93, 179, 225, 1),
                            Color.fromRGBO(185, 114, 197, 1),
                          ],
                        ),
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        shimmerDuration: const Duration(seconds: 2),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // 7. Icono de Corazón con Infinitivo: Scale Up
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) =>
                                const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(38, 221, 134, 1),
                                Color.fromRGBO(38, 138, 255, 1),
                                Color.fromRGBO(234, 89, 255, 1),
                              ], // Gradient colors for the icon
                            ).createShader(bounds),
                            child: const Icon(FlutterIcons.heart_ant, size: 70),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 3.0, bottom: 2),
                            child: Icon(
                              FlutterIcons.infinity_faw5s,
                              size: 23,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 8. Texto "Unlimited Lives": Fade In
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 800),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: Text(
                        providerWith.texts != null
                            ? providerWith.texts[providerWith.appLang]
                                ["unlimited_lives"]
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 27,
                          color: Color.fromARGB(255, 236, 233, 233),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // 9. Icono de Video con Close: Slide From Left
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 900),
                      animation: DelayedAnimations.SLIDE_FROM_LEFT,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) =>
                                const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(38, 221, 134, 1),
                                Color.fromRGBO(38, 138, 255, 1),
                                Color.fromRGBO(234, 89, 255, 1),
                              ], // Gradient colors for the icon
                            ).createShader(bounds),
                            child: const Icon(FlutterIcons.video_ent, size: 70),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 3.0, bottom: 2),
                            child: Icon(
                              Icons.close_outlined,
                              size: 55,
                              color: Color.fromRGBO(204, 209, 211, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 10. Texto "No Ads": Fade In
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1000),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: Text(
                        providerWith.texts != null
                            ? providerWith.texts[providerWith.appLang]["no_ads"]
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 27,
                          color: Color.fromARGB(255, 236, 233, 233),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    // 11. Badge con AI Logo: Slide From Bottom
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1100),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: IntrinsicHeight(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Badge(
                              label: const GradientText("✨",
                                  style: TextStyle(fontSize: 22.5),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromRGBO(38, 221, 134, 1),
                                      Color.fromRGBO(38, 138, 255, 1),
                                      Color.fromRGBO(234, 89, 255, 1),
                                    ], // Gradient colors for the icon
                                  )),
                              padding:
                                  const EdgeInsets.only(bottom: 5.5, left: 8),
                              backgroundColor: Colors.transparent,
                              child: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) =>
                                    const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(38, 221, 134, 1),
                                    Color.fromRGBO(38, 138, 255, 1),
                                    Color.fromRGBO(234, 89, 255, 1),
                                  ], // Gradient colors for the icon
                                ).createShader(bounds),
                                child:
                                    // ios_fitness_ion
                                    SvgPicture.asset(
                                  "assets/ai.svg",
                                  width: 60,
                                  height: 60,
                                  semanticsLabel: 'AI Logo',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // 12. Texto "Modelo Avanzado de IA": Fade In
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1200),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: const Text(
                        "Modelo Avanzado de IA",
                        style: TextStyle(
                          fontSize: 27,
                          color: Color.fromARGB(255, 236, 233, 233),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // 13. Icono de Fitness: Slide From Right
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1300),
                      animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                      child: IntrinsicHeight(
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) => const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(38, 221, 134, 1),
                              Color.fromRGBO(38, 138, 255, 1),
                              Color.fromRGBO(234, 89, 255, 1),
                            ], // Gradient colors for the icon
                          ).createShader(bounds),
                          child:
                              // ios_fitness_ion
                              const Icon(FlutterIcons.ios_fitness_ion,
                                  size: 85),
                        ),
                      ),
                    ),
                    // 14. Texto "Unlimited Practice": Fade In
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1400),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: Text(
                        providerWith.texts != null
                            ? providerWith.texts[providerWith.appLang]
                                ["unlimitedPractice"]
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 27,
                          color: Color.fromARGB(255, 236, 233, 233),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // 15. ComparisonWidget: Slide From Left
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1500),
                      animation: DelayedAnimations.SLIDE_FROM_LEFT,
                      child: const ComparisonWidget(),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    // 16. Términos de Suscripción: Fade In
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1600),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: Text(
                        providerWith.texts != null
                            ? providerWith.texts[providerWith.appLang]
                                ["subscriptionTermsDetailed"]
                            : "Loading...",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(156, 159, 158, 1),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 88,
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 17. Botón de Suscripción: Slide From Bottom
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1700),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: ShrinkWidget(
                        onPressed: () async {
                          if (!kIsWeb) {
                            if (providerWithout.vibration) Helpers.vibrate(HapticsType.success);
                            try {
                              Offerings offerings =
                                  await Purchases.getOfferings();

                              CustomerInfo customerInfo =
                                  await Purchases.purchasePackage(
                                      providerWithout.subIndex == 0
                                          ? offerings.current!.annual!
                                          : offerings.current!.monthly!);

                              if (customerInfo
                                  .entitlements.all["Premium2"]!.isActive) {
                                // Unlock that great "pro" content
                                // ignore: use_build_context_synchronously
                                PopUps.purchasedPopUp(context);
                              }
                            } on PlatformException catch (e) {
                              var errorCode =
                                  PurchasesErrorHelper.getErrorCode(e);
                              if (errorCode !=
                                  PurchasesErrorCode.purchaseCancelledError) {
                                print(e);
                              }
                            }
                          } else {
                            http.Response? resp;
                            try {
                              resp = await http.post(
                                Uri.parse(
                                  'https://dannyluna17.pythonanywhere.com/trivi/updateuser',
                                ),
                                headers: {
                                  "Content-Type": "application/json",
                                  "Authorization":
                                      "Bearer ${providerWithout.jwt}",
                                },
                                // ignore: use_build_context_synchronously
                                body: jsonEncode({
                                  'premium': 1,
                                  // ignore: use_build_context_synchronously
                                }),
                              );
                              print(jsonDecode(resp.body));
                            } on http.ClientException catch (_) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushReplacement(
                                  Helpers.createRoute(
                                      LoginScreen(buildContext: buildContext)));
                              return -1;
                            }
                          }
                        },
                        shrinkScale: 0.97,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.5)),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(38, 138, 255, 1),
                                Color.fromRGBO(234, 89, 255, 1),
                              ])),
                          child: Text(
                            providerWith.texts != null
                                ? providerWith.texts[providerWith.appLang]
                                    ["start7DaysTrial"]
                                : "Loading...",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    // 18. Texto de Precio: Fade In
                    DelayedWidget(
                      delayDuration:
                          baseDelay + const Duration(milliseconds: 1800),
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: Shimmer.fromColors(
                        baseColor: Colors.white70,
                        highlightColor: Colors.white,
                        child: Text(
                          "\$${providerWith.subIndex == 0 ? providerWith.discAnnualPrice : providerWith.monthlyPrice} ${providerWith.texts != null ? providerWith.texts[providerWith.appLang]["after7DaysCancelAnytime"] : "Loading..."}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
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

class ComparisonWidget extends StatelessWidget {
  const ComparisonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final providerWith = Provider.of<SharedData>(context);

    final List<_FeatureRowData> features = [
      _FeatureRowData(
        title: providerWith.texts != null
            ? providerWith.texts[providerWith.appLang]["learning_content"]
            : "Loading...",
        iconFree: Icons.check,
        iconSuper: Icons.check,
      ),
      _FeatureRowData(
        title: providerWith.texts != null
            ? providerWith.texts[providerWith.appLang]["practice_skills"]
            : "Loading...",
        iconFree: Icons.check,
        iconSuper: Icons.check,
      ),
      _FeatureRowData(
        title: providerWith.texts != null
            ? providerWith.texts[providerWith.appLang]["unlimited_lives"]
            : "Loading...",
        iconFree: Icons.remove, // sin ícono
        iconSuper: Icons.check,
      ),
      _FeatureRowData(
        title: "Modelo Avanzado de IA",
        iconFree: Icons.remove, // sin ícono
        iconSuper: Icons.check,
      ),
      _FeatureRowData(
        title: providerWith.texts != null
            ? providerWith.texts[providerWith.appLang]["no_ads"]
            : "Loading...",
        iconFree: Icons.remove, // dash
        iconSuper: Icons.check,
      ),
      _FeatureRowData(
        title: providerWith.texts[providerWith.appLang]
            ["upTo100QuestionsWithPremiumPlan"],
        iconFree: Icons.remove,
        iconSuper: Icons.check,
      ),
      _FeatureRowData(
        title: providerWith.texts != null
            ? providerWith.texts[providerWith.appLang]["error_review"]
            : "Loading...",
        iconFree: Icons.remove,
        iconSuper: Icons.check,
      ),
      _FeatureRowData(
        title: providerWith.texts != null
            ? providerWith.texts[providerWith.appLang]["unlimited_challenges"]
            : "Loading...",
        iconFree: Icons.remove, // sin ícono
        iconSuper: Icons.check,
      ),
    ];

    // Definir una base de duración para los retrasos
    const baseDelay = Duration(milliseconds: 200);

    return DelayedWidget(
      delayDuration: baseDelay +
          const Duration(
              milliseconds: 1600), // Ajusta el retraso según sea necesario
      animation: DelayedAnimations.SLIDE_FROM_LEFT,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                Center(
                  child: ShimmerGradientText(
                    text: providerWith.texts != null
                        ? providerWith.texts[providerWith.appLang]["benefits"]
                        : "Loading...",
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(93, 179, 225, 1),
                        Color.fromRGBO(185, 114, 197, 1),
                      ],
                    ),
                    style: const TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    shimmerDuration: const Duration(seconds: 2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Center(
                    child: Text(
                      providerWith.texts != null
                          ? providerWith.texts[providerWith.appLang]["free"]
                          : "Loading...",
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  // Fondo para resaltar "SUPER"
                  margin: const EdgeInsets.only(bottom: 8.0, left: 12),
                  child: const PremiumWidget(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            for (var feature in features)
              TableRow(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                    ),
                    child: Text(
                      feature.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _iconCell(feature.iconFree),
                  _iconCell(feature.iconSuper, isSuper: true),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconCell(IconData? icon, {bool isSuper = false}) {
    if (icon == null) {
      return const SizedBox.shrink();
    }

    Color iconColor = Colors.greenAccent;
    if (icon == Icons.remove) {
      iconColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Icon(
        icon,
        color: iconColor,
      ),
    );
  }
}

class _FeatureRowData {
  final String title;
  final IconData? iconFree;
  final IconData? iconSuper;

  _FeatureRowData({
    required this.title,
    this.iconFree,
    this.iconSuper,
  });
}

class ShimmerGradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign textAlign;
  final Duration shimmerDuration;

  const ShimmerGradientText({
    super.key,
    required this.text,
    required this.style,
    required this.gradient,
    this.textAlign = TextAlign.center,
    this.shimmerDuration = const Duration(milliseconds: 2000),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            text,
            style: style.copyWith(color: Colors.white),
            textAlign: textAlign,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.transparent,
          highlightColor: const Color.fromRGBO(255, 255, 255, 0.8),
          period: shimmerDuration,
          child: Text(
            text,
            style: style.copyWith(color: Colors.white),
            textAlign: textAlign,
          ),
        ),
      ],
    );
  }
}
