import 'package:flutter/material.dart';
import 'package:ui/widgets/brand/bartoo_app_name.dart';
import 'package:ui/widgets/button/toggle_theme.dart';

class SimpleCenteredLayout extends StatelessWidget {
  final Widget body;

  const SimpleCenteredLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ToggleThemeButton(),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Center(child: BartooAppName(size: 40)),
                ),
                Expanded(flex: 2, child: body),
              ],
            ),
          ),
        ), // Agregar el botón flotante
      ),
    );
  }
}
