import 'dart:typed_data';

import 'package:core/data/models/artists/artist_model.dart';
import 'package:core/modules/artist/providers/artist_provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ArtistRepository {
  ArtistProvider artistProvider = Get.find<ArtistProvider>();

  Future<ArtistModel> findOrSave(
    ArtistModel artist,
    bool justFind,
    Uint8List? image,
  ) async {
    try {
      ArtistModel? existentArtist = await find(artist.id);

      if (justFind) {
        if (existentArtist != null) {
          return existentArtist;
        }
      }

      String? photoUrl = existentArtist?.photoUrl ?? artist.photoUrl;

      artist.photoUrl = photoUrl;

      return artist;
    } catch (e) {
      rethrow;
    }
  }

  Future<ArtistModel?> find(String id) async {
    const data = null;

    if (data != null) {
      return ArtistModel.fromJson(data);
    }
    return null;
  }

  Future<ArtistModel?> create(
    String name,
    List<String> categoriesId,
    String title,
    String description,
    XFile? image,
  ) async {
    try {
      ArtistModel? artistResponse = await artistProvider.createArtist(
        name,
        categoriesId,
        title,
        description,
      );

      if (artistResponse != null && image != null) {
        ArtistModel? updateArtistPhotoResponse = await artistProvider
            .updateArtistPhoto(artistResponse.id, image);

        if (updateArtistPhotoResponse != null) {
          artistResponse.photoUrl = updateArtistPhotoResponse.photoUrl;
        }
      }

      if (artistResponse != null) return artistResponse;

      throw Exception('Error creating artist');
    } catch (e) {
      rethrow;
    }
  }

  Future<ArtistModel?> update(
    String id,
    String name,
    List<String> categoriesId,
    String title,
    String description,
    XFile? image,
  ) async {
    try {
      ArtistModel? artistResponse = await artistProvider.updateArtist(
        id,
        name,
        categoriesId,
        title,
        description,
      );

      if (artistResponse != null && image != null) {
        ArtistModel? updateArtistPhotoResponse = await artistProvider
            .updateArtistPhoto(artistResponse.id, image);

        if (updateArtistPhotoResponse != null) {
          artistResponse.photoUrl = updateArtistPhotoResponse.photoUrl;
        }
      }

      if (artistResponse != null) return artistResponse;

      throw Exception('Error updating artist');
    } catch (e) {
      rethrow;
    }
  }
}
