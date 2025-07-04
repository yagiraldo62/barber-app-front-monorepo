import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class CustomIntroductionScreen extends StatelessWidget {
  const CustomIntroductionScreen({
    super.key,
    this.pages,
    this.onDone,
    this.overrideDone,
    this.skip,
    this.next,
    this.done,
  });

  final List<PageViewModel>? pages;
  final void Function()? onDone;
  final Widget? overrideDone;
  final Widget? skip;
  final Widget? next;
  final Widget? done;

  @override
  Widget build(BuildContext context) {
    // Get.find<AuthGuardController>();

    return IntroductionScreen(
      pages: pages,
      onDone: onDone,
      overrideDone: overrideDone,
      //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
      scrollPhysics: const ClampingScrollPhysics(),
      showDoneButton: true,
      showNextButton: true,
      showSkipButton: false,
      skip: const Text("Omitir", style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.forward),
      done: const Text("Hecho", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: getDotsDecorator(),
    );
  }

  //method to customise the page style
  static PageDecoration getPageDecoration(BuildContext context) {
    return PageDecoration(
      imagePadding: const EdgeInsets.only(top: 0),
      imageFlex: 2,
      pageColor: Colors.transparent,
      bodyPadding: const EdgeInsets.only(top: 10),
      titlePadding: const EdgeInsets.only(top: 20),
      titleTextStyle: Theme.of(context).textTheme.titleLarge!,
      bodyTextStyle: Theme.of(context).textTheme.bodyMedium!,
    );
  }

  //method to customize the dots style
  static DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Colors.indigo,
      color: Colors.grey,
      activeSize: Size(12, 5),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }

  static PageViewModel buildPage({
    required String title,
    required Widget? body,
    required Widget? image,
    required BuildContext context,
  }) {
    return PageViewModel(
      title: title,
      bodyWidget: body,
      image: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        child: Center(child: image),
      ),
      decoration: getPageDecoration(context),
    );
  }
}
