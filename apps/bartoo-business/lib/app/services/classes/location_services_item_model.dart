class LocationServicesItemModel {
  final String? id;
  final String artistLocationId;
  final String serviceId;
  final String categoryId;
  final String name;
  final int duration;
  final double price;
  final bool isActive;

  // Añadir este campo para identificar nuevos servicios
  final bool isNewService;

  LocationServicesItemModel({
    this.id,
    required this.artistLocationId,
    required this.serviceId,
    required this.categoryId,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.isNewService,
  });

  factory LocationServicesItemModel.fromJson(Map<String, dynamic> jsonData) {
    return LocationServicesItemModel(
      id: jsonData['id'] as String?,
      artistLocationId: jsonData['artist_location_id'] as String? ?? "",
      serviceId: jsonData['service_id'] as String? ?? "",
      categoryId: jsonData['category_id'] as String? ?? "",
      name: jsonData['name'] as String? ?? "",
      duration: jsonData['duration'] as int? ?? 0,
      price: (jsonData['price'] as num?)?.toDouble() ?? 0.0,
      isActive: jsonData['is_active'] as bool? ?? false,
      isNewService: jsonData['is_new_service'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      if (id != null) 'id': id,
      'artist_location_id': artistLocationId,
      'service_id': serviceId,
      'category_id': categoryId,
      'name': name,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'is_new_service': isNewService,
    };
    return data;
  }

  static List<LocationServicesItemModel> listFromJson(
    List<dynamic>? jsonData,
  ) =>
      jsonData != null
          ? jsonData
              .map((service) => LocationServicesItemModel.fromJson(service))
              .toList()
          : [];

  // Método copyWith para crear una copia del objeto con algunos campos modificados
  LocationServicesItemModel copyWith({
    String? id,
    String? artistLocationId,
    String? serviceId,
    String? categoryId,
    String? name,
    int? duration,
    double? price,
    bool? isActive,
    bool? isNewService,
  }) {
    return LocationServicesItemModel(
      id: id ?? this.id,
      artistLocationId: artistLocationId ?? this.artistLocationId,
      serviceId: serviceId ?? this.serviceId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
      isNewService: isNewService ?? this.isNewService,
    );
  }
}
