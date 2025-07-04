import 'package:ui/widgets/brand/bartoo_app_name.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final bool name;
  final bool logo;
  final double nameSize;
  final double logoSize;
  const AppLogo({
    super.key,
    this.name = true,
    this.logo = true,
    this.nameSize = 24,
    this.logoSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Visibility(
        //   visible: logo,
        //   child: BartooAppLogo(
        //     size: logoSize,
        //   ),
        // ),
        Visibility(visible: name && logo, child: const SizedBox(width: 15)),
        Visibility(visible: name, child: BartooAppName(size: nameSize)),
      ],
    );
  }
}
