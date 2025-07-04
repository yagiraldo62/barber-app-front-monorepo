import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:core/data/models/user/user_model.dart';
import 'package:core/data/models/artists/artist_model.dart';
import 'package:get/get.dart';

/// Business app specific auth controller implementation
class BusinessAuthController extends BaseAuthController {
  // Business-specific properties
  Rx<ArtistModel?> selectedArtist = Rx<ArtistModel?>(null);

  @override
  void onUserSet(UserModel? user) {
    super.onUserSet(user);
    // Business-specific logic when user is set
    setSelectedArtistFromUser(user);
  }

  void setSelectedArtistFromUser(UserModel? user) {
    if (user?.artists != null &&
        user!.artists!.isNotEmpty &&
        selectedArtist.value == null) {
      setSelectedArtist(user.artists!.first);
    }
  }

  void setSelectedArtist(ArtistModel? newArtist) {
    selectedArtist.value = newArtist;
    onSelectedArtistSet(newArtist);
  }

  /// Called when selected artist is set - business-specific logic
  void onSelectedArtistSet(ArtistModel? artist) {
    // Business-specific logic when artist is selected
    // For example: load artist-specific data, update permissions, etc.
  }

  bool hasSelectedArtistLocations() {
    return selectedArtist.value?.locations != null &&
        selectedArtist.value!.locations!.isNotEmpty;
  }

  @override
  void onSignout() {
    super.onSignout();
    // Business-specific cleanup when user signs out
    selectedArtist.value = null;
  }
}
