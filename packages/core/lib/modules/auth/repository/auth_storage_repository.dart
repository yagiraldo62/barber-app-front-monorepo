import 'dart:convert';

import 'package:core/modules/auth/classes/auth_state.dart';
import 'package:utils/storage_manager.dart';
import 'package:core/data/models/artists/artist_model.dart';
import 'package:core/data/models/user/user_model.dart';

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

  ///Stores or removes selected artist data from storage
  Future<void> setSelectedArtist(ArtistModel? artist) {
    return setValue(
      SELECTED_ARTIST,
      artist != null ? json.encode(artist.toJson()) : null,
    );
  }

  Future<ArtistModel?> getSelectedArtist() async {
    String? storedArtist = await getValue(SELECTED_ARTIST);

    return storedArtist != null
        ? ArtistModel.fromJson(json.decode(storedArtist))
        : null;
  }

  /// Retrieves the authentication state.
  ///
  /// This method retrieves the current authentication state by fetching the user,
  /// token, and selected artist from the storage. It returns an [AuthState] object
  /// containing the retrieved values.
  ///
  /// Returns:
  /// - [AuthState]: The authentication state containing the user, token, and selected artist.
  Future<AuthState> getAuthState() async {
    UserModel? user = await getAuthUser();
    String? token = await getAuthToken();
    ArtistModel? artist = await getSelectedArtist();

    return AuthState(token: token, user: user, selectedArtist: artist);
  }

  /// Sets the authentication state.
  ///
  /// This method sets the authentication state by storing the user, token, and selected
  /// artist in the storage.
  ///
  /// Parameters:
  /// - [state]: The authentication state to be set.
  void setAuthState(AuthState state) {
    setAuthUser(state.user);
    setAuthToken(state.token);
    setSelectedArtist(state.selectedArtist);
  }
}
