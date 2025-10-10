import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:core/data/models/user_model.dart';

class AuthState {
  final String? token;
  final UserModel? user;
  final SelectedScope? selectedScope;

  const AuthState({this.token, this.user, this.selectedScope});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'token': token,
    'user': user?.toJson(),
    'selected_scope': selectedScope?.toJson(),
  };
}
