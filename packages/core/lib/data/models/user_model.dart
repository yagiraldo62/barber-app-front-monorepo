import 'package:core/data/models/appointment_model.dart';
import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/location_member_model.dart';

class UserModel {
  UserModel();

  // Primary fields
  late String id;
  late String? name;
  late String? username;
  late String? email;
  late String? phoneNumber;
  late String? phoneNumberVerificationCode;
  late DateTime? phoneNumberVerifiedAt;
  late String? photoURL;
  late Map<String, dynamic>? location; // Geographic point

  // User settings (JSONB field)
  late bool isFirstLogin;
  late bool isOrganizationMember;

  // Timestamps
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late DateTime? deletedAt;

  // Relations
  late List<CategoryModel>? categories; // User interests (many-to-many)
  late List<AppointmentModel>? appointments; // Appointments as client
  late List<ProfileModel>? profiles; // Owned profiles
  late List<LocationMemberModel>? locationsWorked; // Locations where user works
  // TODO: Add profiles_interactions when UserProfileInteractionModel is created
  // late List<UserProfileInteractionModel>? profilesInteractions;

  /// FACTORY UserModel from a json user object
  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    final userSettings =
        jsonData['user_settings'] as Map<String, dynamic>? ?? {};

    return UserModel()
      ..id = jsonData['id'] as String? ?? ""
      ..name = jsonData['name'] as String? ?? ""
      ..username = jsonData['username'] as String? ?? ""
      ..email = jsonData['email'] as String? ?? ""
      ..phoneNumber = jsonData['phone_number'] as String?
      ..phoneNumberVerificationCode =
          jsonData['phone_number_verification_code'] as String?
      ..phoneNumberVerifiedAt =
          jsonData['phone_number_verified_at'] != null
              ? DateTime.parse(jsonData['phone_number_verified_at'])
              : null
      ..photoURL = jsonData['photo_url'] as String?
      ..location = jsonData["location"] as Map<String, dynamic>?
      // User settings (from JSONB field)
      ..isFirstLogin = userSettings['is_first_login'] as bool? ?? true
      ..isOrganizationMember =
          userSettings['is_organization_member'] as bool? ?? false
      // Timestamps
      ..createdAt =
          jsonData["created_at"] != null
              ? DateTime.parse(jsonData["created_at"])
              : null
      ..updatedAt =
          jsonData["updated_at"] != null
              ? DateTime.parse(jsonData["updated_at"])
              : null
      ..deletedAt =
          jsonData["deleted_at"] != null
              ? DateTime.parse(jsonData["deleted_at"])
              : null
      // Relations
      ..categories =
          jsonData['categories'] != null && jsonData['categories'] is List
              ? CategoryModel.listFromJson(jsonData['categories'])
              : null
      ..appointments =
          jsonData['appointments'] != null && jsonData['appointments'] is List
              ? AppointmentModel.listFromJson(jsonData['appointments'])
              : null
      ..profiles =
          jsonData['profiles'] != null && jsonData['profiles'] is List
              ? ProfileModel.listFromJson(jsonData['profiles'])
              : null
      ..locationsWorked =
          jsonData['locations_worked'] != null &&
                  jsonData['locations_worked'] is List
              ? LocationMemberModel.listFromJson(jsonData['locations_worked'])
              : null;
  }

  /// CONVERT json from a UserModel
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'phone_number': phoneNumber,
    'photo_url': photoURL,
    'location': location,
    'user_settings': {
      'is_first_login': isFirstLogin,
      'is_organization_member': isOrganizationMember,
    },
    'phone_number_verified_at': phoneNumberVerifiedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    'categories': categories?.map((category) => category.toJson()).toList(),
    'appointments':
        appointments?.map((appointment) => appointment.toJson()).toList(),
    'profiles': profiles?.map((profile) => profile.toJson()).toList(),
    'locations_worked':
        locationsWorked?.map((location) => location.toJson()).toList(),
  };

  /// CONVERT json from a UserModel (simplified version)
  Map<String, dynamic> toSimplifiedJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'phone_number': phoneNumber,
    'photo_url': photoURL,
    'user_settings': {
      'is_first_login': isFirstLogin,
      'is_organization_member': isOrganizationMember,
    },
    'created_at': createdAt?.toIso8601String(),
  };

  /// Returns true if the user's phone number has been verified
  bool get isPhoneVerified => phoneNumberVerifiedAt != null;

  void upsertProfile(ProfileModel profile) {
    profiles ??= [];

    // Find the index of the profile in the list, based on ID
    final int index = (profiles ?? []).indexWhere((p) => p.id == profile.id);

    if (index != -1) {
      // If the profile exists in the list, update it
      profiles![index] = profile;
    } else {
      // If the profile doesn't exist, add it to the list
      profiles!.add(profile);
    }
  }
}
