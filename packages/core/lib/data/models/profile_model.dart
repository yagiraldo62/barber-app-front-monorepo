import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/appointment_model.dart';
import 'package:core/data/models/shared/location_model.dart';
// Avoid circular dependency - UserModel will import ProfileModel
// TODO: Create ProfileMediaModel for media relation
// TODO: Create ProfilePostModel for posts relation
// TODO: Create ArtistServiceModel for services relation
// TODO: Create LocationMemberModel for members and locations_worked relations
// TODO: Create UserProfileInteractionModel for user_interactions relation

/// Represents artist/organization profiles that provide services.
/// Maps to the `profiles` table in the database.
class ProfileModel {
  ProfileModel({
    this.id = '',
    this.name = '',
    this.type = ProfileType.artist,
    this.rate = 5.0,
  });

  // Primary fields
  String id;
  String name; // Unique profile name
  String? title; // Profile's professional title
  String? description; // Profile description
  String? photoUrl; // Profile photo URL
  ProfileType type; // 'artist' or 'organization'

  // Profile settings (JSONB field)
  double rate; // Profile rating (default: 5)
  bool? independentStateUp; // Artist only: independent setup completion
  bool? independentArtist; // Artist only: operates independently
  bool? servicesUp; // Organization only: services configuration status
  bool? availabilityUp; // Organization only: availability configuration status

  // Timestamps
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Relations
  // UserModel? owner; // Profile owner (avoiding circular dependency)
  String? ownerId; // Store owner ID instead
  List<CategoryModel>? categories; // Service categories (many-to-many)
  List<AppointmentModel>? appointments; // Appointments for this profile
  List<LocationModel>? locations; // Organization locations
  // List<ProfileMediaModel>? media; // Media files
  // List<ProfilePostModel>? posts; // Social posts
  // List<ArtistServiceModel>? services; // Artist services
  // List<UserProfileInteractionModel>? userInteractions; // User interactions
  // List<LocationMemberModel>? members; // Organization members
  // List<LocationMemberModel>? locationsWorked; // Locations where profile works

  /// Factory constructor from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> jsonData) {
    final profileSettings =
        jsonData['profile_settings'] as Map<String, dynamic>? ?? {};
    final profileType = _parseProfileType(jsonData['type'] as String?);

    return ProfileModel(
        id: jsonData['id'] as String? ?? '',
        name: jsonData['name'] as String? ?? '',
        type: profileType,
      )
      ..title = jsonData['title'] as String?
      ..description = jsonData['description'] as String?
      ..photoUrl = jsonData['photo_url'] as String?
      // Profile settings (from JSONB field)
      ..rate = (profileSettings['rate'] as num?)?.toDouble() ?? 5.0
      ..independentStateUp = profileSettings['independent_state_up'] as bool?
      ..independentArtist = profileSettings['independent_artist'] as bool?
      ..servicesUp = profileSettings['services_up'] as bool?
      ..availabilityUp = profileSettings['availability_up'] as bool?
      // Timestamps
      ..createdAt =
          jsonData['created_at'] != null
              ? DateTime.parse(jsonData['created_at'])
              : null
      ..updatedAt =
          jsonData['updated_at'] != null
              ? DateTime.parse(jsonData['updated_at'])
              : null
      ..deletedAt =
          jsonData['deleted_at'] != null
              ? DateTime.parse(jsonData['deleted_at'])
              : null
      // Relations
      ..ownerId = jsonData['owner']?['id'] as String?
      ..categories =
          jsonData['categories'] != null && jsonData['categories'] is List
              ? CategoryModel.listFromJson(jsonData['categories'])
              : null
      ..appointments =
          jsonData['appointments'] != null && jsonData['appointments'] is List
              ? AppointmentModel.listFromJson(jsonData['appointments'])
              : null
      ..locations =
          jsonData['locations'] != null && jsonData['locations'] is List
              ? LocationModel.listFromJson(jsonData['locations'])
              : null;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final profileSettings = <String, dynamic>{'rate': rate};

    // Add type-specific settings
    if (type == ProfileType.artist) {
      if (independentStateUp != null) {
        profileSettings['independent_state_up'] = independentStateUp;
      }
      if (independentArtist != null) {
        profileSettings['independent_artist'] = independentArtist;
      }
    } else if (type == ProfileType.organization) {
      if (servicesUp != null) {
        profileSettings['services_up'] = servicesUp;
      }
      if (availabilityUp != null) {
        profileSettings['availability_up'] = availabilityUp;
      }
    }

    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'photo_url': photoUrl,
      'type': type.toJson(),
      'profile_settings': profileSettings,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      if (ownerId != null) 'owner': {'id': ownerId},
      'categories': categories?.map((category) => category.toJson()).toList(),
      'appointments':
          appointments?.map((appointment) => appointment.toJson()).toList(),
      'locations': locations?.map((location) => location.toJson()).toList(),
    };
  }

  /// Convert to simplified JSON
  Map<String, dynamic> toSimplifiedJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'photo_url': photoUrl,
      'type': type.toJson(),
      'profile_settings': {
        'rate': rate,
        if (type == ProfileType.artist && independentStateUp != null)
          'independent_state_up': independentStateUp,
        if (type == ProfileType.artist && independentArtist != null)
          'independent_artist': independentArtist,
        if (type == ProfileType.organization && servicesUp != null)
          'services_up': servicesUp,
        if (type == ProfileType.organization && availabilityUp != null)
          'availability_up': availabilityUp,
      },
      'owner_id': ownerId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Parse profile type from string
  static ProfileType _parseProfileType(String? typeString) {
    switch (typeString?.toLowerCase()) {
      case 'organization':
        return ProfileType.organization;
      case 'artist':
      default:
        return ProfileType.artist;
    }
  }

  /// Convert list from JSON
  static List<ProfileModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData.map((profile) => ProfileModel.fromJson(profile)).toList()
          : [];
}

/// Enum for profile types
enum ProfileType {
  artist,
  organization;

  String toJson() {
    switch (this) {
      case ProfileType.artist:
        return 'artist';
      case ProfileType.organization:
        return 'organization';
    }
  }

  static ProfileType fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'organization':
        return ProfileType.organization;
      case 'artist':
      default:
        return ProfileType.artist;
    }
  }
}
