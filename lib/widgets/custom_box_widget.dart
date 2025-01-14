import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/providers/shared_data.dart';

class CustomBoxWidget extends StatelessWidget {
  const CustomBoxWidget({required this.child, super.key, this.border});

  final Widget child;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
      decoration: BoxDecoration(
        color: Provider.of<SharedData>(context).nightMode
            ? Colors.black
            : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: border ??
            const Border(
              bottom: BorderSide(
                color: Color.fromRGBO(229, 229, 229, 1),
                width: 2,
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
      ),
      child: child,
    );
  }
}
