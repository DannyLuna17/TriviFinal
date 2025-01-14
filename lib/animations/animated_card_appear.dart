import 'package:flutter/material.dart';

class AnimatedCardAppear extends StatefulWidget {
  const AnimatedCardAppear({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });
  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  _AnimatedCardAppearState createState() => _AnimatedCardAppearState();
}

class _AnimatedCardAppearState extends State<AnimatedCardAppear>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Animación de opacidad
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animación de escalado
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Animación de rotación (menos rotación para evitar el efecto "doblado")
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animación de deslizamiento desde abajo
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Iniciar la animación con el retraso especificado
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
