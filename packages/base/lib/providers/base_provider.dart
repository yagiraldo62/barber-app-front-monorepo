import 'package:utils/log.dart';
import 'package:utils/storage_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class BaseProvider extends GetConnect with StorageManager {
  @override
  void onInit() {
    super.onInit();

    httpClient.baseUrl = dotenv.env['API_URL'];

    httpClient.addAuthenticator<dynamic>((request) async {
      String? token = await getValue(AUTH_TOKEN);

      Log('BaseProvider: Authenticator: $token');

      request.headers['Authorization'] = 'Bearer $token';

      return request;
    });

    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }
}
