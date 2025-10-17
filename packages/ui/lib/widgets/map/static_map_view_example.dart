import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/static_map_view.dart';

/// Ejemplos de uso del widget StaticMapView
class StaticMapViewExamples extends StatelessWidget {
  const StaticMapViewExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StaticMapView Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Example 1: Basic Static Map
          _buildExample(
            context,
            title: '1. Mapa Estático Básico (300px)',
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const StaticMapView(
                location: LatLng(4.7110, -74.0721), // Bogotá
                zoom: 15.0,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Example 2: Custom Marker
          _buildExample(
            context,
            title: '2. Marcador Personalizado',
            child: SizedBox(
              height: 250,
              child: const StaticMapView(
                location: LatLng(6.2442, -75.5812), // Medellín
                zoom: 14.0,
                markerIcon: Icons.store,
                markerColor: Colors.blue,
                markerSize: 50,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Example 3: Close Zoom
          _buildExample(
            context,
            title: '3. Zoom Cercano (18.0)',
            child: SizedBox(
              height: 250,
              child: const StaticMapView(
                location: LatLng(10.3910, -75.4794), // Cartagena
                zoom: 18.0,
                markerIcon: Icons.location_on,
                markerColor: Colors.red,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Example 4: No Marker
          _buildExample(
            context,
            title: '4. Sin Marcador',
            child: SizedBox(
              height: 200,
              child: const StaticMapView(
                location: LatLng(3.4516, -76.5320), // Cali
                zoom: 13.0,
                showMarker: false,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Example 5: Multiple Maps in Grid
          _buildExample(
            context,
            title: '5. Múltiples Mapas en Grid',
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: const [
                StaticMapView(
                  location: LatLng(4.7110, -74.0721),
                  zoom: 12.0,
                  markerColor: Colors.red,
                ),
                StaticMapView(
                  location: LatLng(6.2442, -75.5812),
                  zoom: 12.0,
                  markerColor: Colors.blue,
                ),
                StaticMapView(
                  location: LatLng(10.3910, -75.4794),
                  zoom: 12.0,
                  markerColor: Colors.green,
                ),
                StaticMapView(
                  location: LatLng(3.4516, -76.5320),
                  zoom: 12.0,
                  markerColor: Colors.orange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Example 6: In a Card
          _buildExample(
            context,
            title: '6. Dentro de una Card',
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: const StaticMapView(
                      location: LatLng(7.8939, -72.5078), // Cúcuta
                      zoom: 14.0,
                      markerIcon: Icons.business,
                      markerColor: Colors.purple,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mi Negocio',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16),
                            SizedBox(width: 4),
                            Text('Cúcuta, Colombia'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Example 7: Different Heights
          _buildExample(
            context,
            title: '7. Diferentes Alturas',
            child: Column(
              children: [
                Container(
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const StaticMapView(
                    location: LatLng(4.7110, -74.0721),
                    zoom: 13.0,
                  ),
                ),
                Container(
                  height: 250,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const StaticMapView(
                    location: LatLng(4.7110, -74.0721),
                    zoom: 15.0,
                  ),
                ),
                Container(
                  height: 350,
                  child: const StaticMapView(
                    location: LatLng(4.7110, -74.0721),
                    zoom: 17.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// Example: Dynamic Location Update
class DynamicMapExample extends StatefulWidget {
  const DynamicMapExample({super.key});

  @override
  State<DynamicMapExample> createState() => _DynamicMapExampleState();
}

class _DynamicMapExampleState extends State<DynamicMapExample> {
  LatLng currentLocation = const LatLng(4.7110, -74.0721);

  final List<Map<String, dynamic>> cities = [
    {'name': 'Bogotá', 'location': const LatLng(4.7110, -74.0721)},
    {'name': 'Medellín', 'location': const LatLng(6.2442, -75.5812)},
    {'name': 'Cali', 'location': const LatLng(3.4516, -76.5320)},
    {'name': 'Barranquilla', 'location': const LatLng(10.9639, -74.7964)},
    {'name': 'Cartagena', 'location': const LatLng(10.3910, -75.4794)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Map Update')),
      body: Column(
        children: [
          // Map
          Container(
            height: 400,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: StaticMapView(
              location: currentLocation,
              zoom: 14.0,
              markerIcon: Icons.location_city,
              markerColor: Colors.red,
              markerSize: 45,
            ),
          ),

          // City selector
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                final isSelected = currentLocation == city['location'];

                return ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color: isSelected ? Colors.red : Colors.grey,
                  ),
                  title: Text(
                    city['name'],
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.red : Colors.black,
                    ),
                  ),
                  trailing:
                      isSelected
                          ? const Icon(Icons.check, color: Colors.red)
                          : null,
                  onTap: () {
                    setState(() {
                      currentLocation = city['location'];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
