import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivi_app/providers/shared_data.dart';

// ignore: must_be_immutable
class CustomButtonWidget extends StatefulWidget {
  CustomButtonWidget({
    required this.onTap,
    super.key,
    this.label,
    this.colorNormal,
    this.fontColor,
    this.backNormal,
    this.child,
    this.backDisabled,
    this.isEnabled,
    this.fullBorder,
    this.expandible = true,
    this.scaleValue = 1.0115,
    this.backPressed,
    this.colorPressed,
    this.decoration,
  });

  String? label;
  bool? expandible;
  double? scaleValue;
  bool? fullBorder;
  bool? isEnabled;
  final void Function()? onTap;
  Color? colorNormal;
  Color? colorPressed;
  Color? backNormal;
  Widget? child;
  Color? backPressed;
  Color? backDisabled;
  Color? fontColor;
  Decoration? decoration;

  @override
  State<CustomButtonWidget> createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget>
    with SingleTickerProviderStateMixin {
  bool isDown = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.fontColor ??= const Color.fromRGBO(86, 85, 85, 1);
    widget.backNormal ??=
        Provider.of<SharedData>(context, listen: false).nightMode
            ? Colors.black
            : Colors.white;
    widget.backPressed ??= const Color.fromRGBO(229, 229, 229, 1);
    widget.backDisabled ??= const Color.fromRGBO(229, 229, 229, 0.5);

    widget.colorNormal ??=
        Provider.of<SharedData>(context, listen: false).nightMode
            ? const Color.fromARGB(255, 38, 37, 37)
            : const Color.fromRGBO(229, 229, 229, 1);
    widget.colorPressed ??= const Color.fromRGBO(206, 206, 206, 1);

    widget.isEnabled ??= true;

    return GestureDetector(
      onTap: () {
        if (widget.isEnabled == true) {
          widget.onTap!();
        }
      },
      onPanDown: (details) {
        setState(() {
          isDown = !isDown;
        });
      },
      onPanEnd: (details) {
        setState(() {
          isDown = !isDown;
        });
      },
      onPanCancel: () {
        setState(() {
          isDown = !isDown;
        });
      },
      child: widget.expandible!
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: CustomBoxExtractedWidget(
                      widget: widget,
                      isDown: isDown,
                      decoration: widget.decoration),
                );
              },
            )
          : AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: IntrinsicWidth(
                    child: CustomBoxExtractedWidget(
                      widget: widget,
                      isDown: isDown,
                      decoration: widget.decoration,
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CustomBoxExtractedWidget extends StatelessWidget {
  const CustomBoxExtractedWidget({
    super.key,
    required this.widget,
    required this.isDown,
    required this.decoration,
  });

  final CustomButtonWidget widget;
  final bool isDown;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration ??
          BoxDecoration(
            color: widget.isEnabled == true
                ? widget.backNormal
                : widget.backDisabled,
            borderRadius: const BorderRadius.all(Radius.circular(17.5)),
            border: Border(
              bottom: BorderSide(
                color: widget.colorNormal!,
                width: isDown && widget.isEnabled == true ? 2 : 5,
              ),
              top: widget.fullBorder == null
                  ? BorderSide(color: widget.colorNormal!, width: 2)
                  : BorderSide.none,
              right: widget.fullBorder == null
                  ? BorderSide(color: widget.colorNormal!, width: 2)
                  : BorderSide.none,
              left: widget.fullBorder == null
                  ? BorderSide(color: widget.colorNormal!, width: 2)
                  : BorderSide.none,
            ),
          ),
      child: Container(
        padding: EdgeInsets.only(
          top: isDown && widget.isEnabled == true ? 13.5 : 8.5,
          bottom: 10,
          left: 12,
          right: 12,
        ),
        child: Center(
          child: widget.child ??
              Text(
                widget.label!,
                style: TextStyle(fontSize: 24.5, color: widget.fontColor),
              ),
        ),
      ),
    );
  }
}
