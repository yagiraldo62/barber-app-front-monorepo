import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_page.dart';

void main() {
  group('LocationPickerPage', () {
    testWidgets('should render without crashing', (WidgetTester tester) async {
      bool callbackCalled = false;
      LatLng? selectedLocation;

      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerPage(
            initialLocation: const LatLng(4.7110, -74.0721),
            onLocationSelected: (location) {
              callbackCalled = true;
              selectedLocation = location;
            },
          ),
        ),
      );

      // Wait for the widget to render
      await tester.pumpAndSettle();

      // Verify the app bar is rendered
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Select Location'), findsOneWidget);
    });

    testWidgets('should show custom title', (WidgetTester tester) async {
      const customTitle = 'Pick Your Location';

      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerPage(
            title: customTitle,
            onLocationSelected: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(customTitle), findsOneWidget);
    });

    testWidgets('should show custom confirm button text', (
      WidgetTester tester,
    ) async {
      const customButtonText = 'SAVE';

      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerPage(
            confirmButtonText: customButtonText,
            onLocationSelected: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(customButtonText), findsOneWidget);
    });

    testWidgets('should show centered pin icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerPage(
            initialLocation: const LatLng(4.7110, -74.0721),
            onLocationSelected: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the person pin icon is present
      expect(find.byIcon(Icons.person_pin_circle), findsOneWidget);
    });

    testWidgets('should show helper instructions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerPage(
            initialLocation: const LatLng(4.7110, -74.0721),
            onLocationSelected: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify helper text is present
      expect(
        find.text('Move the map to place the pin on your desired location'),
        findsOneWidget,
      );
    });

    testWidgets('should show my location button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerPage(
            initialLocation: const LatLng(4.7110, -74.0721),
            onLocationSelected: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify my location button is present
      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    testWidgets('should show confirm button at bottom', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerPage(
            initialLocation: const LatLng(4.7110, -74.0721),
            onLocationSelected: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify confirm button is present
      expect(find.text('Confirm Location'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('should initialize with provided location', (
      WidgetTester tester,
    ) async {
      const testLocation = LatLng(4.7110, -74.0721);

      await tester.pumpWidget(
        MaterialApp(
          home: LocationPickerPage(
            initialLocation: testLocation,
            onLocationSelected: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should not show loading indicator
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show loading indicator initially without location', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: LocationPickerPage(onLocationSelected: (_) {})),
      );

      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('LatLng', () {
    test('should create valid coordinates', () {
      const location = LatLng(4.7110, -74.0721);

      expect(location.latitude, 4.7110);
      expect(location.longitude, -74.0721);
    });

    test('should compare coordinates correctly', () {
      const location1 = LatLng(4.7110, -74.0721);
      const location2 = LatLng(4.7110, -74.0721);
      const location3 = LatLng(5.0000, -75.0000);

      expect(location1 == location2, true);
      expect(location1 == location3, false);
    });
  });
}
