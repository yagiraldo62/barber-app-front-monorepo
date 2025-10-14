class ServicesTemplateItemModel {
  late String id;
  late String name;
  late int duration;
  late num price;
  late String subcategoryId;
  late String servicesTemplateId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  ServicesTemplateItemModel({
    this.id = "",
    this.name = "",
    this.duration = 0,
    this.price = 0,
    this.subcategoryId = "",
    this.servicesTemplateId = "",
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ServicesTemplateItemModel.fromJson(Map<String, dynamic> json) =>
      ServicesTemplateItemModel(
        id: json['id'] as String? ?? "",
        name: json['name'] as String? ?? "",
        duration: json['duration'] as int? ?? 0,
        price: json['price'] as num? ?? 0,
        subcategoryId: json['subcategory_id'] as String? ?? "",
        servicesTemplateId: json['services_template_id'] as String? ?? "",
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
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'duration': duration,
    'price': price,
    'subcategory_id': subcategoryId,
    'services_template_id': servicesTemplateId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };

  static List<ServicesTemplateItemModel> listFromJson(
    List<dynamic>? jsonData,
  ) =>
      jsonData != null
          ? jsonData
              .map((item) => ServicesTemplateItemModel.fromJson(item))
              .toList()
          : [];
}
