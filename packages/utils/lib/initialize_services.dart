import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';

Future<void> initializeServices() async {
  // Call the conditionally imported function
  if (kIsWeb) {
    setPathUrlStrategy();
  }

  // Deshabilitar Impeller en desarrollo para dispositivos iOS
  if (!kReleaseMode) {
    debugPrintRebuildDirtyWidgets = false;
    debugPrintLayouts = false;

    // Configurar manejo de errores global
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
  }

  // // Forzar orientación vertical
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the shared .env file at the root
  await dotenv.load(fileName: "../../.env");

  // Moment.setGlobalLocalization(MomentLocalizations.es());
}
