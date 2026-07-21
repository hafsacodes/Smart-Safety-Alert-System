import 'package:flutter/material.dart';
import 'sos_alert_screen.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF7F9FC),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 10),

                // TITLE
                const Center(

                  child: Text(

                    "Emergency SOS",

                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Center(

                  child: Text(

                    "Press the SOS button in emergency",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                // BIG SOS BUTTON
                Center(

                  child: GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const SosAlertScreen(),
                        ),
                      );
                    },

                    child: Container(

                      height: 230,
                      width: 230,

                      decoration: BoxDecoration(

                        shape: BoxShape.circle,

                        color: Colors.red,

                        boxShadow: [

                          BoxShadow(

                            color: Colors.red.withValues(
                              alpha: 0.35,
                            ),

                            blurRadius: 35,
                            spreadRadius: 10,
                          ),
                        ],
                      ),

                      child: const Center(

                        child: Text(

                          "SOS",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                // SHARE LOCATION
                GestureDetector(

                  onTap: () {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(
                        content: Text(
                          "Live Location Shared",
                        ),
                      ),
                    );
                  },

                  child: Container(

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(24),

                      boxShadow: [

                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Row(

                      children: [

                        CircleAvatar(

                          radius: 28,

                          backgroundColor:
                          Colors.blue.withValues(
                            alpha: 0.15,
                          ),

                          child: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 18),

                        const Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(

                                "Share Live Location",

                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(

                                "Send your real-time location to emergency contacts",

                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // WHAT HAPPENS NEXT
                const Text(

                  "What Happens Next?",

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                infoCard(
                  icon: Icons.notifications_active,
                  color: Colors.red,
                  title: "Emergency Alert",
                  subtitle:
                  "Emergency notification will be sent instantly",
                ),

                const SizedBox(height: 16),

                infoCard(
                  icon: Icons.location_on,
                  color: Colors.blue,
                  title: "Location Shared",
                  subtitle:
                  "Your live location will be shared",
                ),

                const SizedBox(height: 16),

                infoCard(
                  icon: Icons.call,
                  color: Colors.green,
                  title: "Emergency Contacts",
                  subtitle:
                  "Selected contacts will receive alert",
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // INFO CARD
  Widget infoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [

          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
          ),
        ],
      ),

      child: Row(

        children: [

          CircleAvatar(

            radius: 26,

            backgroundColor:
            color.withValues(alpha: 0.15),

            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
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