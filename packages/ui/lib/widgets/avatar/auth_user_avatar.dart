import 'package:flutter/material.dart';

class AuthUserAvatar extends StatelessWidget {
  final bool isArtist;
  final Widget alternativeWidget;
  final int size;

  const AuthUserAvatar({
    super.key,
    this.isArtist = false,
    this.alternativeWidget = const CircularProgressIndicator(),
    this.size = 60,
  });

  // Note: These controllers need to be injected from the app layer
  // final authController = Get.find<AuthController>();
  final progressIndicator = const CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    // Temporarily commented out until proper dependency injection is set up
    // String? src = authController.user.value?.photoURL;

    // if (isArtist) {
    //   if (authController.selectedArtist.value != null) {
    //     src = authController.selectedArtist.value?.photoUrl;
    //   }
    // }

    // return (src != "")
    //     ? UserAvatar(
    //         src: src,
    //         size: size,
    //       )
    //     : alternativeWidget;

    // Placeholder implementation until controllers are properly injected
    return alternativeWidget;
  }
}
