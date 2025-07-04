import 'dart:typed_data';

import 'package:core/data/models/user/user_model.dart';

class UserRepository {
  Future<UserModel?> findOrSave(
    UserModel user,
    bool justFind,
    Uint8List? image,
  ) async {
    try {
      UserModel? existentUser = await find(user.id);

      if (justFind) {
        if (existentUser != null) {
          return existentUser;
        }
      }

      if (existentUser == null) {
        await upsert(user, image);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> find(String uid) async {
    const data = null;

    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  Future<UserModel?> upsert(UserModel user, Uint8List? image) async {
    try {
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
