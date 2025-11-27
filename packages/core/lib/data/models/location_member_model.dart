import 'dart:convert';

import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/shared/location_model.dart';
import 'package:core/data/models/user_model.dart';
// Avoid circular dependency by not importing UserModel here

/// Manages membership relationships between users and locations.
/// Maps to the `location_members` table in the database.
class LocationMemberModel {
  LocationMemberModel({
    this.id = '',
    this.role = LocationMemberRole.member,
    this.isActive = true,
    this.servicesUp = false,
    this.availabilityUp = false,
  });

  // Primary fields
  String id;
  LocationMemberRole role; // 'member', 'manager', 'super-admin'
  bool isActive; // Default true
  String? invitationPhoneNumber; // Contact phone number
  String? invitationReceptorName; // Name of invitation recipient

  // Location member settings (JSONB field)
  bool servicesUp; // Member services configuration status
  bool availabilityUp; // Member availability configuration status

  // Invitation fields
  DateTime? acceptedAt; // When invitation was accepted
  DateTime? declinedAt; // When invitation was declined
  String? invitationToken; // Token for invitation process
  DateTime? tokenExpirationDate; // Token expiration

  // Timestamps
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Relations
  ProfileModel? organization; // Parent organization
  LocationModel?
  location; // Work location (Note: this is typically found in organization.locations)
  ProfileModel? artist; // Artist profile (if member is an artist)
  // UserModel? member; // The member user (avoiding circular dependency)
  UserModel? member; // Avoid circular dependency
  String? memberId; // Store member ID instead

  /// Factory constructor from JSON
  factory LocationMemberModel.fromJson(Map<String, dynamic> jsonData) {
    final memberSettings =
        jsonData['location_member_settings'] as Map<String, dynamic>? ?? {};
    final role = _parseRole(jsonData['role'] as String?);

    return LocationMemberModel(
        id: jsonData['id'] as String? ?? '',
        role: role,
        isActive: jsonData['is_active'] as bool? ?? true,
      )
      ..invitationPhoneNumber = jsonData['invitation_phone_number'] as String?
      ..invitationReceptorName = jsonData['invitation_receptor_name'] as String?
      // Location member settings (from JSONB field)
      ..servicesUp = memberSettings['services_up'] as bool? ?? false
      ..availabilityUp = memberSettings['availability_up'] as bool? ?? false
      // Invitation fields
      ..acceptedAt =
          jsonData['accepted_at'] != null
              ? DateTime.parse(jsonData['accepted_at'])
              : null
      ..declinedAt =
          jsonData['declined_at'] != null
              ? DateTime.parse(jsonData['declined_at'])
              : null
      ..invitationToken = jsonData['invitation_token'] as String?
      ..tokenExpirationDate =
          jsonData['token_expiration_date'] != null
              ? DateTime.parse(jsonData['token_expiration_date'])
              : null
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
      ..organization =
          jsonData['organization'] != null
              ? ProfileModel.fromJson(jsonData['organization'])
              : null
      ..location =
          jsonData['location'] != null
              ? LocationModel.fromJson(jsonData['location'])
              : null
      ..member =
          jsonData['member'] != null
              ? UserModel.fromJson(jsonData['member'])
              : null
      ..artist =
          jsonData['artist'] != null
              ? ProfileModel.fromJson(jsonData['artist'])
              : null
      ..memberId = jsonData['member']?['id'] as String?;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.toJson(),
      'is_active': isActive,
      'location_member_settings': {
        'services_up': servicesUp,
        'availability_up': availabilityUp,
      },
      'accepted_at': acceptedAt?.toIso8601String(),
      'declined_at': declinedAt?.toIso8601String(),
      'invitation_phone_number': invitationPhoneNumber,
      'invitation_receptor_name': invitationReceptorName,
      'invitation_token': invitationToken,
      'token_expiration_date': tokenExpirationDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'organization': organization?.toJson(),
      'location': location?.toJson(),
      'artist': artist?.toJson(),
      'member': member?.toJson(),
    };
  }

  /// Convert to simplified JSON
  Map<String, dynamic> toSimplifiedJson() {
    return {
      'id': id,
      'role': role.toJson(),
      'is_active': isActive,
      'location_member_settings': {
        'services_up': servicesUp,
        'availability_up': availabilityUp,
      },
      'accepted_at': acceptedAt?.toIso8601String(),
      'organization_id': organization?.id,
      'location_id': location?.id,
      'artist_id': artist?.id,
      'member_id': memberId,
    };
  }

  /// Parse role from string
  static LocationMemberRole _parseRole(String? roleString) {
    switch (roleString?.toLowerCase()) {
      case 'super-admin':
        return LocationMemberRole.superAdmin;
      case 'manager':
        return LocationMemberRole.manager;
      case 'member':
      default:
        return LocationMemberRole.member;
    }
  }

  /// Convert list from JSON
  static List<LocationMemberModel> listFromJson(List<dynamic>? jsonData) =>
      jsonData != null
          ? jsonData
              .map((member) => LocationMemberModel.fromJson(member))
              .toList()
          : [];
}

/// Enum for location member roles
enum LocationMemberRole {
  member,
  manager,
  superAdmin;

  String toJson() {
    switch (this) {
      case LocationMemberRole.member:
        return 'member';
      case LocationMemberRole.manager:
        return 'manager';
      case LocationMemberRole.superAdmin:
        return 'super-admin';
    }
  }

  static LocationMemberRole fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'super-admin':
        return LocationMemberRole.superAdmin;
      case 'manager':
        return LocationMemberRole.manager;
      case 'member':
      default:
        return LocationMemberRole.member;
    }
  }
}
