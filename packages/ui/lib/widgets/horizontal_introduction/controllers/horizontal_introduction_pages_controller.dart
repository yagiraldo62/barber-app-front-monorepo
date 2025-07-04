import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalIntroductionPageController extends GetxController {
  final RxInt currentPage = 0.obs;
  final PageController pageController = PageController();
  final List<Widget> pages;
  final Function()? onFinish;

  HorizontalIntroductionPageController({required this.pages, this.onFinish});

  void goToNextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (onFinish != null) {
      onFinish!();
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
