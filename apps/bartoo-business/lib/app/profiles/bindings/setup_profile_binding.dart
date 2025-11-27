import 'package:bartoo/app/locations/bindings/location_form_binding.dart';
import 'package:bartoo/app/profiles/controllers/setup_scope_controller.dart';
import 'package:core/modules/category/providers/category_provider.dart';
import 'package:core/modules/category/repository/category_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:core/modules/profile/providers/profile_provider.dart';
import 'package:core/modules/profile/repository/profile_repository.dart';

import 'package:get/get.dart';

class SetupScopeBinding extends LocationFormBinding {
  @override
  void dependencies() {
    super.dependencies();

    Get.lazyPut<SetupScopeController>(() => SetupScopeController());
    Get.lazyPut<ProfileProvider>(() => ProfileProvider());
    Get.lazyPut<CategoryProvider>(() => CategoryProvider());
    Get.lazyPut<CategoryRepository>(() => CategoryRepository());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<ProfileRepository>(() => ProfileRepository());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
