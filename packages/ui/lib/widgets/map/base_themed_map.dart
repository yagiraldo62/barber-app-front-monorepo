import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ui/theme/theme_manager.dart';

/// A base map widget that handles theme-aware map styling
/// This widget automatically switches between dark and light map styles
/// based on the app's current theme
class BaseThemedMap extends StatelessWidget {
  /// The map controller for programmatic map control
  final MapController mapController;

  /// The center location of the map
  final LatLng center;

  /// Initial zoom level
  final double zoom;

  /// Minimum zoom level
  final double minZoom;

  /// Maximum zoom level
  final double maxZoom;

  /// Callback when map position changes
  final void Function(MapCamera, bool)? onPositionChanged;

  /// Additional layers to display on top of the tile layer (e.g., markers)
  final List<Widget> additionalLayers;

  /// Map interaction options
  final InteractionOptions? interactionOptions;

  const BaseThemedMap({
    super.key,
    required this.mapController,
    required this.center,
    this.zoom = 15.0,
    this.minZoom = 5.0,
    this.maxZoom = 18.0,
    this.onPositionChanged,
    this.additionalLayers = const [],
    this.interactionOptions,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        // Get dark mode state from GetX ThemeManager
        final isDarkMode = themeManager.isDark;

        // Debug logging
        print('🗺️ BaseThemedMap - isDarkMode: $isDarkMode');
        print('🗺️ Get.isDarkMode: ${Get.isDarkMode}');

        // Select map style based on theme
        final mapStyleId =
            isDarkMode
                ? (dotenv.env['MAPBOX_DARK_STYLE_ID'] ?? 'mapbox/dark-v11')
                : (dotenv.env['MAPBOX_LIGHT_STYLE_ID'] ?? 'mapbox/streets-v12');

        print('🗺️ Selected mapStyleId: $mapStyleId');

        final urlTemplate =
            isDarkMode
                ? (dotenv.env['MAPBOX_DARK_URL'] ??
                    'https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}')
                : (dotenv.env['MAPBOX_LIGHT_URL'] ??
                    'https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}');

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: zoom,
            minZoom: minZoom,
            maxZoom: maxZoom,
            onPositionChanged: onPositionChanged,
            interactionOptions:
                interactionOptions ?? const InteractionOptions(),
          ),
          children: [
            // Base tile layer with theme-aware styling
            TileLayer(
              urlTemplate: urlTemplate,
              additionalOptions: {
                'mapStyleId': mapStyleId,
                'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '',
              },
              // Use cancellable network tile provider for better web performance
              tileProvider: NetworkTileProvider(),
            ),
            // Additional layers provided by parent widget
            ...additionalLayers,
          ],
        );
      },
    );
  }
}
