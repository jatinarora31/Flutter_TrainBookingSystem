import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_service.dart';
import '../widgets/app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await AuthService.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      phone: phoneController.text.trim(),
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful")),
      );
      context.go("/login");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarSection(title: "Welcome to Quick Ticket"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration("Email", Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value!.isEmpty ? "Please enter your email" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                decoration: _inputDecoration("Phone", Icons.person),
                validator: (value) =>
                value!.isEmpty ? "Please enter your phone" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: _inputDecoration("Password", Icons.lock),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? "Please enter password" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                decoration: _inputDecoration("Confirm Password", Icons.lock),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? "Please confirm password" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A80D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => context.go("/home"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF2A80D8),
                    side: const BorderSide(
                      color: Color(0xFF2A80D8),
                      width: 0.1
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login as Guest",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.go("/login"),
                child: Row(mainAxisAlignment: MainAxisAlignment.center ,children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  const Text(
                    " Login",
                    style: TextStyle(color: Color(0xFF2A80D8)),
                  )
                ],),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade700),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding:
      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}