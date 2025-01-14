import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/providers/shared_data.dart';

class GridBoxWidget extends StatelessWidget {
  const GridBoxWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.37,
      height: MediaQuery.of(context).size.height * 0.17,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Provider.of<SharedData>(context).nightMode
                ? const Color.fromARGB(255, 65, 62, 62)
                : const Color.fromARGB(255, 239, 236, 236),
            width: 3,
          ),
          vertical: BorderSide(
            color: Provider.of<SharedData>(context).nightMode
                ? const Color.fromARGB(255, 65, 62, 62)
                : const Color.fromARGB(255, 239, 236, 236),
            width: 2,
          ),
        ),
        color: Provider.of<SharedData>(context).nightMode
            ? Colors.black
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
