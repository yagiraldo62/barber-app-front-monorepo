import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:ui' as ui;
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/map_marker.dart';
import 'package:ui/widgets/map/base_themed_map.dart';

List<Map<String, dynamic>> data = [
  {'id': '1', 'globalKey': GlobalKey(), 'widget': MarkerImage()},
];

class MapBoxView extends StatefulWidget {
  const MapBoxView({super.key});

  @override
  State<MapBoxView> createState() => _MapBoxViewState();
}

class _MapBoxViewState extends State<MapBoxView> {
  Map<String, Marker> markers = {};
  List<Map<String, dynamic>> markersResources = <Map<String, dynamic>>[];
  LatLng center = const LatLng(45.521563, -122.677433);
  bool isLoaded = false;
  final MapController mapController = MapController();

  // void _onMapCreated() {
  //   setMapStyle();
  // }

  // void setMapStyle() {
  //   if (darkMapStyle != null &&
  //       lightMapStyle != null &&
  //       mapController != null) {
  //     mapController!
  //         .setMapStyle(themeManager.isDark ? darkMapStyle : lightMapStyle);

  //     setState(() {
  //       isDark = themeManager.isDark;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // Map initialization can be customized here if needed
  }

  @override
  Widget build(BuildContext context) {
    // List<dynamic> markersRepaintBoundaries = markersResources
    //     .map((markerResource) => markerResource["repaintBoundary"])
    //     .toList();

    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 3),
              Expanded(
                child: BaseThemedMap(
                  mapController: mapController,
                  center: center,
                  zoom: 13,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                ),
                // MapBox(
                //   tiltGesturesEnabled: true,
                //   compassEnabled: true,
                //   onMapCreated: _onMapCreated,
                //   myLocationEnabled: true,
                //   zoomControlsEnabled: false,
                //   myLocationButtonEnabled: true,
                //   padding: const EdgeInsets.all(10),
                //   initialCameraPosition: CameraPosition(
                //       target: center!, zoom: 16.5, bearing: 60, tilt: 50),
                //   markers: markers.values.toSet(),
                // ),
              ),
            ],
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                ],
              ),
            ),
          ),
        ],
      ),
      // : Stack(children: [
      //     ListView(
      //       children: [
      //         for (int i = 0; i < data.length; i++)
      //           Transform.translate(
      //             offset: Offset(
      //               -MediaQuery.of(context).size.width * 2,
      //               -MediaQuery.of(context).size.height * 2,
      //             ),
      //             child: RepaintBoundary(
      //                 key: data[i]['globalKey'], child: data[i]['widget']),
      //           )
      //       ],
      //     ),
      //     const Center(
      //       child: CircularProgressIndicator(),
      //     )
      //   ]),
    );
  }

  Future<void> onBuildComplete() async {
    setState(() {
      isLoaded = true;
    });
    await Future.wait(
      data.map((value) async {
        // Marker? marker = await generateMarkerFromWidget(value);
        // if (marker != null) {
        //   markers[marker.markerId.value] = marker;
        // }
        // setState(() {
        //   isLoaded = true;
        // });
      }),
    );
  }

  Future<Marker?> generateMarkerFromWidget(Map<String, dynamic> data) async {
    print(center);
    RenderRepaintBoundary boundary =
        data["globalKey"].currentContext?.findRenderObject()
            as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 1);
    await image.toByteData(format: ui.ImageByteFormat.png);
    // TODO: Implement marker generation if needed
    // return Marker(
    //   markerId: MarkerId(data["id"]),
    //   position: center,
    //   icon: BitmapDescriptor.fromBytes(
    //     size: const Size(40, 40),
    //     byteData.buffer.asUint8List(),
    //   ),
    // );
    return null;
  }
}
