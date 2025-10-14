import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/services_template_item_model.dart';

class ServicesTemplateModel {
  late String id;
  late String name;
  late String categoryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  late List<ServicesTemplateItemModel> items;
  CategoryModel? category;

  ServicesTemplateModel({
    this.id = "",
    this.name = "",
    this.categoryId = "",
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.items = const [],
    this.category,
  });

  factory ServicesTemplateModel.fromJson(Map<String, dynamic> json) =>
      ServicesTemplateModel(
        id: json['id'] as String? ?? "",
        name: json['name'] as String? ?? "",
        categoryId: json['category_id'] as String? ?? "",
        createdAt:
            json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : null,
        updatedAt:
            json['updated_at'] != null
                ? DateTime.parse(json['updated_at'] as String)
                : null,
        deletedAt:
            json['deleted_at'] != null
                ? DateTime.parse(json['deleted_at'] as String)
                : null,
        items:
            json['items'] != null
                ? ServicesTemplateItemModel.listFromJson(json['items'])
                : [],
        category:
            json['category'] != null
                ? CategoryModel.fromJson(json['category'])
                : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category_id': categoryId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    'items': items.map((item) => item.toJson()).toList(),
    'category': category?.toJson(),
  };

  static List<ServicesTemplateModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData
              .map((template) => ServicesTemplateModel.fromJson(template))
              .toList()
          : [];
}
