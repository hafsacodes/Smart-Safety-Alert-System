import 'package:flutter/material.dart';

import '../models/sos_alert_model.dart';
import '../services/firestore_service.dart';

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

        foregroundColor: Colors.black,

        elevation: 0,

        title: const Text("Manage SOS Alerts"),

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(

              "Manage Active SOS Alerts",

              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),

            ),

            const SizedBox(height: 8),

            const Text(

              "Monitor and manage emergency SOS alerts submitted by users.",

              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),

            ),

            const SizedBox(height: 25),

            Expanded(

              child: StreamBuilder<List<SosAlertModel>>(

                stream: _firestoreService.getSOSAlerts(),

                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {

                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty) {

                    return const Center(

                      child: Text(
                        "No SOS alerts found.",
                        style: TextStyle(fontSize: 18),
                      ),

                    );

                  }

                  final alerts = snapshot.data!;

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

  Widget buildAlertCard(SosAlertModel alert) {

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

        backgroundColor:
        levelColor.withValues(alpha: 0.15),

        child: Icon(

          alert.severity == "High"
              ? Icons.warning
              : alert.severity == "Medium"
              ? Icons.report_problem
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

              alert.userName,

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

    const SizedBox(height: 6),

    Text(

    "Latitude: ${alert.latitude}",

    style: const TextStyle(
    color: Colors.grey,
    ),

    ),

    const SizedBox(height: 4),

    Text(

    "Longitude: ${alert.longitude}",

    style: const TextStyle(
    color: Colors.grey,
    ),

    ),

    const SizedBox(height: 18),
          Row(
            children: [

              Expanded(
                child: OutlinedButton.icon(

                  icon: const Icon(Icons.visibility),

                  label: const Text("View"),

                  onPressed: () {

                    showDialog(

                      context: context,

                      builder: (context) {

                        return AlertDialog(

                          title: const Text("SOS Alert Details"),

                          content: SingleChildScrollView(

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              mainAxisSize: MainAxisSize.min,

                              children: [

                                detailRow(
                                  "User",
                                  alert.userName,
                                ),

                                detailRow(
                                  "Location",
                                  alert.location,
                                ),

                                detailRow(
                                  "Severity",
                                  alert.severity,
                                ),

                                detailRow(
                                  "Status",
                                  alert.status,
                                ),

                                detailRow(
                                  "Latitude",
                                  alert.latitude.toString(),
                                ),

                                detailRow(
                                  "Longitude",
                                  alert.longitude.toString(),
                                ),

                                detailRow(
                                  "Google Maps",
                                  alert.mapUrl,
                                ),

                              ],

                            ),

                          ),

                          actions: [

                            TextButton(

                              onPressed: () {

                                Navigator.pop(context);

                              },

                              child: const Text("Close"),

                            ),

                          ],

                        );

                      },

                    );

                  },

                ),

              ),

              if (alert.status == "Active") ...[

                const SizedBox(width: 10),

                Expanded(

                  child: ElevatedButton.icon(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),

                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),

                    label: const Text(
                      "Resolve",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    onPressed: () async {

                      await _firestoreService.updateSOSStatus(

                        alertId: alert.alertId,

                        status: "Resolved",

                      );

                    },

                  ),

                ),

              ],

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

                    await _firestoreService.deleteSOSAlert(
                      alert.alertId,
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

  Widget detailRow(
      String title,
      String value,
      ) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 12),

      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(

            width: 90,

            child: Text(

              "$title:",

              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),

            ),

          ),

          Expanded(

            child: Text(value),

          ),

        ],

      ),

    );

  }

}