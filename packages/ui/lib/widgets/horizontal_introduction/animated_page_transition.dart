import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedPageTransition extends StatelessWidget {
  final Widget child;
  final PageController pageController;
  final int index;

  const AnimatedPageTransition({
    super.key,
    required this.child,
    required this.pageController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, widget) {
        double page = 0;
        if (pageController.position.haveDimensions) {
          page = pageController.page ?? 0;
        }

        // Calculamos el factor de animación para esta página
        final pageOffset = page - index;

        // Suavizamos la función de interpolación usando una curva
        final smoothedOffset = _smoothStep(pageOffset.abs());

        // Escalamos con una animación más suave
        final scale = 1 - (smoothedOffset * 0.2).clamp(0.0, 0.2);

        // Rotación sutil para añadir profundidad
        final rotation = pageOffset * math.pi / 180 * 10;

        // Desplazamiento vertical más suave
        final yTranslation =
            pageOffset >= 0
                ? -smoothedOffset * MediaQuery.of(context).size.height * 0.5
                : (1 - smoothedOffset) *
                    MediaQuery.of(context).size.height *
                    0.3;

        // Opacidad más suave
        final opacity = 1 - smoothedOffset.clamp(0.0, 1.0);

        return Transform(
          transform:
              Matrix4.identity()
                // ..setEntry(3, 2, 0.001) // Añade perspectiva
                // ..rotateX(rotation)
                ..translate(0.0, yTranslation),
          alignment: Alignment.center,
          child: Transform.scale(
            scale: scale,
            child: Opacity(opacity: opacity, child: child),
          ),
        );
      },
    );
  }

  // Función de interpolación suave
  double _smoothStep(double x) {
    // Función de interpolación cúbica suave
    return x < 0.5 ? 4 * x * x * x : 1 - math.pow(-2 * x + 2, 3) / 2;
  }
}
