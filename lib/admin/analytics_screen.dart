import 'package:flutter/material.dart';

import '../models/analytics_model.dart';
import '../models/user_model.dart';
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

        title: const Text("Analytics"),
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

          return FutureBuilder<List<UserModel>>(

            future: _firestoreService
                .getUsers()
                .first,

            builder: (context, userSnapshot) {
              final int totalUsers =
                  userSnapshot.data?.length ?? 0;

              return SingleChildScrollView(

                padding: const EdgeInsets.all(20),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "System Analytics",

                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(

                      "Overview of reports, alerts and AI predictions.",

                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(

                      children: [

                        Expanded(

                          child: analyticsCard(

                            title: "Users",

                            value: totalUsers.toString(),

                            color: Colors.blue,

                            icon: Icons.people,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(

                          child: analyticsCard(

                            title: "Reports",

                            value: analytics.totalReports.toString(),

                            color: Colors.orange,

                            icon: Icons.report,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(

                      children: [

                        Expanded(

                          child: analyticsCard(

                            title: "Alerts",

                            value: analytics.approvedReports.toString(),

                            color: Colors.red,

                            icon: Icons.notifications_active,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(

                          child: analyticsCard(

                            title: "AI Risks",

                            value: analytics.highRiskReports.toString(),

                            color: Colors.green,

                            icon: Icons.smart_toy,
                          ),
                        ),

                      ],
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

                    const SizedBox(height: 15),

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

                    const SizedBox(height: 35),

                    Container(

                      width: double.infinity,

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(

                        gradient: const LinearGradient(

                          colors: [

                            Color(0xFF1565FF),

                            Color(0xFF4F9BFF),

                          ],
                        ),

                        borderRadius:
                        BorderRadius.circular(22),
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Row(

                            children: [

                              Icon(
                                Icons.smart_toy,
                                color: Colors.white,
                                size: 30,
                              ),

                              SizedBox(width: 10),

                              Text(

                                "Guardian AI Summary",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                            ],
                          ),

                          const SizedBox(height: 18),

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

                      "Weekly Activity",

                      style: TextStyle(

                        fontSize: 24,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    for (final activity
                    in analytics.weeklyActivity)

                      activityTile(
                        activity.day,
                        activity.count,
                      ),

                    const SizedBox(height: 30),

                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  //==========================================
// ANALYTICS CARD
//==========================================

  Widget analyticsCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
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
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

//==========================================
// CATEGORY PROGRESS
//==========================================

  Widget buildProgressTile(String title,
      double value,
      Color color,) {
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
        ],
      ),
    );
  }

//==========================================
// RISK AREA TILE
//==========================================

  Widget riskAreaTile(String area,
      String level,
      Color color,) {
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

//==========================================
// WEEKLY ACTIVITY
//==========================================

  Widget activityTile(String day,
      int reports,) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF1565FF),
        child: Icon(
          Icons.bar_chart,
          color: Colors.white,
        ),
      ),
      title: Text(day),
      trailing: Text(
        "$reports Reports",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}