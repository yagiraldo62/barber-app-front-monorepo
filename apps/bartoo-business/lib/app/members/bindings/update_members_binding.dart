import 'package:bartoo/app/members/controllers/update_members_controller.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:get/get.dart';

class UpdateMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateMembersController>(() => UpdateMembersController());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
