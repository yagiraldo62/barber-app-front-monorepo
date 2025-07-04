import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ui/widgets/avatar/user_avatar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Marker?> getUserMarker(
  BuildContext context,
  LatLng center,
  GlobalKey markerKey,
) async {
  GlobalKey markerKey = getUserMarkerKey(context);
  Uint8List? markerUint8List = await getUint8List(markerKey);
  print("markerUint8List");
  print(markerUint8List);
  if (markerUint8List != null) {
    return Marker(
      markerId: MarkerId(markerKey.toString()),
      position: center,
      icon: BitmapDescriptor.fromBytes(
        markerUint8List,
        size: const Size(40, 40),
      ),
    );
  }
  return null;
}

Future<Map<String, dynamic>?> getUserMarkerResources(
  BuildContext context,
  LatLng center,
) async {
  GlobalKey markerKey = getUserMarkerKey(context);
  print(markerKey);
  // Uint8List? markerUint8List = await getUint8List(markerKey);
  // print('markerUint8List');
  // print(markerUint8List);

  return {
    "markerKey": markerKey,
    // "bitmapDescriptor": BitmapDescriptor.fromBytes(markerUint8List),
    "center": center,
    "repaintBoundary": RepaintBoundary(key: markerKey, child: MarkerImage()),
  };

  // if (markerUint8List != null) {
  //   return {
  //     "markerKey": markerKey.toString(),
  //     // "bitmapDescriptor": BitmapDescriptor.fromBytes(markerUint8List),
  //     "center": center,
  //     "repaintBoundary": RepaintBoundary(
  //       key: markerKey,
  //       child: MarkerImage(context),
  //     )
  //   };
  // }
}

GlobalKey getUserMarkerKey(BuildContext context) {
  final markerKey = GlobalKey();

  return markerKey;
}

Widget MarkerImage() {
  return Builder(
    builder: (context) {
      return AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(20),
            child: UserAvatar(asset: true, src: "assets/images/b1.jpg"),
          ),
        ),
      );
    },
  );
}

Future<Uint8List?> getUint8List(GlobalKey markerKey) async {
  http.Response response = await http.get(
    Uri.https(
      'upload.wikimedia.org',
      'wikipedia/en/b/b5/Tupac_Amaru_Shakur2.jpg',
    ),
  );

  return response.bodyBytes.buffer.asUint8List();
}
