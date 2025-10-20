import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:utils/log.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends BaseProvider {
  final String _baseUrl = '/profiles';

  Future<ProfileModel?> createProfile({
    String? name,
    String? title,
    String? description,
    ProfileType type = ProfileType.artist,
    List<String> categoriesId = const [],
    bool? independentArtist,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'categories_id': categoriesId,
      'title': title,
      'type': type.toJson(),
      'description': description,
    };

    if (independentArtist != null) {
      body['profile_settings'] = {'independent_artist': independentArtist};
    }

    final response = await post('$_baseUrl', body);

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(ProfileModel.fromJson(response.body?["data"]).toJson());

    return response.body?["data"] != null
        ? ProfileModel.fromJson(response.body?["data"])
        : null;
  }

  Future<ProfileModel?> updateProfile(
    String id,
    String name,
    List<String> categoriesId,
    String title,
    String description, {
    bool? independentArtist,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'categories_id': categoriesId,
      'title': title,
      'description': description,
    };

    if (independentArtist != null) {
      body['independent_artist'] = independentArtist;
    }

    final response = await post('$_baseUrl/$id/update', body);

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    Log(ProfileModel.fromJson(response.body?["data"]).toJson());

    return response.body?["data"] != null
        ? ProfileModel.fromJson(response.body?["data"])
        : null;
  }

  Future<ProfileModel?> updateProfilePhoto(String id, XFile image) async {
    final bytes = await image.readAsBytes();

    final response = await post(
      "$_baseUrl/$id/photo",
      FormData({'photo': MultipartFile(bytes, filename: image.name)}),
      contentType: "multipart/form-data",
    );

    if ((response.body?["ok"] ?? false) != true) {
      return null;
    }

    return response.body?["data"] != null
        ? ProfileModel.fromJson(response.body?["data"])
        : null;
  }

  // To update the categories of an artist, we need to send a list of categories id to the backend.
  Future<bool> updateProfileCategories(
    String id,
    List<String> categoriesId,
  ) async {
    final response = await put(
      '$_baseUrl/$id/categories',
      FormData({'categories_id': categoriesId}),
    );

    if (response.body?["ok"] == true) {
      return true;
    }

    return false;
  }

  Future<bool> upsertProfileService({
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
