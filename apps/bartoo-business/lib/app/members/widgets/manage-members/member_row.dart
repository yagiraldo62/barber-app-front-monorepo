import 'package:flutter/material.dart' hide Typography;
import 'package:core/data/models/member_model.dart';
import 'package:ui/widgets/typography/typography.dart';

class MemberRow extends StatelessWidget {
  final MemberModel member;
  final bool isInvitation;
  final VoidCallback? onRevoke;
  final VoidCallback? onCancelInvitation;
  final VoidCallback? onResendInvitation;

  const MemberRow({
    super.key,
    required this.member,
    this.isInvitation = false,
    this.onRevoke,
    this.onCancelInvitation,
    this.onResendInvitation,
  });

  String _roleString() => member.role.toJson();

  String _getInitials() {
    // If member exists, use their name
    if (member.member?.name != null && member.member!.name!.isNotEmpty) {
      final name = member.member!.name!;
      final parts = name.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }

    // If invitation with receptor name, use that
    if (isInvitation &&
        member.invitationReceptorName != null &&
        member.invitationReceptorName!.isNotEmpty) {
      final name = member.invitationReceptorName!;
      final parts = name.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }

    // Fallback to phone number
    if (isInvitation && member.invitationPhoneNumber != null) {
      return member.invitationPhoneNumber!.substring(0, 2);
    }

    // Last resort: use role
    final role = _roleString();
    return role.isNotEmpty ? role.characters.first.toUpperCase() : '?';
  }

  String _getDisplayName() {
    // If member exists, show their info
    if (member.member != null) {
      return member.member!.name ??
          member.member!.username ??
          member.member!.email ??
          'Unknown';
    }

    // If invitation, show receptor name
    if (isInvitation && member.invitationReceptorName != null) {
      return member.invitationReceptorName!;
    }

    // Fallback to role
    return _roleString().replaceAll('_', ' ').toUpperCase();
  }

  Widget _buildSubtitle() {
    final role = _roleString();

    if (isInvitation) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Typography(
            'Pending invitation · ${role.replaceAll('_', ' ')}',
            variation: TypographyVariation.bodySmall,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          if (member.invitationPhoneNumber != null)
            Typography(
              member.invitationPhoneNumber!,
              variation: TypographyVariation.labelSmall,
            ),
          // if (member.location?.name != null)
          //   Typography(
          //     'Location: ${member.location!.name}',
          //     variation: TypographyVariation.labelSmall,
          //     color: Colors.grey,
          //   ),
        ],
      );
    }

    // Accepted member
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Typography(
          role.replaceAll('-', ' '),
          variation: TypographyVariation.bodySmall,
        ),
        // if (member.member?.phoneNumber != null)
        //   Typography(
        //     member.member!.phoneNumber!,
        //     variation: TypographyVariation.labelSmall,
        //   ),
        // if (member.location?.name != null)
        //   Typography(
        //     'Location: ${member.location!.name}',
        //     variation: TypographyVariation.labelSmall,
        //     color: Colors.grey,
        //   ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Typography(
          _getInitials(),
          variation: TypographyVariation.labelMedium,
        ),
      ),
      title: Typography(
        _getDisplayName(),
        variation: TypographyVariation.bodyLarge,
      ),
      subtitle: _buildSubtitle(),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isInvitation && onRevoke != null)
            IconButton(
              tooltip: 'Revoke access',
              icon: const Icon(Icons.block),
              onPressed: onRevoke,
            ),
          if (isInvitation &&
              (onCancelInvitation != null || onResendInvitation != null))
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Invitation options',
              onSelected: (value) {
                switch (value) {
                  case 'resend':
                    onResendInvitation?.call();
                    break;
                  case 'cancel':
                    onCancelInvitation?.call();
                    break;
                }
              },
              itemBuilder:
                  (BuildContext context) => [
                    if (onResendInvitation != null)
                      PopupMenuItem<String>(
                        value: 'resend',
                        child: Row(
                          children: [
                            const Icon(Icons.send),
                            const SizedBox(width: 8),
                            Typography(
                              'Resend invitation',
                              variation: TypographyVariation.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    if (onCancelInvitation != null)
                      PopupMenuItem<String>(
                        value: 'cancel',
                        child: Row(
                          children: [
                            const Icon(Icons.cancel),
                            const SizedBox(width: 8),
                            Typography(
                              'Cancel invitation',
                              variation: TypographyVariation.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                  ],
            ),
        ],
      ),
    );
  }
}
