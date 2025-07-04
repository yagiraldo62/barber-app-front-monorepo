import 'package:core/data/models/shared/abstract/selectable_entity.dart';

class CategoryServiceModel extends SelectableEntity {
  /// override selectable entity type
  CategoryServiceModel() {
    type = "service";
  }

  String? categoryId;
  int? duration;
  int? defaultDuration;
  num? price;
  num? defaultPrice;
  bool? isMostCommon;
  DateTime? createdAt;

  factory CategoryServiceModel.fromJson(Map<String, dynamic> json) {
    return CategoryServiceModel()
      ..id = json['id'] as String
      ..categoryId = json['category_id'] as String?
      ..name = json['name'] as String?
      ..icon = json['icon'] as String?
      ..duration = json['duration'] as int?
      ..defaultDuration = json['default_duration'] as int?
      ..price = json['price'] as num?
      ..defaultPrice = json['default_price'] as num?
      ..isMostCommon = json['is_most_common'] as bool?
      ..status = json['status'] as int?
      ..selected = json['selected'] != null ? json['selected'] as bool : false
      ..createdAt =
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_id': categoryId,
    'name': name,
    'icon': icon,
    'duration': duration,
    'default_duration': defaultDuration,
    'price': price,
    'default_price': defaultPrice,
    'status': status,
    'is_most_common': isMostCommon,
    'created_at': createdAt?.toIso8601String(),
    'selected': selected ?? false,
  };

  static List<CategoryServiceModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? (jsonData).map((service) {
            if (service["service"] != null) {
              service["service"]["duration"] = service["duration"];
              service["service"]["price"] = service["price"];
              return CategoryServiceModel.fromJson(service["service"]);
            }

            return CategoryServiceModel.fromJson(service);
          }).toList()
          : [];
}
