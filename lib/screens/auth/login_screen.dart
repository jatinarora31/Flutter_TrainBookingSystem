import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/auth_service.dart';
import '../widgets/app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await AuthService.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (success) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final redirectRoute = extra?['redirect'];
      final redirectData = extra?['data'];
      if (redirectRoute != null) {
        context.go(redirectRoute, extra: redirectData);
      } else {
        context.go('/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarSection(title: "Login"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration("Email", Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? "Please enter email" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: _inputDecoration("Password", Icons.lock),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? "Please enter password" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A80D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.go("/register");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black),
                    ),
                    const Text(
                      " Sign Up",
                      style: TextStyle(color: Color(0xFF2A80D8)),
                    ),
                  ],
                ),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
