import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';

class EditAdminProfileScreen extends StatefulWidget {
  const EditAdminProfileScreen({super.key});

  @override
  State<EditAdminProfileScreen> createState() =>
      _EditAdminProfileScreenState();
}

class _EditAdminProfileScreenState
    extends State<EditAdminProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _phoneController =
  TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    UserModel? admin =
    await _firestoreService.getUser(user.uid);

    if (admin != null) {
      _nameController.text = admin.fullName;
      _emailController.text = admin.email;
      _phoneController.text = admin.phone;
    }

    setState(() {
      isLoading = false;
    });
  }
  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _firestoreService.updateUserProfile(
      uid: user.uid,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully."),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
        title: const Text("Edit Profile"),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF1565FF),
              child: Icon(
                Icons.admin_panel_settings,
                size: 55,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF1565FF),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),
                onPressed: saveProfile,
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}