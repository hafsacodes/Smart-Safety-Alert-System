import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeAdminPasswordScreen extends StatefulWidget {
  const ChangeAdminPasswordScreen({super.key});

  @override
  State<ChangeAdminPasswordScreen> createState() =>
      _ChangeAdminPasswordScreenState();
}

class _ChangeAdminPasswordScreenState
    extends State<ChangeAdminPasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
  TextEditingController();

  final TextEditingController newPasswordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text.trim(),
      );

      // Re-authenticate the user
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(
        newPasswordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Failed to update password.";

      if (e.code == "wrong-password" ||
          e.code == "invalid-credential") {
        message = "Current password is incorrect.";
      } else if (e.code == "weak-password") {
        message = "New password is too weak.";
      } else if (e.code == "requires-recent-login") {
        message = "Please log in again and try.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Change Password"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              const SizedBox(height: 20),

              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF1565FF),
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 45,
                ),
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: currentPasswordController,
                obscureText: hideCurrentPassword,

                decoration: InputDecoration(
                  labelText: "Current Password",
                  prefixIcon: const Icon(Icons.lock_outline),

                  suffixIcon: IconButton(
                    icon: Icon(
                      hideCurrentPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hideCurrentPassword =
                        !hideCurrentPassword;
                      });
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter current password";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: newPasswordController,
                obscureText: hideNewPassword,

                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Icons.lock),

                  suffixIcon: IconButton(
                    icon: Icon(
                      hideNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hideNewPassword =
                        !hideNewPassword;
                      });
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: confirmPasswordController,
                obscureText: hideConfirmPassword,

                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock_reset),

                  suffixIcon: IconButton(
                    icon: Icon(
                      hideConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hideConfirmPassword =
                        !hideConfirmPassword;
                      });
                    },
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value != newPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
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

                  onPressed: changePassword,

                  child: const Text(
                    "Update Password",
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
      ),
    );
  }
}