import 'dart:math';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard(
      {super.key,
      required this.index,
      this.isPopular = false,
      this.realPrice,
      required this.name,
      required this.monthlyValue,
      this.discountedValue});

  final bool isPopular;
  final int index;
  final String name;
  final String monthlyValue;
  final String? realPrice;
  final String? discountedValue;

  @override
  Widget build(BuildContext context) {
    // Colores de ejemplo (ajusta a conveniencia)
    const Color backgroundColor = Color(0xFF1F2A41);
    final providerWith = Provider.of<SharedData>(context);
    final providerWithout = Provider.of<SharedData>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (providerWithout.vibration) Helpers.vibrate(HapticsType.selection);

        providerWithout.setSubIndex(index);
        if (index == 2) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        // Espacio para mostrar el gradiente como borde
        padding: const EdgeInsets.all(7.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: index == providerWith.subIndex
                ? [
                    const Color.fromRGBO(114, 93, 254, 1),
                    const Color.fromRGBO(74, 188, 253, 1),
                    const Color.fromRGBO(196, 82, 245, 1),
                  ]
                : [
                    const Color.fromRGBO(94, 127, 141, 1),
                    const Color.fromRGBO(156, 159, 158, 1),
                  ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: Container(
          // Fondo oscuro interior
          // padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fila principal (label "Popular" + precio mensual)
              isPopular
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pestaña “Popular” con bordes redondeados
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 6,
                          ),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: index == providerWith.subIndex
                                  ? [
                                      const Color.fromRGBO(115, 93, 254, 1),
                                      const Color.fromRGBO(87, 158, 253, 1),
                                    ]
                                  : [
                                      const Color.fromRGBO(94, 127, 141, 1),
                                      const Color.fromRGBO(156, 159, 158, 1),
                                    ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          child: Text(
                            providerWith.texts != null
                                ? providerWith.texts[providerWith.appLang]
                                    ["popular"]
                                : "Loading...",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21.5,
                                fontFamily: "Rowdies"),
                          ),
                        ),
                      ],
                    )
                  : Container(),

              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: isPopular == true ? 0 : 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 5, bottom: isPopular ? 0 : 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: providerWith.subIndex == index
                                        ? Colors.white
                                        : const Color.fromRGBO(94, 127, 141, 1),
                                    fontWeight: FontWeight.bold,
                                    // Ajusta el tamaño a tu gusto
                                    fontSize: monthlyValue == ""
                                        ? 17
                                        : isPopular
                                            ? 25.5
                                            : 28.5,
                                  ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: monthlyValue == "" ? 12 : 12,
                      ),
                      child: monthlyValue == ""
                          ? Transform.rotate(
                              angle: -pi,
                              child: const Icon(
                                FlutterIcons.arrow_back_mdi,
                                size: 26,
                                color: Color.fromRGBO(94, 127, 141, 1),
                              ),
                            )
                          : Text(
                              '\$$monthlyValue/mo',
                              style: TextStyle(
                                color: providerWith.subIndex == index
                                    ? Colors.white
                                    : const Color.fromRGBO(94, 127, 141, 1),
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),

              // Fila con precio anterior y precio actual
              discountedValue != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, bottom: 11.5, top: 5),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Text(
                                '\$$discountedValue',
                                style: TextStyle(
                                  color: providerWith.subIndex == index
                                      ? Colors.grey.shade400
                                      : const Color.fromRGBO(94, 127, 141, 1),
                                  fontSize: 17,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                color: providerWith.subIndex == index
                                    ? const Color.fromARGB(211, 255, 255, 255)
                                    : const Color.fromRGBO(94, 127, 141, 1),
                                height: 5,
                                width: (130 / 15) *
                                    (discountedValue.toString().length + 1),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          realPrice != null
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    '\$$realPrice',
                                    style: TextStyle(
                                      color: providerWith.subIndex == index
                                          ? Colors.white
                                          : const Color.fromRGBO(
                                              94, 127, 141, 1),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
