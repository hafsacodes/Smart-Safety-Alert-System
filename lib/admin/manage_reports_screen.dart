import 'package:flutter/material.dart';
import '../models/incident_model.dart';
import '../services/firestore_service.dart';
import 'report_details_screen.dart';

class ManageReportsScreen extends StatefulWidget {
  const ManageReportsScreen({super.key});

  @override
  State<ManageReportsScreen> createState() => _ManageReportsScreenState();
}

class _ManageReportsScreenState extends State<ManageReportsScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";
  final FirestoreService _firestoreService = FirestoreService();

  final List<String> filterItems = [
    "All",
    "Pending",
    "Approved",
    "Rejected",
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Manage Reports"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Review and verify reported incidents.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search reports...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedFilter,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              items: filterItems
                  .map(
                    (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
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
                        "No reports found",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  List<IncidentModel> reports = snapshot.data ?? [];
                  // Filter reports
                  if (selectedFilter != "All") {
                    reports = reports.where((report) {
                      return report.status == selectedFilter;
                    }).toList();
                  }
                  if (searchController.text.trim().isNotEmpty) {

                    final query = searchController.text.toLowerCase();

                    reports = reports.where((report) {

                      return report.incidentType.toLowerCase().contains(query) ||
                          report.location.toLowerCase().contains(query) ||
                          report.description.toLowerCase().contains(query);

                    }).toList();

                  }
                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      return reportCard(reports[index]);
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

  Widget reportCard(IncidentModel report) {

    Color statusColor;

    switch (report.status) {
      case "Approved":
        statusColor = Colors.green;
        break;

      case "Rejected":
        statusColor = Colors.red;
        break;

      default:
        statusColor = Colors.orange;
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: statusColor.withValues(alpha: 0.15),
                child: Icon(
                  Icons.report,
                  color: statusColor,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.incidentType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      report.location,
                      style: const TextStyle(color: Colors.grey),
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
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  report.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text("Reported by: ${report.userId}"),
          const SizedBox(height: 5),
          Text(
            report.createdAt.toString(),
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportDetailsScreen(
                          incident: report,
                        ),
                      ),
                    );

                  },
                  child: const Text("View"),
                ),
              ),

              if (report.status == "Pending") ...[
                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      await _firestoreService.updateIncidentStatus(
                        incidentId: report.incidentId,
                        status: "Approved",
                      );
                    },
                    child: const Text(
                      "Approve",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      await _firestoreService.updateIncidentStatus(
                        incidentId: report.incidentId,
                        status: "Rejected",
                      );
                    },
                    child: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}