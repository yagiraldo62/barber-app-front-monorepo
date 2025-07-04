import 'package:flutter/material.dart';

class BartooAppName extends StatelessWidget {
  final double size;

  const BartooAppName({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Text(
      'BARTU',
      style: TextStyle(
        fontFamily: 'K2D',
        fontWeight: FontWeight.w700,
        fontSize: size,
      ),
    );
  }
}
