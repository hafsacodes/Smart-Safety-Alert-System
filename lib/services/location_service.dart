import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {

  Future<Position> getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check permission
    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        "Location permission permanently denied.",
      );
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  Future<String> getAddressFromCoordinates(
      double latitude,
      double longitude,
      ) async {
    final placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (placemarks.isEmpty) {
      return "$latitude, $longitude";
    }

    final place = placemarks.first;

    return [
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
      place.country,
    ]
        .where((item) => item != null && item.trim().isNotEmpty)
        .join(", ");
  }

}