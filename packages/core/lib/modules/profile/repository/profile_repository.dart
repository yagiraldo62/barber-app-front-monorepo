import 'dart:typed_data';

import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/modules/profile/providers/profile_provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepository {
  ProfileProvider profileProvider = Get.find<ProfileProvider>();

  Future<ProfileModel> findOrSave(
    ProfileModel artist,
    bool justFind,
    Uint8List? image,
  ) async {
    try {
      ProfileModel? existentProfile = await find(artist.id);

      if (justFind) {
        if (existentProfile != null) {
          return existentProfile;
        }
      }

      String? photoUrl = existentProfile?.photoUrl ?? artist.photoUrl;

      artist.photoUrl = photoUrl;

      return artist;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileModel?> find(String id) async {
    const data = null;

    if (data != null) {
      return ProfileModel.fromJson(data);
    }
    return null;
  }

  Future<ProfileModel> create({
    String? name,
    List<String>? categoriesId,
    ProfileType type = ProfileType.artist,
    String? title,
    String? description,
    XFile? image,
  }) async {
    try {
      ProfileModel? createdProfile = await profileProvider.createProfile(
        name: name,
        categoriesId: categoriesId ?? [],
        type: type,
        title: title,
        description: description,
      );

      if (createdProfile != null && image != null) {
        ProfileModel? updateProfilePhotoResponse = await profileProvider
            .updateProfilePhoto(createdProfile.id, image);

        if (updateProfilePhotoResponse != null) {
          createdProfile.photoUrl = updateProfilePhotoResponse.photoUrl;
        }
      }

      if (createdProfile != null) return createdProfile;

      throw Exception('Error creating artist');
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileModel?> update(
    String id,
    String name,
    List<String> categoriesId,
    String title,
    String description,
    XFile? image,
  ) async {
    try {
      ProfileModel? artistResponse = await profileProvider.updateProfile(
        id,
        name,
        categoriesId,
        title,
        description,
      );

      if (artistResponse != null && image != null) {
        ProfileModel? updateProfilePhotoResponse = await profileProvider
            .updateProfilePhoto(artistResponse.id, image);

        if (updateProfilePhotoResponse != null) {
          artistResponse.photoUrl = updateProfilePhotoResponse.photoUrl;
        }
      }

      if (artistResponse != null) return artistResponse;

      throw Exception('Error updating artist');
    } catch (e) {
      rethrow;
    }
  }
}

class ProfileCreationResponse {
  ProfileModel? profile;
  UserModel? user;
  String? error;

  ProfileCreationResponse({this.profile, this.user, this.error});
}
