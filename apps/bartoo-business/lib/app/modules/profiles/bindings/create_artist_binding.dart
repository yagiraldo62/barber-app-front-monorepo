import 'package:core/modules/artist/providers/artist_provider.dart';
import 'package:core/modules/category/providers/category_provider.dart';
import 'package:core/modules/category/repository/category_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:core/modules/artist/repository/artist_repository.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';

import 'package:get/get.dart';

class CreateArtistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtistProvider>(() => ArtistProvider());
    Get.lazyPut<CategoryProvider>(() => CategoryProvider());
    Get.lazyPut<CategoryRepository>(() => CategoryRepository());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<ArtistRepository>(() => ArtistRepository());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
