import 'package:flutter/material.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() =>
      _AdminProfileScreenState();
}

class _AdminProfileScreenState
    extends State<AdminProfileScreen> {

  bool notifications = true;

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

        body: SingleChildScrollView(

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

            const Text(

              "Administrator",

              style: TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(

              "admin@safealert.com",

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
                    "System Administrator",
                  ),

                  buildInfoTile(
                    Icons.email,
                    "Email",
                    "admin@safealert.com",
                  ),

                  buildInfoTile(
                    Icons.phone,
                    "Phone",
                    "+92 300 0000000",
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

                    onTap: () {

                      ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(
                          content: Text("Edit Profile clicked"),
                        ),
                      );
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

                      ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(
                          content: Text("Change Password clicked"),
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

                      onPressed: () {

                        Navigator.pop(context);

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