import 'package:core/data/models/week_day_availability.dart';

class AvailabilityTemplateModel {
  final String id;
  final String name;
  final String description;
  final Availability items;

  AvailabilityTemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.items,
  });

  factory AvailabilityTemplateModel.fromJson(Map<String, dynamic> json) {
    // Parse items and group by weekday
    final List<dynamic> itemsList = json['items'] as List<dynamic>;
    final Availability groupedItems = {};

    for (var item in itemsList) {
      final weekdayItem = WeekdayAvailabilityModel.fromJson(item);
      final weekday = weekdayItem.weekday;

      if (groupedItems.containsKey(weekday)) {
        groupedItems[weekday]!.add(weekdayItem);
      } else {
        groupedItems[weekday] = [weekdayItem];
      }
    }

    return AvailabilityTemplateModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      items: groupedItems,
    );
  }

  Map<String, dynamic> toJson() {
    // Flatten the grouped items back to a list
    final List<Map<String, dynamic>> itemsList = [];
    items.forEach((weekday, availabilities) {
      for (var availability in availabilities) {
        itemsList.add(availability.toJson());
      }
    });

    return {
      'id': id,
      'name': name,
      'description': description,
      'items': itemsList,
    };
  }

  static List<AvailabilityTemplateModel> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => AvailabilityTemplateModel.fromJson(json))
        .toList();
  }
}
