import 'package:get/get.dart';

enum ArtistAppointmentsMenuOption { pending, history }

class ArtistAppointmentsMenuController extends GetxController {
  RxList<bool> menuOptions = [true, false].obs;
  Rx<int> selectedMenuOptionIndex = 0.obs;

  List<ArtistAppointmentsMenuOption> optionIndexes =
      ArtistAppointmentsMenuOption.values;

  void selectMenuOption(int menuOptionIndex) {
    var newMenuOptions = menuOptions.map((number) => false).toList();

    newMenuOptions[menuOptionIndex] = true;
    menuOptions.value = newMenuOptions;
    selectedMenuOptionIndex.value = menuOptionIndex;
  }
}
