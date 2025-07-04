import 'package:ui/widgets/brand/bartoo_app_name.dart';
import 'package:flutter/material.dart';

class AppSplash extends StatelessWidget {
  const AppSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: BartooAppName(size: 50)));
  }
}
