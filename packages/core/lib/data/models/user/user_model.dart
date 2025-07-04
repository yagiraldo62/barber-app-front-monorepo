import 'package:core/data/models/appointment/appointment_model.dart';
import 'package:core/data/models/artists/artist_model.dart';

class UserModel {
  UserModel();

  late bool isFirstLogin = false;

  late String id;
  late String? name;
  late String? username;
  late String? email;
  late String? phoneNumber;
  late String? photoURL;
  late Map<String, dynamic>? location;
  late List<ArtistModel> relatedArtists;
  late DateTime? createdAt;
  late List<AppointmentModel>? pendingAppointments = [];
  late List<ArtistModel>? artists = [];

  /// FACTORY UserModel from a json user object
  factory UserModel.fromJson(Map<String, dynamic> jsonData) =>
      UserModel()
        ..id = jsonData['id'] as String? ?? ""
        ..name = jsonData['name'] as String? ?? ""
        ..isFirstLogin = jsonData['is_first_login'] as bool? ?? true
        ..username = jsonData['username'] as String? ?? ""
        ..email = jsonData['email'] as String? ?? ""
        ..phoneNumber = jsonData['phone_number'] as String? ?? ""
        ..photoURL = jsonData['photo_url'] as String? ?? ""
        ..location = jsonData["location"] as Map<String, double>?
        ..createdAt =
            jsonData["created_at"] != null
                ? DateTime.parse(jsonData["created_at"])
                : null
        ..pendingAppointments = AppointmentModel.listFromJson(
          jsonData['pending_appointments'],
        )
        ..artists = ArtistModel.listFromJson(jsonData['artists']);

  /// CONVERT json from a UserModel
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
    'is_first_login': isFirstLogin,
    'phone_number': phoneNumber,
    'photo_url': photoURL,
    'created_at': createdAt.toString(),
    'pending_appointments':
        pendingAppointments
            ?.map((appointment) => appointment.toJson())
            .toList(),
    'artists': artists?.map((artist) => artist.toJson()).toList(),
  };

  /// CONVERT json from a UserModel
  Map<String, dynamic> toSimplifiedJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
    'phone_number': phoneNumber,
    'is_first_login': isFirstLogin,
    'photo_url': photoURL,
    'created_at': createdAt.toString(),
  };

  void upsertArtist(ArtistModel artist) {
    artists ??= [];

    // Find the index of the artist in the list, based on UID
    final int index = (artists ?? []).indexWhere((a) => a.id == artist.id);

    if (index != -1) {
      // If the artist exists in the list, update it
      artists![index] = artist;
    } else {
      // If the artist doesn't exist, add it to the list
      artists!.add(artist);
    }
  }
}
