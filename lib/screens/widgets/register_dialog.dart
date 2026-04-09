// register_dialog.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/screens/booking_screen.dart';
import '../../auth/auth_service.dart';
import '../widgets/app_bar.dart';
import 'login_dialog.dart';

class RegisterDialog extends StatefulWidget {
  final VoidCallback? onRegistrationSuccess;

  const RegisterDialog({super.key, this.onRegistrationSuccess});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final userNameController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password and Confirm password must be same"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await AuthService.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      phone: phoneController.text.trim(),
      fullName: fullNameController.text.trim(),
      address: addressController.text.trim(),
      userName: userNameController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );

      // Close dialog and notify success
      Navigator.pop(context);
      if (widget.onRegistrationSuccess != null) {
        widget.onRegistrationSuccess!();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.train_rounded,
                      color: kPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Create Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Join Quick Ticket today",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Form body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(17),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fullNameController,
                        decoration: _inputDecoration("Full name", Icons.person),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Please enter your name" : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: userNameController,
                        decoration: _inputDecoration("Username", Icons.verified_user_rounded),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Please enter your username" : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: emailController,
                        decoration: _inputDecoration("Email", Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                        value == null || value.isEmpty ? "Please enter your email" : null,
                      ),
                      const SizedBox(height: 12),

                      // Phone
                      TextFormField(
                        controller: phoneController,
                        decoration: _inputDecoration("Phone", Icons.phone),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                        value == null || value.isEmpty ? "Please enter your phone" : null,
                      ),
                      const SizedBox(height: 12),

                      // Address
                      TextFormField(
                        controller: addressController,
                        decoration: _inputDecoration("Address", Icons.home),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Please enter your address" : null,
                      ),
                      const SizedBox(height: 12),

                      // Password
                      TextFormField(
                        controller: passwordController,
                        decoration: _inputDecoration("Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: _inputDecoration("Confirm Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                obscureConfirmPassword = !obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm password";
                          }
                          if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Guest Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.go('/home');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kPrimary,
                            side: BorderSide(color: kPrimary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Continue as Guest",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showLoginDialog();
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: kPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoginDialog(
          onLoginSuccess: () {
            if (widget.onRegistrationSuccess != null) {
              widget.onRegistrationSuccess!();
            }
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400,fontSize: 14),
      prefixIcon: Icon(icon, color: kPrimary, size: 18),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
