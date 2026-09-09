import 'package:flutter/material.dart';

import '../models/analytics_model.dart';
import '../services/firestore_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),

        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text("AI Safety Intelligence"),
        ),

        body: StreamBuilder<AnalyticsModel>(
            stream: _firestoreService.getAnalytics(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text("No analytics available"),
                );
              }

              final analytics = snapshot.data!;

              String mostCommonIncident = "Harassment";
              double highest = analytics.harassmentPercentage;

              if (analytics.robberyPercentage > highest) {
                highest = analytics.robberyPercentage;
                mostCommonIncident = "Robbery";
              }

              if (analytics.suspiciousPercentage > highest) {
                highest = analytics.suspiciousPercentage;
                mostCommonIncident = "Suspicious Activity";
              }

              if (analytics.stalkingPercentage > highest) {
                highest = analytics.stalkingPercentage;
                mostCommonIncident = "Stalking";
              }

              String overallRisk = "Low";

              if (analytics.highRiskReports >= 5) {
                overallRisk = "High";
              } else if (analytics.highRiskReports >= 2) {
                overallRisk = "Medium";
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  const Text(
                  "AI Safety Intelligence",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Guardian AI analyzes incident reports to identify dangerous areas and community safety trends.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1565FF),
                        Color(0xFF4F9BFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Row(
                        children: [

                          Icon(
                            Icons.smart_toy,
                            color: Colors.white,
                            size: 32,
                          ),

                          SizedBox(width: 12),

                          Text(
                            "Guardian AI Assessment",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Overall Risk Level: $overallRisk",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        analytics.aiSummary,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 35),
                    const Text(
                      "Risk Distribution",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    riskCard(
                      "High Risk Reports",
                      analytics.highRiskReports.toString(),
                      Colors.red,
                      Icons.warning,
                    ),

                    const SizedBox(height: 15),

                    riskCard(
                      "Medium Risk Reports",
                      analytics.mediumRiskReports.toString(),
                      Colors.orange,
                      Icons.report_problem,
                    ),

                    const SizedBox(height: 15),

                    riskCard(
                      "Low Risk Reports",
                      analytics.lowRiskReports.toString(),
                      Colors.green,
                      Icons.verified_user,
                    ),

                    const SizedBox(height: 35),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Most Common Incident",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [

                              const CircleAvatar(
                                radius: 28,
                                backgroundColor: Color(0x221565FF),
                                child: Icon(
                                  Icons.local_police,
                                  color: Color(0xFF1565FF),
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      mostCommonIncident,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      "${(highest * 100).toStringAsFixed(1)}% of all reports",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      "Reports by Category",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    buildProgressTile(
                      "Harassment",
                      analytics.harassmentPercentage,
                      Colors.red,
                    ),

                    buildProgressTile(
                      "Robbery",
                      analytics.robberyPercentage,
                      Colors.orange,
                    ),

                    buildProgressTile(
                      "Suspicious Activity",
                      analytics.suspiciousPercentage,
                      Colors.blue,
                    ),

                    buildProgressTile(
                      "Stalking",
                      analytics.stalkingPercentage,
                      Colors.green,
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      "High Risk Areas",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    for (final area in analytics.highRiskAreas)
                      riskAreaTile(
                        area.location,
                        area.level,
                        area.level == "High"
                            ? Colors.red
                            : area.level == "Medium"
                            ? Colors.orange
                            : Colors.green,
                      ),

                    const SizedBox(height: 30),

                  ],
                ),
              );
            },
        ),
    );
  }
  //=====================================================
// RISK CARD
//=====================================================

  Widget riskCard(
      String title,
      String value,
      Color color,
      IconData icon,
      ) {
    return Container(
      width: double.infinity,
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

//=====================================================
// CATEGORY PROGRESS
//=====================================================

  Widget buildProgressTile(
      String title,
      double value,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: value,
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
            color: color,
            backgroundColor: Colors.grey.shade300,
          ),

          const SizedBox(height: 5),

          Text(
            "${(value * 100).toStringAsFixed(1)}%",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

        ],
      ),
    );
  }

//=====================================================
// RISK AREA TILE
//=====================================================

  Widget riskAreaTile(
      String area,
      String level,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [

          Icon(
            Icons.location_on,
            color: color,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              area,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
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
}