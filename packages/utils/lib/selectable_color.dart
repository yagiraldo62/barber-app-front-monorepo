import 'package:flutter/material.dart';

Color getSelectableColor(BuildContext context, bool selected) =>
    Theme.of(context).textTheme.labelMedium?.color != null && !selected
        ? Theme.of(context).textTheme.labelMedium!.color!
        : Theme.of(context).colorScheme.primary;
