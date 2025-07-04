import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? src;
  final bool asset;
  final double radius;
  final int size;

  const UserAvatar({
    super.key,
    required this.src,
    this.asset = false,
    this.radius = 100,
    this.size = 60,
  });

  // Note: AuthController dependency should be injected from app layer
  // final authController = Get.find<AuthController>();
  final progressIndicator = const CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.toDouble(),
      height: size.toDouble(),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child:
              src == null
                  ? progressIndicator
                  : asset
                  ? Image.asset(src!, fit: BoxFit.fitWidth)
                  : Image.network(
                    src!,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      // Log utility should be injected from app layer
                      print('Error loading image: $error');
                      return Icon(Icons.error); // Handle error gracefully
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return progressIndicator;
                    },
                  ),
        ),
      ),
    );
  }
}
