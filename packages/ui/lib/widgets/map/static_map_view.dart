import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A static map widget that displays a location with a marker
/// and adjusts to its parent container size
class StaticMapView extends StatefulWidget {
  /// The location to display on the map
  final LatLng location;

  /// Zoom level for the map (default: 15.0)
  final double zoom;

  /// Whether to show a marker at the location (default: true)
  final bool showMarker;

  /// Custom marker icon (default: person_pin_circle)
  final IconData markerIcon;

  /// Marker color (default: red)
  final Color markerColor;

  /// Marker size (default: 40)
  final double markerSize;

  /// Whether to enable map interactions (default: false for static view)
  final bool enableInteractions;

  const StaticMapView({
    super.key,
    required this.location,
    this.zoom = 15.0,
    this.showMarker = true,
    this.markerIcon = Icons.person_pin_circle,
    this.markerColor = Colors.red,
    this.markerSize = 40,
    this.enableInteractions = false,
  });

  @override
  State<StaticMapView> createState() => _StaticMapViewState();
}

class _StaticMapViewState extends State<StaticMapView> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(StaticMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If location changes, animate to new location
    if (oldWidget.location != widget.location) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(widget.location, widget.zoom);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.location,
              initialZoom: widget.zoom,
              minZoom: 5.0,
              maxZoom: 18.0,
              // Disable interactions for static view
              interactionOptions: InteractionOptions(
                flags:
                    widget.enableInteractions
                        ? InteractiveFlag.all
                        : InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    dotenv.env['MAPBOX_DARK_URL'] ??
                    'https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                additionalOptions: {
                  'mapStyleId':
                      dotenv.env['MAPBOX_DARK_STYLE_ID'] ?? 'mapbox/dark-v11',
                  'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '',
                },
              ),
              if (widget.showMarker)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.location,
                      width: widget.markerSize,
                      height: widget.markerSize,
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          -widget.markerSize / 2,
                        ), // Offset 50% del tamaño del icono
                        child: Icon(
                          widget.markerIcon,
                          size: widget.markerSize,
                          color: widget.markerColor,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Overlay to prevent interactions when disabled
          if (!widget.enableInteractions)
            Positioned.fill(child: Container(color: Colors.transparent)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
