import 'package:ui/layout/app_drawer.dart';
import 'package:ui/layout/app_bar.dart';
import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget body;
  final bool back;
  final Widget? bottomNavigationBar;
  final String? title;
  final Widget? floatingActionButton; // Nuevo parámetro para botón flotante
  final List<Widget>? actions; // Nuevo parámetro para acciones en AppBar

  const AppLayout({
    super.key,
    required this.body,
    this.back = false,
    this.bottomNavigationBar,
    this.title,
    this.floatingActionButton, // Nuevo parámetro
    this.actions, // Nuevo parámetro
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Scaffold(
              drawer: back ? null : BaseAppDrawer(),
              extendBodyBehindAppBar: back,
              appBar: BaseAppBar(back: back, title: title),
              body: body,
              bottomNavigationBar: bottomNavigationBar,
              floatingActionButton:
                  floatingActionButton, // Agregar el botón flotante
            ),
          ),
        ),
      ),
    );
  }
}
