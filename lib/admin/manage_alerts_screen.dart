import 'package:flutter/material.dart';

import '../models/incident_model.dart';
import '../services/firestore_service.dart';
import 'report_details_screen.dart';

class ManageAlertsScreen extends StatefulWidget {
  const ManageAlertsScreen({super.key});

  @override
  State<ManageAlertsScreen> createState() =>
      _ManageAlertsScreenState();
}

class _ManageAlertsScreenState
    extends State<ManageAlertsScreen> {

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,

        foregroundColor: Colors.black,

        title: const Text(
          "Manage Alerts",
        ),
      ),



      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(

              "Public Safety Alerts",

              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "AI-generated public safety alerts from approved incident reports.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: StreamBuilder<List<IncidentModel>>(
                stream: _firestoreService.getIncidents(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No approved alerts found.",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  List<IncidentModel> alerts = snapshot.data!
                      .where((incident) => incident.status == "Approved")
                      .toList();

                  if (alerts.isEmpty) {
                    return const Center(
                      child: Text(
                        "No approved alerts found.",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      return buildAlertCard(alerts[index]);
                    },
                  );
                },
              ),
            ),

          ],

        ),

      ),

    );

  }
  Widget buildAlertCard(IncidentModel alert) {

    Color levelColor;

    switch (alert.severity) {
      case "High":
        levelColor = Colors.red;
        break;

      case "Medium":
        levelColor = Colors.orange;
        break;

      default:
        levelColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 26,
                backgroundColor: levelColor.withValues(alpha: 0.15),
                child: Icon(
                  alert.severity == "High"
                      ? Icons.dangerous
                      : alert.severity == "Medium"
                      ? Icons.warning_amber_rounded
                      : Icons.verified_user,
                  color: levelColor,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      alert.incidentType,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      alert.location,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                  levelColor.withValues(alpha: 0.15),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  alert.severity,
                  style: TextStyle(
                    color: levelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 18),

          Text(
            "Status: ${alert.status}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "Posted: ${alert.createdAt}",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
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
                    alert.aiRecommendation,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.visibility),
                  label: const Text("View"),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportDetailsScreen(
                          incident: alert,
                        ),
                      ),
                    );

                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {

                    await _firestoreService.deleteIncident(
                      alert.incidentId,
                    );

                  },
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}