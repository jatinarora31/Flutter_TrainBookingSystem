import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/screens/booking_screen.dart';

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
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final userNameController = TextEditingController();

  bool isLoading = false;

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

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    if(!(passwordController.text == confirmPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password and Confirm password must be same"))
      );
    }

    final success = await AuthService.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      phone: phoneController.text.trim(),
      fullName: fullNameController.text.trim(),
      address: addressController.text.trim(),
      userName: userNameController.text.trim()
    );

    setState(() => isLoading = false);

    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful")),
      );
      context.go("/setting/login");
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
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enter your details for", style: TextStyle(color: Colors.black,fontSize: 20)),
                  Text(" SignUp", style: TextStyle(color: kPrimary,fontWeight: FontWeight.bold,fontSize: 25))
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: fullNameController,
                decoration: _inputDecoration("Full name", Icons.person),
                validator: (value) =>
                value!.isEmpty ? "Please enter your name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: userNameController,
                decoration: _inputDecoration("Username", Icons.verified_user_rounded),
                validator: (value) =>
                value!.isEmpty ? "Please enter your username" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration("Email", Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value!.isEmpty ? "Please enter your email" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: _inputDecoration("Phone", Icons.person),
                validator: (value) =>
                value!.isEmpty ? "Please enter your phone" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: _inputDecoration("Address", Icons.home),
                validator: (value) =>
                value!.isEmpty ? "Please enter your address" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: _inputDecoration("Password", Icons.lock),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? "Please enter password" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                decoration: _inputDecoration("Confirm Password", Icons.lock),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? "Please confirm password" : null,
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 5),
              TextButton(
                onPressed: () => context.go("/setting/login"),
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