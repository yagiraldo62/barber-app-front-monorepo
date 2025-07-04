import 'dart:async';
import 'package:get/get.dart';

class TypewriterController extends GetxController {
  final RxString visibleText = ''.obs;
  Timer? timer;
  final String fullText;
  final Duration duration;
  final Duration startDelay;

  TypewriterController({
    required this.fullText,
    this.duration = const Duration(milliseconds: 1500),
    this.startDelay = const Duration(milliseconds: 500),
  });

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  void startAnimation() {
    // Reiniciamos el texto
    visibleText.value = '';

    // Agregamos un delay antes de comenzar
    Future.delayed(startDelay, () {
      final textLength = fullText.length;
      if (textLength == 0) return;

      // Calculamos el tiempo por caracter
      final characterDuration = duration.inMilliseconds ~/ textLength;

      int currentIndex = 0;

      timer = Timer.periodic(Duration(milliseconds: characterDuration), (
        timer,
      ) {
        if (currentIndex < textLength) {
          visibleText.value = fullText.substring(0, currentIndex + 1);
          currentIndex++;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void resetAnimation() {
    timer?.cancel();
    visibleText.value = '';
    startAnimation();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
