import 'package:get/get.dart';

class ArtistBottomNavigationController extends GetxController {
  final selectedIndex = 0.obs;

  // Map of navigation slugs to index numbers
  static const Map<String, int> navSlugToIndex = {
    '': 0,
    'schedule': 1,
    'liquidator': 2,
    'settings': 3,
  };

  // Map of index numbers to navigation slugs
  static const Map<int, String> navIndexToSlug = {
    0: '',
    1: 'schedule',
    2: 'liquidator',
    3: 'settings',
  };

  @override
  void onInit() {
    super.onInit();
    _loadNavIndexFromRoute();
  }

  void _loadNavIndexFromRoute() {
    final navIndexParam = Get.parameters['nav_index'];
    if (navIndexParam != null && navSlugToIndex.containsKey(navIndexParam)) {
      selectedIndex.value = navSlugToIndex[navIndexParam]!;
    }
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
    // Update the route with the new nav_index slug
    final slug = navIndexToSlug[index] ?? '';
    Get.toNamed('/$slug', preventDuplicates: true);
  }
}
