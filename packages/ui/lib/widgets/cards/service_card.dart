import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String name;
  final String? time;
  final Widget? button;
  final Widget? bottom;
  final double padding;

  const ServiceCard({
    super.key,
    required this.name,
    this.time,
    this.button,
    this.bottom,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Controls the shadow depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Border radius for the card
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: padding,
              right: padding,
              top: padding / 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 5),
                    Text(
                      time ?? "",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                button != null ? button! : const Text("button"),
              ],
            ),
          ),
          bottom != null ? bottom! : const Text("bottom"),
        ],
      ),
    );
  }
}
