import 'package:base/providers/base_provider.dart';
import 'package:utils/log.dart';
import 'package:core/data/models/artists/artist_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ArtistProvider extends BaseProvider {
  Future<ArtistModel?> createArtist(
    String name,
    List<String> categoriesId,
    String title,
    String description,
  ) async {
    final response = await post('/artists', {
      'name': name,
      'categories_id': categoriesId,
      'title': title,
      'description': description,
    });

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    print(ArtistModel.fromJson(response.body?["data"]).toJson());

    return response.body?["data"] != null
        ? ArtistModel.fromJson(response.body?["data"])
        : null;
  }

  Future<ArtistModel?> updateArtist(
    String id,
    String name,
    List<String> categoriesId,
    String title,
    String description,
  ) async {
    final response = await post("/artists/$id/update", {
      'name': name,
      'categories_id': categoriesId,
      'title': title,
      'description': description,
    });

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(ArtistModel.fromJson(response.body?["data"]).toJson());

    return response.body?["data"] != null
        ? ArtistModel.fromJson(response.body?["data"])
        : null;
  }

  Future<ArtistModel?> updateArtistPhoto(String id, XFile image) async {
    final bytes = await image.readAsBytes();

    final response = await post(
      "/artists/$id/photo",
      FormData({'photo': MultipartFile(bytes, filename: image.name)}),
      contentType: "multipart/form-data",
    );

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    return response.body?["data"] != null
        ? ArtistModel.fromJson(response.body?["data"])
        : null;
  }

  // To update the categories of an artist, we need to send a list of categories id to the backend.
  Future<bool> updateArtistCategories(
    String id,
    List<String> categoriesId,
  ) async {
    final response = await put(
      '/artists/$id/categories',
      FormData({'categories_id': categoriesId}),
    );

    if (response.body?["ok"] == true) {
      return true;
    }

    return false;
  }

  Future<bool> upsertArtistService({
    required String artistId,
    required String name,
    required int duration,
    required double price,
    required List<String> servicesId,
  }) async {
    final response = await put(
      '/artists/$artistId/services',
      FormData({
        "name": name,
        "duration": duration,
        "price": price,
        "services_id": servicesId,
      }),
    );

    if (response.body?["ok"] == true) {
      return true;
    }

    return false;
  }
}
