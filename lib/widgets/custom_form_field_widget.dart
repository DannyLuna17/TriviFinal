import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/providers/shared_data.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  const CustomTextFormFieldWidget({
    required this.textController,
    required this.validator,
    required this.hintText,
    super.key,
    this.obscureText,
  });

  final TextEditingController textController;
  final String? Function(String?)? validator;
  final String hintText;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText ?? false,
      controller: textController,
      cursorColor: const Color.fromRGBO(78, 211, 255, 1),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 22),
      decoration: InputDecoration(
        hintText: hintText,
        alignLabelWithHint: true,
        filled: true,
        fillColor: Provider.of<SharedData>(context).nightMode
            ? const Color.fromARGB(255, 38, 37, 37)
            : const Color.fromRGBO(248, 248, 248, 1),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color.fromRGBO(195, 195, 195, 1),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 3,
            color: Color.fromRGBO(78, 211, 255, 1),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
