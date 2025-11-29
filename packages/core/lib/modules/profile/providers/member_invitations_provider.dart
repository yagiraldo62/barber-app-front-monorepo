import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/member_model.dart';
import 'package:utils/log.dart';

class MemberInvitationsProvider extends BaseProvider {
  final String _baseUrl = '/members/invitations';

  /// Send an invitation to a new team member
  Future<Map<String, dynamic>?> sendInvitation({
    required String phoneNumber,
    required String receptorName,
    required String organizationId,
    String? locationId,
    required String role,
    required String sendBy,
  }) async {
    final Map<String, dynamic> body = {
      'phone_number': phoneNumber,
      'receptor_name': receptorName,
      'organization_id': organizationId,
      'role': role,
      'send_by': sendBy,
    };

    if (locationId != null) {
      body['location_id'] = locationId;
    }

    final response = await post(_baseUrl, body);

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(response.body?["data"]);

    return response.body?["data"];
  }

  /// Get invitation details by token (public endpoint, no auth required)
  Future<MemberModel?> getInvitationByToken(String token) async {
    final response = await get('$_baseUrl/$token');

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(response.body?["data"]);

    return MemberModel.fromJson(response.body?["data"]);
  }

  /// Accept or decline an invitation
  Future<Map<String, dynamic>?> respondToInvitation({
    required String token,
    required String action,
  }) async {
    final Map<String, dynamic> body = {'token': token, 'action': action};

    final response = await post('$_baseUrl/respond', body);

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(response.body?["data"]);

    return response.body?["data"];
  }

  /// Accept an invitation (convenience method)
  Future<Map<String, dynamic>?> acceptInvitation(String token) =>
      respondToInvitation(token: token, action: 'accept');

  /// Decline an invitation (convenience method)
  Future<Map<String, dynamic>?> declineInvitation(String token) =>
      respondToInvitation(token: token, action: 'decline');

  /// Resend an invitation to an existing pending invitation
  Future<Map<String, dynamic>?> resendInvitation({
    required String phoneNumber,
    required String organizationId,
    String? locationId,
    String sendBy = 'sms',
  }) async {
    final Map<String, dynamic> body = {
      'phone_number': phoneNumber,
      'organization_id': organizationId,
      'send_by': sendBy,
    };

    if (locationId != null && locationId.isNotEmpty) {
      body['location_id'] = locationId;
    }

    final response = await post('$_baseUrl/resend', body);

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(response.body?["data"]);

    return response.body?["data"];
  }
}
