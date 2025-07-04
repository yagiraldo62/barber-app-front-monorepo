import 'package:flutter/material.dart';

class HorizonalIntrodctionScreen extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;

  const HorizonalIntrodctionScreen({
    super.key,
    required this.content,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(color: backgroundColor, child: Center(child: content));
  }
}
