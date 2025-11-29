import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:core/modules/auth/controllers/base_auth_controller.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:ui/widgets/typography/typography.dart';
import 'package:ui/widgets/selector/common_selector.dart';
import 'package:utils/log.dart';

/// A dropdown widget that allows users to select and change their active business scope.
///
/// This widget displays the currently selected scope (profile or location) and provides
/// a dropdown menu to change between available scopes for the authenticated user.
///
/// The widget only renders if a user is authenticated and is using BusinessAuthController.
/// Available scopes include:
/// - Owned profiles (ProfileScope)
/// - Locations where the user works (LocationMemberScope)
class ScopeSelector extends StatelessWidget {
  /// Optional custom styling for the button
  final ButtonStyle? buttonStyle;

  /// Optional custom styling for the dropdown menu
  final PopupMenuThemeData? menuTheme;

  const ScopeSelector({super.key, this.buttonStyle, this.menuTheme});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<BaseAuthController>();

    return Obx(() {
      final user = authController.user.value;
      if (user == null) {
        return const SizedBox.shrink();
      }

      // Check if this is a BusinessAuthController with selectedScope
      final selectedScopeRx = _getSelectedScope(authController);
      if (selectedScopeRx == null) {
        return const SizedBox.shrink();
      }

      // Collect all available scopes
      final scopes = _buildAvailableScopes(user);
      if (scopes.isEmpty) {
        return const SizedBox.shrink();
      }

      // Get current selected scope display text
      final currentScopeText = _getScopeDisplayText(selectedScopeRx.value);

      return GestureDetector(
        onTap:
            () => _showScopeSelector(
              context,
              authController,
              selectedScopeRx,
              scopes,
            ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.domain,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  currentScopeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Shows the scope selector modal bottom sheet
  void _showScopeSelector(
    BuildContext context,
    BaseAuthController authController,
    Rx<BussinessScope?> selectedScopeRx,
    List<BussinessScope> scopes,
  ) {
    CommonSelector.show<BussinessScope>(
      context: context,
      title: 'Seleccionar contexto',
      icon: Icons.domain,
      items: scopes,
      selectedItem: selectedScopeRx.value ?? scopes.first,
      itemBuilder: (context, scope, isSelected) {
        final theme = Theme.of(context);
        final displayText = _getScopeDisplayText(scope);

        return ListTile(
          minTileHeight: 50,
          leading: Icon(
            _getScopeIcon(scope),
            color: isSelected ? theme.colorScheme.primary : null,
          ),
          title: Typography(
            displayText,
            variation: TypographyVariation.bodyMedium,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
          trailing:
              isSelected
                  ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                  : null,
          tileColor:
              isSelected
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
                  : null,
        );
      },
      onItemSelected: (scope) {
        _changeScope(authController, scope);
      },
    );
  }

  /// Returns an appropriate icon for a scope type
  IconData _getScopeIcon(BussinessScope scope) {
    if (scope is ProfileScope) {
      return Icons.business;
    } else if (scope is LocationMemberScope) {
      return Icons.location_on;
    }
    return Icons.domain;
  }

  /// Gets the selectedScope reactive value from BusinessAuthController if available.
  Rx<BussinessScope?>? _getSelectedScope(BaseAuthController authController) {
    try {
      final dynamic businessAuth = authController;
      if (businessAuth.selectedScope != null) {
        return businessAuth.selectedScope as Rx<BussinessScope?>;
      }
    } catch (e) {
      Log('ScopeSelector: Could not access selectedScope: $e');
    }
    return null;
  }

  /// Builds a list of all available scopes for the user.
  ///
  /// Includes both owned profiles and locations where the user is a member.
  List<BussinessScope> _buildAvailableScopes(UserModel user) {
    final scopes = <BussinessScope>[];

    // Add locations worked
    if (user.locationsWorked != null) {
      for (final location in user.locationsWorked!) {
        scopes.add(LocationMemberScope(location));
      }
    }

    // Add owned profiles
    if (user.profiles != null) {
      for (final profile in user.profiles!) {
        scopes.add(ProfileScope(profile));
      }
    }

    return scopes;
  }

  /// Returns a user-friendly display text for a scope.
  String _getScopeDisplayText(BussinessScope? scope) {
    String displayText;
    if (scope is ProfileScope) {
      displayText = scope.profile.name;
    } else if (scope is LocationMemberScope) {
      final org = scope.locationMember.organization?.name ?? '';
      final location =
          scope.locationMember.location?.name.replaceAll(org, '') ?? '';
      if (org.isNotEmpty) {
        displayText = '$org ${location.isNotEmpty ? '- $location' : ''}'.trim();
      } else {
        displayText = location.isNotEmpty ? location : 'Location';
      }
    } else {
      displayText = 'Select Scope';
    }

    // Truncate to max 25 characters
    if (displayText.length > 25) {
      return '${displayText.substring(0, 22)}...';
    }
    return displayText;
  }

  /// Changes the selected scope in the auth controller.
  void _changeScope(BaseAuthController authController, BussinessScope scope) {
    try {
      final dynamic businessAuth = authController;
      if (businessAuth.setSelectedScope != null) {
        businessAuth.setSelectedScope(scope);
      }
    } catch (e) {
      Log('ScopeSelector: Error changing scope: $e');
    }
  }
}
