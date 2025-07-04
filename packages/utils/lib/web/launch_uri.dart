import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchUri(
  String uri, {
  LaunchMode mode = LaunchMode.platformDefault,
}) async {
  final Uri url = Uri.parse(uri);

  try {
    if (kIsWeb) {
      // En web, usamos la implementación web
      return await launchUrl(url, webOnlyWindowName: '_self');
    } else {
      // En iOS y Android usamos url_launcher con opciones específicas
      return await launchUrl(
        url,
        mode: mode,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    }
  } catch (e) {
    print('Error al abrir la URL $url: $e');
    return false;
  }
}
