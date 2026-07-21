import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';
import 'sos_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int currentIndex = 0;

  final List<Widget> screens = [

    // HOME
    const HomeScreen(),

    // MAP
    const MapScreen(),

    // SOS
  const SosScreen(),


    // ALERTS
    const AlertsScreen(),

    // PROFILE
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: screens[currentIndex],

      // SOS BUTTON
      floatingActionButton: SizedBox(

        height: 75,
        width: 75,

        child: FloatingActionButton(

          backgroundColor: Colors.red,

          elevation: 8,

          shape: const CircleBorder(),

          onPressed: () {

            setState(() {
              currentIndex = 2;
            });
          },

          child: const Text(
            "SOS",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomAppBar(

        shape: const CircularNotchedRectangle(),

        notchMargin: 10,

        elevation: 12,

        color: Colors.white,

        child: SizedBox(

          height: 75,

          child: Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceAround,

            children: [

              // HOME
              navItem(
                Icons.home_rounded,
                "Home",
                0,
              ),

              // MAP
              navItem(
                Icons.map_rounded,
                "Map",
                1,
              ),

              const SizedBox(width: 40),

              // ALERTS
              navItem(
                Icons.notifications_active_rounded,
                "Alerts",
                3,
              ),

              // PROFILE
              navItem(
                Icons.person_rounded,
                "Profile",
                4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NAVIGATION ITEM
  Widget navItem(
      IconData icon,
      String label,
      int index,
      ) {

    final bool isSelected = currentIndex == index;

    return GestureDetector(

      onTap: () {

        setState(() {
          currentIndex = index;
        });
      },

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,

            size: 28,

            color: isSelected
                ? const Color(0xFF1565FF)
                : Colors.grey,
          ),

          const SizedBox(height: 4),

          Text(
            label,

            style: TextStyle(

              fontSize: 13,

              fontWeight: FontWeight.w600,

              color: isSelected
                  ? const Color(0xFF1565FF)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}