import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';

import '../models/incident_model.dart';
import '../services/cloudinary_service.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../services/ai_service.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() =>
      _ReportIncidentScreenState();
}

class _ReportIncidentScreenState
    extends State<ReportIncidentScreen> {

  final TextEditingController locationController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  final FirestoreService _firestoreService =
  FirestoreService();

  final LocationService _locationService =
  LocationService();

  final ImagePicker _picker = ImagePicker();

  String selectedIncident = "Harassment";

  bool anonymousReport = false;

  bool isSubmitting = false;

  File? selectedIncidentImage;

  String? incidentImageUrl;

  double? latitude;
  double? longitude;

  final List<String> incidentTypes = [
    "Harassment",
    "Robbery",
    "Stalking",
    "Kidnapping",
    "Suspicious Activity",
    "Domestic Violence",
    "Medical Emergency",
    "Other",
  ];

  //====================================================
  // PICK IMAGE FROM GALLERY
  //====================================================

  Future<void> pickFromGallery() async {

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedIncidentImage = File(image.path);
    });

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      const SnackBar(
        content: Text("Uploading image..."),
      ),
    );

    final imageUrl = await CloudinaryService.uploadImage(
      File(image.path),
    );

    if (!mounted) return;

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image upload failed."),
        ),
      );
      return;
    }

    setState(() {
      incidentImageUrl = imageUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Image uploaded successfully."),
      ),
    );
  }

  //====================================================
  // PICK IMAGE FROM CAMERA
  //====================================================

  Future<void> pickFromCamera() async {

    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedIncidentImage = File(image.path);
    });

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      const SnackBar(
        content: Text("Uploading image..."),
      ),
    );

    final imageUrl = await CloudinaryService.uploadImage(
      File(image.path),
    );

    if (!mounted) return;

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image upload failed."),
        ),
      );
      return;
    }

    setState(() {
      incidentImageUrl = imageUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Image uploaded successfully."),
      ),
    );
  }

  //====================================================
  // CURRENT LOCATION
  //====================================================

  Future<void> useCurrentLocation() async {

    final messenger = ScaffoldMessenger.of(context);

    try {

      final position =
      await _locationService.getCurrentLocation();

      latitude = position.latitude;
      longitude = position.longitude;

      final placemarks =
      await placemarkFromCoordinates(
        latitude!,
        longitude!,
      );

      if (!mounted) return;

      if (placemarks.isNotEmpty) {

        final place = placemarks.first;

        locationController.text = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ]
            .where(
              (e) =>
          e != null &&
              e.trim().isNotEmpty,
        )
            .join(", ");

        setState(() {});
      }
    } catch (e) {

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            "Unable to get location.\n$e",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: const Color(0xFFF7F9FC),

        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text("Report Incident"),
        ),

        body: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

            const Text(
            "Report an Incident",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Help keep your community safe by reporting genuine incidents.",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 30),
            //====================================
            // PHOTO SECTION
            //====================================

            const Text(
              "Incident Photo",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),

              child: selectedIncidentImage == null
                  ? Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.image,
                    size: 70,
                    color: Colors.grey.shade500,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "No Image Selected",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
                  : ClipRRect(
                borderRadius:
                BorderRadius.circular(20),
                child: Image.file(
                  selectedIncidentImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF1565FF),
                      foregroundColor: Colors.white,
                      minimumSize:
                      const Size(double.infinity, 50),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickFromGallery,
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize:
                      const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            //====================================
            // LOCATION
            //====================================

            const Text(
              "Incident Location",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: "Enter incident location",
                prefixIcon:
                const Icon(Icons.location_on),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: useCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text(
                  "Use Current Location",
                ),
              ),
            ),

            const SizedBox(height: 30),

            //====================================
            // INCIDENT TYPE
            //====================================

            const Text(
              "Incident Type",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(18),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedIncident,
                  isExpanded: true,
                  items: incidentTypes.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedIncident = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            //====================================
            // DESCRIPTION
            //====================================

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                "Describe what happened...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            //====================================
            // ANONYMOUS REPORT
            //====================================

            SwitchListTile(
              value: anonymousReport,
              title: const Text(
                "Submit as Anonymous",
              ),
              subtitle: const Text(
                "Your identity will not be shared.",
              ),
              secondary: const Icon(
                Icons.visibility_off,
              ),
              onChanged: (value) {
                setState(() {
                  anonymousReport = value;
                });
              },
            ),

            const SizedBox(height: 30),

            //====================================
            // SUBMIT BUTTON
            //====================================

            SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF1565FF),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {

                    if (isSubmitting) return;

                    final messenger =
                    ScaffoldMessenger.of(context);

                    final currentUser =
                        FirebaseAuth.instance.currentUser;

                    if (currentUser == null) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please login first.",
                          ),
                        ),
                      );
                      return;
                    }

                    if (locationController.text.trim().isEmpty ||
                        descriptionController.text.trim().isEmpty) {

                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please fill all required fields.",
                          ),
                        ),
                      );
                      return;
                    }

                    if (incidentImageUrl == null) {

                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please upload an incident image.",
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      isSubmitting = true;
                    });

                    try {

                      final user =
                      await _firestoreService.getUser(
                        currentUser.uid,
                      );

                      if (!mounted) return;

                      if (user == null) {

                        setState(() {
                          isSubmitting = false;
                        });

                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Unable to load your profile.",
                            ),
                          ),
                        );

                        return;
                      }

                      final incidentDoc =
                      FirebaseFirestore.instance
                          .collection("incidents")
                          .doc();

                      final severity = AIService.analyzeIncident(
                        descriptionController.text.trim(),
                      );

                      final aiRecommendation =
                      AIService.getSafetyRecommendation(
                        severity,
                      );

                      final incident = IncidentModel(
                        incidentId: incidentDoc.id,
                        userId: currentUser.uid,
                        userName: user.fullName,
                        incidentType: selectedIncident,
                        description: descriptionController.text.trim(),

                        severity: severity,
                        aiRecommendation: aiRecommendation,

                        location: locationController.text.trim(),
                        latitude: latitude ?? 0.0,
                        longitude: longitude ?? 0.0,
                        imageUrl: incidentImageUrl!,
                        anonymousReport: anonymousReport,
                        status: "Pending",
                        createdAt: DateTime.now(),
                      );

                      await _firestoreService
                          .submitIncident(
                        incident: incident,
                      );

                      if (!mounted) return;

                      locationController.clear();
                      descriptionController.clear();

                      setState(() {

                        selectedIncident =
                        "Harassment";

                        anonymousReport = false;

                        selectedIncidentImage = null;

                        incidentImageUrl = null;

                        latitude = null;

                        longitude = null;

                        isSubmitting = false;
                      });

                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Incident submitted successfully.",
                          ),
                        ),
                      );

                    } catch (e) {

                      if (!mounted) return;

                      setState(() {
                        isSubmitting = false;
                      });

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to submit report.\n$e",
                          ),
                        ),
                      );
                    }
                  },

                  child: isSubmitting
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Submit Report",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ),

            const SizedBox(height: 25),

            //====================================
            // SAFETY NOTICE
            //====================================

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orange,
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Please submit only genuine incidents. False reports may lead to legal action.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

              const SizedBox(height: 20),

            ],
          ),
        ),
    );
  }
}