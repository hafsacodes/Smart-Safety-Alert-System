import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';

class SosAlertScreen extends StatefulWidget {
  const SosAlertScreen({super.key});

  @override
  State<SosAlertScreen> createState() => _SosAlertScreenState();
}

class _SosAlertScreenState extends State<SosAlertScreen> {

  final FirestoreService _firestoreService = FirestoreService();
  final LocationService _locationService = LocationService();

  bool emergencyContactSelected = true;
  bool nearbyUsersSelected = true;
  bool policeSelected = true;

  int countdown = 5;

  bool alertSent = false;

  bool isSending = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) async {

        if (countdown > 0) {

          if (!mounted) return;

          setState(() {
            countdown--;
          });

        } else {

          timer.cancel();

          if (isSending) return;

          isSending = true;

          await sendSOS();
        }
      },
    );
  }

  Future<void> sendSOS() async {

    try {

      final currentUser =
          FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        return;
      }

      final UserModel? user =
      await _firestoreService.getUser(
        currentUser.uid,
      );

      if (user == null) {
        return;
      }

      final location =
      await _locationService.getCurrentLocation();
      final address = await _locationService.getAddressFromCoordinates(
        location.latitude,
        location.longitude,
      );

      await _firestoreService.sendSOSAlert(
        userId: currentUser.uid,
        userName: user.fullName,
        latitude: location.latitude,
        longitude: location.longitude,
        location: address,
      );

      if (!mounted) return;

      setState(() {
        alertSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Emergency Alert Sent Successfully",
          ),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

                    IconButton(
                    onPressed: () {
              timer?.cancel();
              Navigator.pop(context);
              },
                icon: const Icon(Icons.arrow_back),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  alertSent
                      ? "Alert Sent"
                      : "Alert Sending",

                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  alertSent
                      ? "Your emergency alert has been sent successfully."
                      : "Emergency alert will be sent in $countdown seconds.",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: Column(
                  children: [

                    Container(
                      height: 190,
                      width: 190,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: alertSent
                            ? Colors.green
                            : Colors.red,

                        boxShadow: [

                          BoxShadow(
                            color: (alertSent
                                ? Colors.green
                                : Colors.red)
                                .withValues(alpha: 0.4),

                            blurRadius: 25,
                            spreadRadius: 8,
                          ),
                        ],
                      ),

                      child: Center(

                        child: alertSent

                            ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 90,
                        )

                            : Text(
                          "$countdown",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    if (!alertSent)

                      GestureDetector(

                        onTap: () {

                          timer?.cancel();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Emergency Alert Cancelled",
                              ),
                            ),
                          );

                          Navigator.pop(context);
                        },

                        child: Container(

                          padding: const EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 15,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: const Text(
                            "Cancel Alert",

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              const Text(
                "Alert Will Be Sent To",

                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              contactTile(
                name: "Emergency Contacts",
                selected: emergencyContactSelected,

                onTap: () {

                  setState(() {
                    emergencyContactSelected =
                    !emergencyContactSelected;
                  });
                },
              ),

              const SizedBox(height: 15),

              contactTile(
                name: "Nearby Users",
                selected: nearbyUsersSelected,

                onTap: () {

                  setState(() {
                    nearbyUsersSelected =
                    !nearbyUsersSelected;
                  });
                },
              ),

              const SizedBox(height: 15),

              contactTile(
                name: "Police / Authorities",
                selected: policeSelected,

                onTap: () {

                  setState(() {
                    policeSelected =
                    !policeSelected;
                  });
                },
              ),

              const SizedBox(height: 40),
                    ],
                ),
              ),
            )
            ),
        );
    }

//=====================================================
// CONTACT TILE
//=====================================================

  Widget contactTile({
    required String name,
    required bool selected,
    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          border: Border.all(
            color: selected
                ? Colors.green
                : Colors.grey.shade300,
            width: 2,
          ),
        ),

        child: Row(

          children: [

            CircleAvatar(

              radius: 24,

              backgroundColor:
              Colors.red.withValues(alpha: 0.15),

              child: const Icon(
                Icons.person,
                color: Colors.red,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(

              child: Text(
                name,

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Icon(

              selected
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,

              color: selected
                  ? Colors.green
                  : Colors.grey,

              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}