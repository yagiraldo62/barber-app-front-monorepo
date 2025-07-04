import 'package:core/data/models/user/user_model.dart';
import 'package:core/data/models/artists/artist_model.dart';

/// Interface defining callback functions that apps must implement
/// to customize authentication behavior
abstract class AuthCallbacks {
  /// Called after successful login to handle app-specific login logic
  /// [user] - The authenticated user
  Future<void> onLogin(UserModel user);

  /// Called to determine where to redirect user after login
  /// [user] - The authenticated user (can be null)
  void onLoginRedirection(UserModel? user);

  /// Called after successful logout to handle app-specific cleanup
  Future<void> onLogout();

  /// Called when user location needs to be set
  /// [user] - The user to set location for
  /// Returns the updated user with location
  Future<UserModel> onSetUserLocation(UserModel user);

  /// Called to validate authentication state for guards
  /// [user] - The current user (can be null)
  /// [selectedArtist] - The current selected artist (can be null)
  Future<void> onAuthValidation(UserModel? user, ArtistModel? selectedArtist);
}
