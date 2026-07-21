import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'main_navigation.dart';
import '../admin/admin_dashboard_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAdmin = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password"),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final userData = await _authService.getCurrentUserData();

      if (userData == null) {
        throw Exception("User data not found.");
      }

      String role = userData["role"] ?? "user";

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful"),
        ),
      );

      if (isAdmin) {
        if (role == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminDashboardScreen(),
            ),
          );
        } else {
          throw Exception("This account is not an admin account.");
        }
      } else {
        if (role == "user") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainNavigation(),
            ),
          );
        } else {
          throw Exception("Please select Admin Login.");
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll("Exception: ", "")),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  Future<void> forgotPassword() async {
    final TextEditingController resetEmailController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Reset Password"),
          content: TextField(
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(dialogContext);

                if (resetEmailController.text.trim().isEmpty) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Please enter your email"),
                    ),
                  );
                  return;
                }

                try {
                  await _authService.resetPassword(
                     resetEmailController.text.trim(),
                  );

                  if (!mounted) return;

                  navigator.pop();

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password reset email sent. Please check your email.",
                      ),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceAll("Exception: ", ""),
                      ),
                    ),
                  );
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                const Icon(
                  Icons.shield,
                  color: Color(0xFF1E88E5),
                  size: 70,
                ),

                const SizedBox(height: 10),

                const Text(
                  "safety alert",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 90),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email address",

                    filled: true,
                    fillColor: const Color(0xFFE0E0E0),

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),

                    prefixIconColor: Colors.white,

                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 60,
                    ),

                    prefixStyle: const TextStyle(
                      backgroundColor: Color(0xFF1E88E5),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: passwordController,
                  obscureText: true,

                  decoration: InputDecoration(
                    hintText: "Password",

                    filled: true,
                    fillColor: const Color(0xFFE0E0E0),

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),

                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 60,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 35),
                const SizedBox(height: 10),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Login As",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text("User"),
                        value: false,
                        groupValue: isAdmin,
                        onChanged: (value) {
                          setState(() {
                            isAdmin = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text("Admin"),
                        value: true,
                        groupValue: isAdmin,
                        onChanged: (value) {
                          setState(() {
                            isAdmin = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isLoading ? null : loginUser,
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Log in  →",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: forgotPassword,
                  child: const Text(
                    "Forgot password ?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E88E5),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        thickness: 1.3,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.3,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "sign up →",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
}