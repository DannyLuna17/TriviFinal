import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PremiumWidget extends StatelessWidget {
  const PremiumWidget({
    super.key,
    this.minWidth = 125,
    this.fontSize = 23,
  });

  final double minWidth;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth,),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7.5)),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(38, 221, 134, 1),
            Color.fromRGBO(38, 138, 255, 1),
            Color.fromRGBO(234, 89, 255, 1),
          ],
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 255, 255, 255),
        highlightColor: const Color.fromARGB(255, 255, 223, 250),
        child:  Text(
          "Premium",
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
