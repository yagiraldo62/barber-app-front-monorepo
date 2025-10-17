import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:ui' as ui;
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/map_marker.dart';

List<Map<String, dynamic>> data = [
  {'id': '1', 'globalKey': GlobalKey(), 'widget': MarkerImage()},
];

class MapBoxView extends StatefulWidget {
  const MapBoxView({super.key});

  @override
  State<MapBoxView> createState() => _MapBoxViewState();
}

class _MapBoxViewState extends State<MapBoxView> {
  String? lightMapStyle;
  String? darkMapStyle;
  bool isDark = false;
  Map<String, Marker> markers = {};
  List<Map<String, dynamic>> markersResources = <Map<String, dynamic>>[];
  // LatLng? center = const LatLng(45.521563, -122.677433);
  LatLng? center;
  bool isLoaded = false;

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Map<String, dynamic>? pos = authController.user.value?.location;
    //   print(pos);
    //   if (pos != null) {
    //     Timer(const Duration(milliseconds: 300), () {
    //       setState(() {
    //         center = LatLng(pos['latitude'], pos['longitude']);
    //       });
    //       onBuildComplete();
    //     });
    //   } else {
    //     getUserCurrentLocation().then((Position? pos) {
    //       if (pos != null) {
    //         setState(() {
    //           center = LatLng(pos.latitude, pos.longitude);
    //         });
    //         onBuildComplete();
    //       }
    //     });
    //   }
    // });

    // rootBundle
    //     .loadString('assets/map_styles/light_map_style.txt')
    //     .then((string) {
    //   lightMapStyle = string;
    //   // setMapStyle();
    // });
    // rootBundle
    //     .loadString('assets/map_styles/dark_map_style.txt')
    //     .then((string) {
    //   darkMapStyle = string;
    //   // setMapStyle();
    // });

    // themeManager.addListener(setMapStyle);
  }

  @override
  void dispose() {
    // themeManager.removeListener(setMapStyle);
    super.dispose();
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
                child: FlutterMap(
                  options: MapOptions(
                    minZoom: 5,
                    maxZoom: 18,
                    // zoom: 13,
                    // center: center,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: dotenv.env['MAPBOX_DARK_URL']!,
                      additionalOptions: {
                        'mapStyleId': dotenv.env['MAPBOX_DARK_STYLE_ID']!,
                        'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN']!,
                      },
                      errorTileCallback: (tileimage, obj, stk) {
                        print(tileimage);
                        print(obj);
                        print(stk);
                      },
                    ),
                  ],
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
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // return Marker(
    //   markerId: MarkerId(data["id"]),
    //   position: center!,
    //   icon: BitmapDescriptor.fromBytes(
    //     size: const Size(40, 40),
    //     byteData.buffer.asUint8List(),
    //   ),
    // );
    return null;
  }
}
