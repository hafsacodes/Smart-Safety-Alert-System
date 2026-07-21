import 'package:url_launcher/url_launcher.dart';

class MapService {

  Future<void> openMap(String mapUrl) async {

    final Uri uri = Uri.parse(mapUrl);

    if (await canLaunchUrl(uri)) {

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

    } else {

      throw Exception("Could not open Google Maps.");
    }
  }
}