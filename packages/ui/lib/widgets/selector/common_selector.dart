import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';

/// A reusable modal bottom sheet selector widget
///
/// Generic widget that displays a list of items in a modal bottom sheet
/// with automatic scrolling to the selected item.
class CommonSelector<T> extends StatelessWidget {
  const CommonSelector({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.selectedItem,
    required this.itemBuilder,
    required this.onItemSelected,
    this.itemHeight = 50,
    this.isItemDisabled,
  });

  /// Title displayed at the top of the modal
  final String title;

  /// Icon displayed next to the title
  final IconData icon;

  /// List of items to display
  final List<T> items;

  /// Currently selected item
  final T selectedItem;

  /// Builder function to create each list item
  /// Parameters: context, item, isSelected
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;

  /// Callback when an item is selected
  final void Function(T item) onItemSelected;

  /// Height of each list item (used for scroll calculation)
  final double itemHeight;

  /// Optional function to determine if an item should be disabled
  final bool Function(T item)? isItemDisabled;

  /// Shows the selector modal
  static Future<void> show<T>({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<T> items,
    required T selectedItem,
    required Widget Function(BuildContext, T, bool) itemBuilder,
    required void Function(T) onItemSelected,
    double itemHeight = 50,
    bool Function(T item)? isItemDisabled,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CommonSelector<T>(
          title: title,
          icon: icon,
          items: items,
          selectedItem: selectedItem,
          itemBuilder: itemBuilder,
          onItemSelected: onItemSelected,
          itemHeight: itemHeight,
          isItemDisabled: isItemDisabled,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Find the index of the selected item
    final selectedIndex = items.indexWhere((item) => item == selectedItem);
    final scrollController = ScrollController(
      initialScrollOffset:
          selectedIndex > 0 ? (selectedIndex * (itemHeight - 2)) : 0.0,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Typography(title, variation: TypographyVariation.bodyMedium),
              ],
            ),
          ),
          const Divider(),

          // List of items
          Flexible(
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedItem;
                final isDisabled = isItemDisabled?.call(item) ?? false;

                return InkWell(
                  onTap:
                      isDisabled
                          ? null
                          : () {
                            onItemSelected(item);
                            Navigator.pop(context);
                          },
                  child: itemBuilder(context, item, isSelected),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
