import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/incident_model.dart';
import '../models/sos_alert_model.dart';

class AlertDetailsScreen extends StatelessWidget {
  final IncidentModel? incident;
  final SosAlertModel? sosAlert;

  const AlertDetailsScreen({
    super.key,
    this.incident,
    this.sosAlert,
  });

  bool get isIncident => incident != null;

  Future<void> openGoogleMaps() async {
    final double latitude =
    isIncident ? incident!.latitude : sosAlert!.latitude;

    final double longitude =
    isIncident ? incident!.longitude : sosAlert!.longitude;

    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Color getThreatColor(String level) {
    switch (level.toLowerCase()) {
      case "high":
        return Colors.red;

      case "medium":
        return Colors.orange;

      case "low":
        return Colors.green;

      default:
        return Colors.blue;
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
              // IMAGE (INCIDENT ONLY)
              //==============================

              if (isIncident)
          ClipRRect(
          borderRadius: BorderRadius.circular(20),
      child: Image.network(
        incident!.imageUrl,
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
    )
    else
    Container(
    height: 220,
    width: double.infinity,
    decoration: BoxDecoration(
    color: Colors.red.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(20),
    ),
    child: const Center(
    child: Icon(
    Icons.sos,
    color: Colors.red,
    size: 120,
    ),
    ),
    ),

    const SizedBox(height: 25),

    Text(
    isIncident
    ? incident!.incidentType
        : "SOS Emergency Alert",
    style: const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 12),

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
    isIncident
    ? incident!.status
        : sosAlert!.status,
    style: const TextStyle(
    color: Colors.orange,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),

    const SizedBox(height: 25),

    const Text(
    "Location",
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 8),

    Text(
    isIncident
    ? incident!.location
        : sosAlert!.location,
    style: const TextStyle(
    fontSize: 16,
    ),
    ),

    const SizedBox(height: 25),

    const Text(
    "Threat Level",
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 10),

    Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
    ),
    decoration: BoxDecoration(
    color: getThreatColor(
    isIncident
    ? incident!.severity
        : sosAlert!.severity,
    ).withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
    isIncident
    ? incident!.severity
        : sosAlert!.severity,
    style: TextStyle(
    color: getThreatColor(
    isIncident
    ? incident!.severity
        : sosAlert!.severity,
    ),
    fontWeight: FontWeight.bold,
    ),
    ),
    ),

    const SizedBox(height: 25),

    const Text(
    "AI Recommendation",
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 10),

    Text(
    isIncident
    ? incident!.aiRecommendation
        : sosAlert!.aiRecommendation,
    style: const TextStyle(
    fontSize: 16,
    height: 1.5,
    ),
    ),

    const SizedBox(height: 25),
                if (isIncident) ...[
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    incident!.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Report Type",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    incident!.anonymousReport
                        ? "Anonymous"
                        : "Public Report",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),
                ],

                const Text(
                  "Reported By",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  isIncident
                      ? incident!.userName
                      : sosAlert!.userName,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                if (isIncident) ...[
                  const Text(
                    "Reported On",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    incident!.createdAt?.toString() ?? "Unknown",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 35),
                ] else ...[
                  const SizedBox(height: 35),
                ],

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