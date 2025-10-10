// This file demonstrates how to use the SelectedScope sealed class
// DO NOT IMPORT THIS FILE IN PRODUCTION CODE - IT'S JUST AN EXAMPLE

import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/location_member_model.dart';

/// Example: How to create a SelectedScope

void exampleCreateScope() {
  // Create a ProfileScope
  final profile = ProfileModel(
    id: '123',
    name: 'Bella Vista Beauty Studio',
    type: ProfileType.organization,
  );
  final profileScope = ProfileScope(profile);

  // Create a LocationMemberScope
  final locationMember = LocationMemberModel(
    id: '456',
    role: LocationMemberRole.superAdmin,
  );
  final locationMemberScope = LocationMemberScope(locationMember);
}

/// Example: How to use pattern matching with SelectedScope

void examplePatternMatching(SelectedScope? scope) {
  if (scope == null) {
    print('No scope selected');
    return;
  }

  // Using switch expression (Dart 3.0+)
  switch (scope) {
    case ProfileScope(:final profile):
      print('Working as profile: ${profile.name}');
      print('Profile type: ${profile.type}');

      // Access profile-specific data
      if (profile.type == ProfileType.organization) {
        print('Organization with ${profile.locations?.length ?? 0} locations');
      }

    case LocationMemberScope(:final locationMember):
      print('Working as location member');
      print('Role: ${locationMember.role}');
      print('Organization: ${locationMember.organization?.name}');
      print('Location: ${locationMember.location?.name}');

      // Access location member-specific data
      if (locationMember.role == LocationMemberRole.superAdmin) {
        print('User has super admin privileges');
      }
  }
}

/// Example: Alternative using if-case

void exampleIfCase(SelectedScope? scope) {
  if (scope case ProfileScope(:final profile)) {
    // Handle ProfileScope
    print('Profile: ${profile.name}');
  } else if (scope case LocationMemberScope(:final locationMember)) {
    // Handle LocationMemberScope
    print('Location Member at: ${locationMember.organization?.name}');
  }
}

/// Example: Getting specific data based on scope type

String getScopeName(SelectedScope scope) {
  return switch (scope) {
    ProfileScope(:final profile) => profile.name,
    LocationMemberScope(:final locationMember) =>
      locationMember.organization?.name ?? 'Unknown',
  };
}

/// Example: Checking scope type

bool isOrganizationScope(SelectedScope scope) {
  return switch (scope) {
    ProfileScope(:final profile) => profile.type == ProfileType.organization,
    LocationMemberScope() => true, // Always part of an organization
  };
}

/// Example: In a real-world scenario - Displaying scope info in UI

class ScopeDisplay {
  final SelectedScope scope;

  ScopeDisplay(this.scope);

  String get displayName => switch (scope) {
    ProfileScope(:final profile) => profile.name,
    LocationMemberScope(:final locationMember) =>
      '${locationMember.organization?.name} - ${locationMember.location?.name}',
  };

  String get roleDescription => switch (scope) {
    ProfileScope(:final profile) =>
      profile.type == ProfileType.artist
          ? 'Independent Artist'
          : 'Organization Owner',
    LocationMemberScope(:final locationMember) =>
      'Member (${locationMember.role.toJson()})',
  };

  bool get canManageServices => switch (scope) {
    ProfileScope(:final profile) => profile.servicesUp ?? false,
    LocationMemberScope(:final locationMember) =>
      locationMember.role == LocationMemberRole.superAdmin ||
          locationMember.role == LocationMemberRole.manager,
  };
}
