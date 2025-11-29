import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/member_model.dart';
import 'package:utils/log.dart';

class MembersProvider extends BaseProvider {
  final String _baseUrl = '/members';

  /// Create a location member directly (administrative)
  Future<MemberModel?> createMember({
    required String organizationId,
    required String locationId,
    required String memberId,
    String? artistId,
    required String role,
  }) async {
    final Map<String, dynamic> body = {
      'organization_id': organizationId,
      'location_id': locationId,
      'member_id': memberId,
      'role': role,
    };

    if (artistId != null) {
      body['artist_id'] = artistId;
    }

    final response = await post(_baseUrl, body);

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(MemberModel.fromJson(response.body?["data"]).toJson());

    return response.body?["data"] != null
        ? MemberModel.fromJson(response.body?["data"])
        : null;
  }

  /// Get all location members with optional filtering
  Future<List<MemberModel>?> getMembers({
    String? organizationId,
    String? locationId,
    String? memberId,
    String? artistId,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (organizationId != null) {
      queryParams['organization_id'] = organizationId;
    }
    if (locationId != null) {
      queryParams['location_id'] = locationId;
    }
    if (memberId != null) {
      queryParams['member_id'] = memberId;
    }
    if (artistId != null) {
      queryParams['artist_id'] = artistId;
    }

    final response = await get(
      _baseUrl,
      query: queryParams.isNotEmpty ? queryParams : null,
    );

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    if (response.body?["data"] == null) {
      return [];
    }

    final List<dynamic> dataList = response.body?["data"] ?? [];
    Log('Members list: $dataList');
    return dataList.map((item) => MemberModel.fromJson(item)).toList();
  }

  /// Get a specific location member by ID
  Future<MemberModel?> getMemberById(String id) async {
    final response = await get('$_baseUrl/$id');

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    return response.body?["data"] != null
        ? MemberModel.fromJson(response.body?["data"])
        : null;
  }

  /// Update a location member
  Future<MemberModel?> updateMember(
    String id, {
    String? role,
    Map<String, dynamic>? locationMemberSettings,
  }) async {
    final Map<String, dynamic> body = {};

    if (role != null) {
      body['role'] = role;
    }
    if (locationMemberSettings != null) {
      body['location_member_settings'] = locationMemberSettings;
    }

    final response = await post('$_baseUrl/$id', body);

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(MemberModel.fromJson(response.body?["data"]).toJson());

    return response.body?["data"] != null
        ? MemberModel.fromJson(response.body?["data"])
        : null;
  }

  /// Delete a location member (hard delete)
  Future<bool> deleteMember(String id) async {
    final response = await delete('$_baseUrl/$id');

    if (response.body?["ok"] == true) {
      return true;
    }

    return false;
  }

  /// Revoke member access (soft delete)
  Future<MemberModel?> revokeMember(
    String id, {
    required String organizationId,
    required String locationId,
  }) async {
    final Map<String, dynamic> body = {
      'organization_id': organizationId,
      'location_id': locationId,
    };

    final response = await post('$_baseUrl/$id/revoke', body);

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(MemberModel.fromJson(response.body?["data"]).toJson());

    return response.body?["data"] != null
        ? MemberModel.fromJson(response.body?["data"])
        : null;
  }
}
