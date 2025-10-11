import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/location_member_model.dart';

/// Represents the selected scope for a user session.
/// Can be either a ProfileModel or a LocationMemberModel.
sealed class BussinessScope {
  const BussinessScope();

  Map<String, dynamic> toJson();

  factory BussinessScope.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final data = json['data'] as Map<String, dynamic>;

    if (type == 'location_member') {
      return LocationMemberScope(LocationMemberModel.fromJson(data));
    } else if (type == 'profile') {
      return ProfileScope(ProfileModel.fromJson(data));
    } else {
      // Fallback: Try to detect based on structure
      if (data.containsKey('organization') ||
          data.containsKey('artist') ||
          data.containsKey('role')) {
        return LocationMemberScope(LocationMemberModel.fromJson(data));
      } else {
        return ProfileScope(ProfileModel.fromJson(data));
      }
    }
  }
}

/// Scope representing a ProfileModel (artist or organization profile)
class ProfileScope extends BussinessScope {
  final ProfileModel profile;

  const ProfileScope(this.profile);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'profile',
    'data': profile.toJson(),
  };
}

/// Scope representing a LocationMemberModel (member of an organization location)
class LocationMemberScope extends BussinessScope {
  final LocationMemberModel locationMember;

  const LocationMemberScope(this.locationMember);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'location_member',
    'data': locationMember.toJson(),
  };
}
