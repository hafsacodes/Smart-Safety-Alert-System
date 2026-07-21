import 'package:flutter/material.dart';
import 'guardian_ai_screen.dart';
import 'report_incident_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                //======================
                // LOGO
                //======================

                Row(
                  children: [

                    const Icon(
                      Icons.shield,
                      color: Color(0xFF1565FF),
                      size: 40,
                    ),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: const [

                        Text(
                          "SafeAlert",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565FF),
                          ),
                        ),

                        Text(
                          "Stay Safe, Stay Connected",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 40),

                //======================
                // HELLO
                //======================

                RichText(
                  text: const TextSpan(
                    children: [

                      TextSpan(
                        text: "Hello, ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      TextSpan(
                        text: "Ayesha",
                        style: TextStyle(
                          color: Color(0xFF1565FF),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "You are protected. Stay alert!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 35),

                //======================
                // EMERGENCY CARD
                //======================

                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 110,
                        height: 110,

                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                          size: 60,
                        ),
                      ),

                      const SizedBox(width: 20),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text(
                              "Emergency Help",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Need help instantly?\nPress the SOS button below\nor use quick actions.",
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                //======================
                // QUICK ACTIONS TITLE
                //======================

                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),
//======================
// GUARDIAN AI CARD
//======================

                GestureDetector(

                  onTap: () {
                    Navigator.push(

                      context,

                      MaterialPageRoute(
                        builder: (context) => const GuardianAiScreen(),
                      ),
                    );
                  },

                  child: Container(

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(24),

                      gradient: const LinearGradient(

                        colors: [

                          Color(0xFF1565FF),
                          Color(0xFF3F8CFF),

                        ],
                      ),

                      boxShadow: [

                        BoxShadow(

                          color: Colors.blue.withValues(alpha: 0.25),

                          blurRadius: 12,

                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Row(

                      children: [

                        Container(

                          height: 75,
                          width: 75,

                          decoration: BoxDecoration(

                            color: Colors.white.withValues(alpha: 0.20),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(

                            Icons.smart_toy,

                            color: Colors.white,

                            size: 42,
                          ),
                        ),

                        const SizedBox(width: 20),

                        const Expanded(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(

                                "Guardian AI",

                                style: TextStyle(

                                  color: Colors.white,

                                  fontSize: 24,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(

                                "Ask AI about nearby danger, safest routes, emergency guidance and personal safety.",

                                style: TextStyle(

                                  color: Colors.white,

                                  fontSize: 15,

                                  height: 1.4,
                                ),
                              ),

                            ],
                          ),
                        ),

                        const Icon(

                          Icons.arrow_forward_ios,

                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
//======================
// REPORT INCIDENT CARD
//======================

                const SizedBox(height: 25),

                GestureDetector(

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (context) =>
                        const ReportIncidentScreen(),

                      ),
                    );

                  },

                  child: Container(

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(24),

                      gradient: const LinearGradient(

                        colors: [

                          Color(0xFFE53935),

                          Color(0xFFFF6B6B),

                        ],
                      ),

                      boxShadow: [

                        BoxShadow(

                          color: Colors.red.withValues(alpha: 0.25),

                          blurRadius: 12,

                          offset: const Offset(0, 5),

                        ),

                      ],

                    ),

                    child: Row(

                      children: [

                        Container(

                          height: 75,

                          width: 75,

                          decoration: BoxDecoration(

                            color: Colors.white.withValues(alpha: 0.20),

                            shape: BoxShape.circle,

                          ),

                          child: const Icon(

                            Icons.report,

                            color: Colors.white,

                            size: 42,

                          ),

                        ),

                        const SizedBox(width: 20),

                        const Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(

                                "Report Incident",

                                style: TextStyle(

                                  color: Colors.white,

                                  fontSize: 24,

                                  fontWeight: FontWeight.bold,

                                ),

                              ),

                              SizedBox(height: 8),

                              Text(

                                "Report harassment, robbery, suspicious activity or any emergency to help keep everyone safe.",

                                style: TextStyle(

                                  color: Colors.white,

                                  fontSize: 15,

                                  height: 1.4,

                                ),

                              ),

                            ],

                          ),

                        ),

                        Icon(

                          Icons.arrow_forward_ios,

                          color: Colors.white,

                        ),

                      ],

                    ),

                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildAction(IconData icon,
      String title,
      Color color,
      VoidCallback onTap,) {
    return GestureDetector(

      onTap: onTap,

      child: Container(

        width: 80,
        height: 95,

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              color: color,
              size: 34,
            ),

            const SizedBox(height: 10),

            Text(

              title,

              textAlign: TextAlign.center,

              style: const TextStyle(

                fontSize: 12,

                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}