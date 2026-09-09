import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import 'edit_admin_profile_screen.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import 'change_admin_password_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() =>
      _AdminProfileScreenState();
}

class _AdminProfileScreenState
    extends State<AdminProfileScreen> {

  bool notifications = true;
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? admin;

  bool isLoading = true;
  Future<void> loadAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    admin = await _firestoreService.getUser(user.uid);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    super.initState();
    loadAdmin();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: const Color(0xFFF7F9FC),

        appBar: AppBar(

          backgroundColor: Colors.white,

          foregroundColor: Colors.black,

          elevation: 0,

          title: const Text("Admin Profile"),
        ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(

            padding: const EdgeInsets.all(20),

            child: Column(

                children: [

                const SizedBox(height: 10),

            const CircleAvatar(

              radius: 55,

              backgroundColor: Color(0xFF1565FF),

              child: Icon(

                Icons.admin_panel_settings,

                size: 60,

                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

                  Text(
                    admin?.fullName ?? "Administrator",

              style: TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

                  Text(
                    admin?.email ?? "",

              style: TextStyle(

                color: Colors.grey,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 35),

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(20),

                boxShadow: [

                  BoxShadow(

                    color: Colors.grey.shade200,

                    blurRadius: 8,
                  ),

                ],
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(

                    "Personal Information",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  buildInfoTile(
                    Icons.person,
                    "Full Name",
                    admin?.fullName ?? "",
                  ),

                  buildInfoTile(
                    Icons.email,
                    "Email",
                    admin?.email ?? "",
                  ),

                  buildInfoTile(
                    Icons.phone,
                    "Phone",
                    admin?.phone ?? "",
                  ),

                  buildInfoTile(
                    Icons.security,
                    "Role",
                    "Administrator",
                  ),

                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(20),

                boxShadow: [

                  BoxShadow(

                    color: Colors.grey.shade200,

                    blurRadius: 8,
                  ),

                ],
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                const Text(

                "Account Settings",

                style: TextStyle(

                  fontSize: 22,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),
                  ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),

                    title: const Text("Edit Profile"),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),

                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditAdminProfileScreen(),
                        ),
                      );

                      loadAdmin();
                    },
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.lock,
                      color: Colors.orange,
                    ),

                    title: const Text("Change Password"),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangeAdminPasswordScreen(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  SwitchListTile(

                    secondary: const Icon(
                      Icons.notifications,
                      color: Colors.green,
                    ),

                    title: const Text("Notifications"),

                    value: notifications,

                    onChanged: (value) {

                      setState(() {

                        notifications = value;

                      });

                    },
                  ),

                  const Divider(),

                  ListTile(

                    leading: const Icon(
                      Icons.info,
                      color: Colors.indigo,
                    ),

                    title: const Text("About App"),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),

                    onTap: () {

                      showAboutDialog(

                        context: context,

                        applicationName: "SafeAlert",

                        applicationVersion: "1.0",

                        applicationLegalese:
                        "© 2026 SafeAlert Final Year Project",
                      );

                    },
                  ),

                ],
              ),
            ),

                  const SizedBox(height: 40),

                  SizedBox(

                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton.icon(

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.red,

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                      ),

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

                        onPressed: () async {
                          final navigator = Navigator.of(context);

                          await FirebaseAuth.instance.signOut();

                          if (!mounted) return;

                          navigator.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                                (route) => false,
                          );
                        },
                    ),
                  ),

                  const SizedBox(height: 20),

                ],
            ),
           ),
    );
  }

//======================================
// INFORMATION TILE
//======================================

  Widget buildInfoTile(

      IconData icon,

      String title,

      String value,

      ) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 18),

      child: Row(

        children: [

          CircleAvatar(

            backgroundColor:
            Colors.blue.withValues(alpha: 0.12),

            child: Icon(

              icon,

              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(

                    color: Colors.grey,

                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 3),

                Text(

                  value,

                  style: const TextStyle(

                    fontSize: 17,

                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}