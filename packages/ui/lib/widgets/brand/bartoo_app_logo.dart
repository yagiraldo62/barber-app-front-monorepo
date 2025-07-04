import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LogoVariant { white, whiteFade, orange, orangeFade }

Map<LogoVariant, String> _logoVariantsSrc = {
  LogoVariant.white: "assets/images/logo/white.svg",
  LogoVariant.whiteFade: "assets/images/logo/white-fade.svg",
  LogoVariant.orange: "assets/images/logo/orange.svg",
  LogoVariant.orangeFade: "assets/images/logo/orange-fade.svg",
};

class BartooAppLogo extends StatelessWidget {
  final double size;
  final LogoVariant variant;
  const BartooAppLogo({
    super.key,
    this.size = 24,
    this.variant = LogoVariant.whiteFade,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_logoVariantsSrc[variant]!, height: size);
  }
}
