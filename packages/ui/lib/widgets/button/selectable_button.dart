import 'package:utils/selectable_color.dart';
import 'package:flutter/material.dart';

class SelectableButton extends StatelessWidget {
  final Function onSelectionChange;
  final Widget? child;
  final bool selected;
  final RoundedRectangleBorder shape;
  final EdgeInsets padding;

  const SelectableButton({
    super.key,
    this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    required this.onSelectionChange,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    Color color = getSelectableColor(context, selected);

    return ElevatedButton(
      onPressed: () => onSelectionChange(),
      style: ElevatedButton.styleFrom(
        surfaceTintColor: color,
        foregroundColor: color,
        shadowColor: color,
        shape: shape,
        padding: padding,
      ),
      child: child,
    );
  }
}
