abstract class SelectableEntity {
  late String id;
  String? name;
  String? icon;
  int? status;
  bool? selected = false;
  String type = "category";

  void toggleSelection() {
    selected = !(selected ?? false);
  }
}
