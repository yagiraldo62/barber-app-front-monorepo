import 'package:core/data/models/shared/abstract/selectable_entity.dart';

class CategoryModel extends SelectableEntity {
  /// override selectable entity type
  CategoryModel() {
    type = "category";
  }

  String? parentId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  late List<CategoryModel> subcategories;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel()
        ..id = json['id'] as String
        ..name = json['name'] as String
        ..icon = json['icon'] as String?
        ..parentId = json['parent_id'] as String?
        ..selected = json['selected'] != null ? json['selected'] as bool : false
        ..createdAt =
            json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : null
        ..updatedAt =
            json['updated_at'] != null
                ? DateTime.parse(json['updated_at'] as String)
                : null
        ..deletedAt =
            json['deleted_at'] != null
                ? DateTime.parse(json['deleted_at'] as String)
                : null
        ..subcategories =
            json['subcategories'] != null
                ? CategoryModel.listFromJson(json['subcategories'])
                : [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'parent_id': parentId,
    'selected': selected ?? false,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    'subcategories':
        subcategories.map((category) => category.toJson()).toList(),
  };

  static List<CategoryModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData
              .map((category) => CategoryModel.fromJson(category))
              .toList()
          : [];
}
