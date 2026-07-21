import 'package:flutter/material.dart';
import 'manage_reports_screen.dart';
import 'manage_alerts_screen.dart';
import 'manage_users_screen.dart';
import 'analytics_screen.dart';
import 'admin_profile_screen.dart';
import '../screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();

  int totalUsers = 0;
  int totalReports = 0;
  int totalAlerts = 0;
  int aiRisks = 0;
  Future<void> loadDashboardData() async {

    final users =
    await _firestore.collection("users").get();

    final reports =
    await _firestore.collection("incidents").get();

    final alerts = await _firestore
        .collection("sos_alerts")
        .where("status", isEqualTo: "Active")
        .get();

    setState(() {

      totalUsers = users.docs.length;

      totalReports = reports.docs.length;

      totalAlerts = alerts.docs.length;

      // Temporary until AI is added
      aiRisks = 0;

    });
  }
  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

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

                const Text(
                  "Admin Dashboard",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Welcome Administrator",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 30),
                //======================
// STATISTICS CARDS
//======================

                Row(
                  children: [

                    Expanded(
                      child: dashboardCard(
                        icon: Icons.people,
                        color: Colors.blue,
                        title: "Users",
                        value: totalUsers.toString(),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: dashboardCard(
                        icon: Icons.notifications_active,
                        color: Colors.red,
                        title: "Alerts",
                        value: totalAlerts.toString(),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [

                    Expanded(
                      child: dashboardCard(
                        icon: Icons.report,
                        color: Colors.orange,
                        title: "Reports",
                        value: totalReports.toString(),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: dashboardCard(
                        icon: Icons.smart_toy,
                        color: Colors.green,
                        title: "AI Risks",
                        value: aiRisks.toString(),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 35),

                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),
                //======================
// QUICK ACTIONS
//======================

                dashboardButton(
                  context,
                  icon: Icons.report,
                  title: "Manage Reports",
                  subtitle: "View and manage user incident reports",
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageReportsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                dashboardButton(
                  context,
                  icon: Icons.notifications_active,
                  title: "Manage Alerts",
                  subtitle: "Create, edit and remove public alerts",
                  color: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageAlertsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                dashboardButton(
                  context,
                  icon: Icons.people,
                  title: "Manage Users",
                  subtitle: "View and manage registered users",
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageUsersScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                dashboardButton(
                  context,
                  icon: Icons.analytics,
                  title: "AI Analytics",
                  subtitle: "View AI predictions and danger analysis",
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnalyticsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                dashboardButton(
                  context,
                  icon: Icons.admin_panel_settings,
                  title: "Admin Profile",
                  subtitle: "Manage administrator account",
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminProfileScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton.icon(

                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.red,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },

                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),

                    label: const Text(

                      "Logout",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }

  //=====================================================
// DASHBOARD STATISTICS CARD
//=====================================================

  Widget dashboardCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [

          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.15),

            child: Icon(
              icon,
              color: color,
              size: 30,
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
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

//=====================================================
// QUICK ACTION BUTTON
//=====================================================

  Widget dashboardButton(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.15),

              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}