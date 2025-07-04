import 'package:core/data/models/artists/artist_model.dart';
import 'package:core/data/models/user/user_model.dart';

class AuthState {
  final String? token;
  final UserModel? user;
  final ArtistModel? selectedArtist;

  const AuthState({this.token, this.user, this.selectedArtist});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'token': token,
    'user': user?.toJson(),
    'selected_artist': selectedArtist?.toJson(),
  };
}
