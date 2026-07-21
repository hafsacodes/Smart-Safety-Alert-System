import 'package:flutter/material.dart';
import '../models/incident_model.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'alert_details_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {

  String selectedTab = "All Alerts";
  final FirestoreService _firestoreService = FirestoreService();
  double? userLatitude;
  double? userLongitude;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  final List<Map<String, dynamic>> mockAlerts = [
    {
      "title": "Harassment Reported",
      "location": "Main Street, Block A",
      "status": "Pending",
      "color": Colors.red,
      "icon": Icons.warning_rounded,
    },
    {
      "title": "Robbery Reported",
      "location": "City Mall Road",
      "status": "Pending",
      "color": Colors.orange,
      "icon": Icons.report,
    },
    {
      "title": "Suspicious Activity",
      "location": "Sector F Park",
      "status": "Pending",
      "color": Colors.blue,
      "icon": Icons.visibility,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF7F9FC),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // HEADER
                const Text(
                  "Alerts",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Stay updated with nearby incidents",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 28),

                // TOP FILTERS
                SingleChildScrollView(

                  scrollDirection: Axis.horizontal,

                  child: Row(

                    children: [

                      topButton("All Alerts"),

                      const SizedBox(width: 12),

                      topButton("Nearby Alerts"),

                      const SizedBox(width: 12),

                      topButton("My Alerts"),
                    ],
                  ),
                ),


            const SizedBox(height: 30),

            StreamBuilder<List<IncidentModel>>(
              stream: _firestoreService.getIncidents(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final allIncidents = snapshot.data ?? [];

                final currentUser = FirebaseAuth.instance.currentUser;

                List<IncidentModel> incidents = [];

                if (selectedTab == "All Alerts") {
                  incidents = allIncidents;
                } else if (selectedTab == "My Alerts") {
                  incidents = allIncidents.where((incident) {
                    return incident.userId == currentUser?.uid;
                  }).toList();
                }else if (selectedTab == "Nearby Alerts") {
                  if (userLatitude != null && userLongitude != null) {
                    incidents = allIncidents.where((incident) {

                      double distance = Geolocator.distanceBetween(
                        userLatitude!,
                        userLongitude!,
                        incident.latitude,
                        incident.longitude,
                      );

                      return distance <= 5000; // 5 km

                    }).toList();
                  }
                }
                if (incidents.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "No Alerts Found",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "There are no alerts for this category.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (incidents.isEmpty) {
                  return Column(
                    children: mockAlerts.map((alert) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: alertCard(
                          color: alert["color"],
                          title: alert["title"],
                          subtitle: alert["location"],
                          level: alert["status"],
                          icon: alert["icon"],
                        ),
                      );
                    }).toList(),
                  );
                }

                return Column(
                  children: incidents.map((incident) {

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AlertDetailsScreen(
                                incident: incident,
                              ),
                            ),
                          );
                        },

                        child: alertCard(
                          color: getAlertColor(incident.incidentType),
                          title: incident.incidentType,
                          subtitle: incident.location,
                          level: incident.status,
                          icon: getAlertIcon(incident.incidentType),
                        ),
                      ),
                    );

                  }).toList(),
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

  // FILTER BUTTON
  Widget topButton(String text) {
    bool isSelected = selectedTab == text;

    return GestureDetector(

      onTap: () {
        setState(() {
          selectedTab = text;
        });
      },

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 14,
        ),

        decoration: BoxDecoration(

          color: isSelected
              ? const Color(0xFF1565FF)
              : Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected
                ? const Color(0xFF1565FF)
                : Colors.grey.shade300,
          ),
        ),

        child: Text(
          text,

          style: TextStyle(
            color:
            isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  Widget alertCard({
    required Color color,
    required String title,
    required String subtitle,
    required String level,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Color getAlertColor(String incidentType) {
    switch (incidentType) {
      case "Harassment":
        return Colors.red;

      case "Robbery":
        return Colors.red;

      case "Kidnapping":
        return Colors.red;

      case "Stalking":
        return Colors.orange;

      case "Suspicious Activity":
        return Colors.orange;

      case "Domestic Violence":
        return Colors.deepOrange;

      case "Medical Emergency":
        return Colors.blue;

      default:
        return Colors.green;
    }
  }

  IconData getAlertIcon(String incidentType) {
    switch (incidentType) {
      case "Harassment":
        return Icons.warning_rounded;

      case "Robbery":
        return Icons.gpp_bad;

      case "Kidnapping":
        return Icons.dangerous;

      case "Stalking":
        return Icons.visibility;

      case "Suspicious Activity":
        return Icons.remove_red_eye;

      case "Domestic Violence":
        return Icons.family_restroom;

      case "Medical Emergency":
        return Icons.local_hospital;

      default:
        return Icons.info;
    }
  }

}