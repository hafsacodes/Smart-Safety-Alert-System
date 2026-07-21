import 'package:flutter/material.dart';
import '../models/incident_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertDetailsScreen extends StatelessWidget {
  final IncidentModel incident;

  const AlertDetailsScreen({
    super.key,
    required this.incident,
  });
  Future<void> openGoogleMaps() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${incident.latitude},${incident.longitude}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        title: const Text("Alert Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            //==============================
            // INCIDENT IMAGE
            //==============================

            ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Image.network(
                incident.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,

                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 80,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            //==============================
            // INCIDENT TYPE
            //==============================

            Text(
              incident.incidentType,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            //==============================
            // STATUS
            //==============================

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                incident.status,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            //==============================
            // LOCATION
            //==============================

            const Text(
              "Location",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              incident.location,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 25),

            //==============================
            // DESCRIPTION
            //==============================

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              incident.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            //==============================
            // REPORT TYPE
            //==============================

            const Text(
              "Report Type",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              incident.anonymousReport
                  ? "Anonymous"
                  : "Public Report",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 25),

            //==============================
            // DATE
            //==============================

            const Text(
              "Reported On",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              incident.createdAt.toString(),
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 35),

            //==============================
            // GOOGLE MAP BUTTON
            //==============================

            SizedBox(
              width: double.infinity,
              height: 55,

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
    );
  }
}