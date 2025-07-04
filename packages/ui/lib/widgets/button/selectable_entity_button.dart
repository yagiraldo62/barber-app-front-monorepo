import 'package:flutter/material.dart';
import 'package:core/data/models/shared/abstract/selectable_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intersperse/intersperse.dart';
import 'package:ui/widgets/button/selectable_button.dart';

class SelectableEntityButton extends StatelessWidget {
  final SelectableEntity entity;
  final Function? onSelectionChange;
  final bool showName;
  final double size;

  const SelectableEntityButton({
    super.key,
    required this.entity,
    this.onSelectionChange,
    this.showName = true,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Rounded shape
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      onSelectionChange: onSelectionChange != null ? onSelectionChange! : () {},
      selected: entity.selected ?? false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          entity.icon != null
              ? SvgPicture.asset(
                "images/${entity.type}/${entity.icon}.svg",
                height: size,
                width: size,
              )
              : const SizedBox(),
          ...(showName
              ? [
                SizedBox(height: entity.icon != null ? 5 : 0),
                Text(
                  entity.name ?? "",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ]
              : []),
        ],
      ),
    );
  }
}

List<Widget> selectableEntityButtonList<T>(
  List<SelectableEntity> selectableEntitiesList,
  Function? onChangeSelection, {
  bool atLeatOne = true,
  bool showName = true,
  double spacing = 10,
  double size = 20,
}) {
  bool oneSelected =
      selectableEntitiesList
              .where((entity) => entity.selected ?? false)
              .length ==
          1 &&
      atLeatOne;

  return intersperse(
    SizedBox(width: spacing),
    selectableEntitiesList.map(
      (entity) => SelectableEntityButton(
        onSelectionChange:
            () =>
                onChangeSelection != null
                    ? onChangeSelection(
                      selectableEntitiesList.map((mappedEntity) {
                        if (mappedEntity.name == entity.name &&
                            (!oneSelected ||
                                !(mappedEntity.selected ?? false))) {
                          mappedEntity.toggleSelection();
                        }

                        return mappedEntity as T;
                      }).toList(),
                    )
                    : null,
        entity: entity,
        showName: showName,
        size: size,
      ),
    ),
  ).toList();
}
