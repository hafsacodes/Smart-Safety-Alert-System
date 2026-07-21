import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'emergency_contacts_screen.dart';
import 'login_screen.dart';
import '../services/cloudinary_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  UserModel? user;

  bool isLoading = true;
  bool shareLocation = true;

  File? selectedProfileImage;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return;
    }

    final data = await _firestoreService.getUser(currentUser.uid);

    if (!mounted) return;

    setState(() {
      user = data;
      isLoading = false;
    });
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    final File imageFile = File(image.path);

    setState(() {
      selectedProfileImage = imageFile;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Uploading image..."),
      ),
    );

    final imageUrl =
    await CloudinaryService.uploadImage(imageFile);
    print("Cloudinary URL: $imageUrl");

    if (imageUrl == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image upload failed."),
        ),
      );

      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    await _firestoreService.updateProfileImage(
      uid: currentUser.uid,
      imageUrl: imageUrl,
    );

    await loadUser();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile picture updated successfully."),
      ),
    );
  }

  Future<void> editProfile() async {
    final nameController = TextEditingController(
      text: user?.fullName ?? "",
    );

    final phoneController = TextEditingController(
      text: user?.phone ?? "",
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565FF),
              ),
              onPressed: () async {
                await _firestoreService.updateUserProfile(
                  uid: user!.uid,
                  fullName: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                );

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext);

                await loadUser();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile Updated Successfully"),
                  ),
                );
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    await _authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                    "Profile",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Column(
                          children: [

                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1565FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: selectedProfileImage != null
                                    ? Image.file(
                                  selectedProfileImage!,
                                  fit: BoxFit.cover,
                                )
                                    : (user != null &&
                                    user!.profileImage.isNotEmpty)
                                    ? Image.network(
                                  user!.profileImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 45,
                                    );
                                  },
                                )
                                    : const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            GestureDetector(
                              onTap: pickProfileImage,
                              child: const Text(
                                "Change",
                                style: TextStyle(
                                  color: Color(0xFF1565FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                user?.fullName ?? "",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                user?.email ?? "",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                user?.phone ?? "",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                "Private Information",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 14),

                              GestureDetector(
                                onTap: editProfile,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1565FF),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  settingsTile(
                    icon: Icons.contact_phone,
                    color: Colors.red,
                    title: "Emergency Contacts",
                    subtitle: "Manage trusted contacts",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmergencyContactsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                          Colors.green.withValues(alpha: 0.15),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 16),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Share Live Location",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Allow trusted contacts to track you",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Switch(
                          value: shareLocation,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              shareLocation = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  GestureDetector(
                    onTap: logout,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),

                          SizedBox(width: 10),

                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                    ],
                  ),
                ),
            ),
        ),
    );
  }

  Widget settingsTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
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
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}