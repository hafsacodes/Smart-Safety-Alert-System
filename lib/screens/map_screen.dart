import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/sos_alert_model.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../models/incident_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final LocationService _locationService = LocationService();
  final FirestoreService _firestoreService = FirestoreService();

  Position? currentPosition;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCurrentLocation();
  }

  Future<void> loadCurrentLocation() async {

    try {

      final location =
      await _locationService.getCurrentLocation();

      if (!mounted) return;

      setState(() {
        currentPosition = location;
        isLoading = false;
      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> openGoogleMaps() async {

    if (currentPosition == null) return;

    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${currentPosition!.latitude},${currentPosition!.longitude}",
    );

    if (await canLaunchUrl(url)) {

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

    } else {

      throw "Could not open Google Maps.";
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

        backgroundColor: Colors.white,

        body: SafeArea(

            child: SingleChildScrollView(

                child: Padding(

                  padding: const EdgeInsets.all(20),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                    const Text(
                    "Safety Map",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Track nearby incidents & safe zones",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                    const SizedBox(height: 22),

                    Container(

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 8,
                          ),

                        ],
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(
                            "Current Location",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "Your current GPS location has been detected successfully.",
                            style: TextStyle(
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 18),

                          SizedBox(

                            width: double.infinity,

                            child: ElevatedButton.icon(

                              onPressed: openGoogleMaps,

                              icon: const Icon(Icons.map),

                              label: const Text(
                                "Open in Google Maps",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                      children: [

                        statusItem(
                          Colors.red,
                          "High",
                        ),

                        statusItem(
                          Colors.orange,
                          "Medium",
                        ),

                        statusItem(
                          Colors.green,
                          "Safe Zone",
                        ),

                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        const Text(
                          "Recent SOS Alerts",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        GestureDetector(

                          onTap: () {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Showing Live Alerts",
                                ),
                              ),
                            );
                          },

                          child: const Text(

                            "Refresh",

                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    StreamBuilder<List<SosAlertModel>>(

                        stream:
                        _firestoreService.getSOSAlerts(),

                        builder: (context, snapshot) {

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {

                            return const Center(
                              child: Text(
                                "Unable to load alerts",
                              ),
                            );
                          }

                          final alerts =
                              snapshot.data ?? [];

                          if (alerts.isEmpty) {

                            return const Center(

                              child: Padding(

                                padding: EdgeInsets.all(30),

                                child: Text(

                                  "No SOS alerts found.",

                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(

                              shrinkWrap: true,

                              physics:
                              const NeverScrollableScrollPhysics(),

                              itemCount: alerts.length,

                              itemBuilder:
                                  (context, index) {

                                final alert = alerts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),

                                  child: Container(
                                    padding: const EdgeInsets.all(16),

                                    decoration: BoxDecoration(
                                      color: Colors.white,

                                      borderRadius:
                                      BorderRadius.circular(18),

                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade100,
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                      children: [

                                        Row(
                                          children: [

                                            CircleAvatar(
                                              radius: 24,

                                              backgroundColor:
                                              Colors.red.withValues(
                                                alpha: 0.15,
                                              ),

                                              child: const Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                              ),
                                            ),

                                            const SizedBox(width: 14),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                                children: [

                                                  Text(
                                                    alert.userName,

                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 4),

                                                  const Text(
                                                    "Emergency SOS Alert",

                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Container(

                                              padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),

                                              decoration: BoxDecoration(

                                                color: alert.status == "Active"
                                                    ? Colors.red.withValues(
                                                  alpha: 0.15,
                                                )
                                                    : Colors.green.withValues(
                                                  alpha: 0.15,
                                                ),

                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),

                                              child: Text(

                                                alert.status,

                                                style: TextStyle(
                                                  color:
                                                  alert.status == "Active"
                                                      ? Colors.red
                                                      : Colors.green,

                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 18),

                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(alert.location),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 16),

                                        SizedBox(

                                          width: double.infinity,

                                          child: ElevatedButton.icon(

                                            onPressed: () async {

                                              final Uri uri = Uri.parse(
                                                alert.mapUrl,
                                              );

                                              if (await canLaunchUrl(uri)) {

                                                await launchUrl(
                                                  uri,
                                                  mode: LaunchMode
                                                      .externalApplication,
                                                );
                                              }
                                            },

                                            icon: const Icon(Icons.map),

                                            label: const Text(
                                              "Open Alert Location",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                  },
                          );
                        },
                    ),

                      const SizedBox(height: 30),

                      const Text(
                        "Recent Incident Reports",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      StreamBuilder<List<IncidentModel>>(
                        stream: _firestoreService.getIncidents(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Unable to load incidents"),
                            );
                          }

                          final incidents = snapshot.data ?? [];

                          if (incidents.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  "No incidents reported yet.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: incidents.length,
                            itemBuilder: (context, index) {
                              final incident = incidents[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          children: [

                                            CircleAvatar(
                                              backgroundColor: incident.severity == "High"
                                                  ? Colors.red.withValues(alpha: 0.15)
                                                  : incident.severity == "Medium"
                                                  ? Colors.orange.withValues(alpha: 0.15)
                                                  : Colors.green.withValues(alpha: 0.15),

                                              child: Icon(
                                                incident.severity == "High"
                                                    ? Icons.dangerous
                                                    : incident.severity == "Medium"
                                                    ? Icons.warning_amber_rounded
                                                    : Icons.verified_user,
                                                color: incident.severity == "High"
                                                    ? Colors.red
                                                    : incident.severity == "Medium"
                                                    ? Colors.orange
                                                    : Colors.green,
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            Expanded(
                                              child: Text(
                                                incident.incidentType,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: incident.severity == "High"
                                                    ? Colors.red.withValues(alpha: 0.15)
                                                    : incident.severity == "Medium"
                                                    ? Colors.orange.withValues(alpha: 0.15)
                                                    : Colors.green.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                incident.severity,
                                                style: TextStyle(
                                                  color: incident.severity == "High"
                                                      ? Colors.red
                                                      : incident.severity == "Medium"
                                                      ? Colors.orange
                                                      : Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 14),

                                        Text(
                                          incident.description,
                                          style: const TextStyle(fontSize: 15),
                                        ),

                                        const SizedBox(height: 10),

                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                color: Colors.blue),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(incident.location),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),

                                        const SizedBox(height: 12),

                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              const Icon(
                                                Icons.smart_toy,
                                                color: Colors.blue,
                                              ),

                                              const SizedBox(width: 10),

                                              Expanded(
                                                child: Text(
                                                  incident.aiRecommendation,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),

                                        if (incident.imageUrl.isNotEmpty) ...[
                                          const SizedBox(height: 12),

                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              incident.imageUrl,
                                              height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
            ),
        ),
    );
  }
  //=====================================================
// MAP PIN
//=====================================================

  Widget buildPin({
    required double top,
    required double left,
    required Color color,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Icon(
        Icons.location_on,
        color: color,
        size: 42,
      ),
    );
  }

//=====================================================
// BUILDING
//=====================================================

  Widget buildBuilding(
      double top,
      double left,
      ) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

//=====================================================
// STATUS ITEM
//=====================================================

  Widget statusItem(
      Color color,
      String text,
      ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 7,
          backgroundColor: color,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}