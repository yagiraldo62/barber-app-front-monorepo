import 'dart:convert';

import 'package:core/data/models/member_model.dart';
import 'package:core/modules/auth/classes/auth_state.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:utils/storage_manager.dart';
import 'package:core/data/models/user_model.dart';

class AuthStorageRepository with StorageManager {
  AuthStorageRepository();

  ///Stores or removes user data from storage
  Future<void> setAuthUser(UserModel? user) =>
      setValue(AUTH_USER, user != null ? json.encode(user.toJson()) : null);

  Future<UserModel?> getAuthUser() async {
    String? storedUser = await getValue(AUTH_USER);
    return storedUser != null
        ? UserModel.fromJson(json.decode(storedUser))
        : null;
  }

  /// Stores or removes user data from storage
  Future<void> setAuthToken(String? token) => setValue(AUTH_TOKEN, token);

  Future<String?> getAuthToken() async {
    String? token = await getValue(AUTH_TOKEN);
    return token;
  }

  ///Stores or removes selected scope data from storage
  Future<void> setSelectedScope(BussinessScope? scope) {
    return setValue(
      SELECTED_SCOPE,
      scope != null ? json.encode(scope.toJson()) : null,
    );
  }

  Future<BussinessScope?> getSelectedScope() async {
    String? storedScope = await getValue(SELECTED_SCOPE);

    if (storedScope == null) return null;

    final jsonData = json.decode(storedScope);
    return BussinessScope.fromJson(jsonData);
  }

  // Pending invitation
  setPendingInvitation(MemberModel? invitationToken) {
    setValue(
      PENDING_INVITATION,
      invitationToken != null ? json.encode(invitationToken.toJson()) : null,
    );
  }

  Future<MemberModel?> getPendingInvitation() async {
    String? storedInvitation = await getValue(PENDING_INVITATION);
    return storedInvitation != null
        ? MemberModel.fromJson(json.decode(storedInvitation))
        : null;
  }

  /// Retrieves the authentication state.
  ///
  /// This method retrieves the current authentication state by fetching the user,
  /// token, and selected scope from the storage. It returns an [AuthState] object
  /// containing the retrieved values.
  ///
  /// Returns:
  /// - [AuthState]: The authentication state containing the user, token, and selected scope.
  Future<AuthState> getAuthState() async {
    UserModel? user = await getAuthUser();
    String? token = await getAuthToken();
    BussinessScope? scope = await getSelectedScope();

    return AuthState(token: token, user: user, selectedScope: scope);
  }

  /// Sets the authentication state.
  ///
  /// This method sets the authentication state by storing the user, token, and selected
  /// scope in the storage.
  ///
  /// Parameters:
  /// - [state]: The authentication state to be set.
  void setAuthState(AuthState state) {
    setAuthUser(state.user);
    setAuthToken(state.token);
    setSelectedScope(state.selectedScope);
  }
}
