// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quick_ticket/screens/booking_screen.dart';
//
// import '../../auth/auth_service.dart';
// import '../widgets/app_bar.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final phoneController = TextEditingController();
//   final fullNameController = TextEditingController();
//   final addressController = TextEditingController();
//   final userNameController = TextEditingController();
//
//   bool isLoading = false;
//   bool obscurePassword = true;
//   bool obscureConfirmPassword = true;
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     phoneController.dispose();
//     fullNameController.dispose();
//     addressController.dispose();
//     userNameController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     // Check if passwords match
//     if (passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Password and Confirm password must be same"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     final result = await AuthService.register(
//       email: emailController.text.trim(),
//       password: passwordController.text.trim(),
//       confirmPassword: confirmPasswordController.text.trim(),
//       phone: phoneController.text.trim(),
//       fullName: fullNameController.text.trim(),
//       address: addressController.text.trim(),
//       userName: userNameController.text.trim(),
//     );
//
//     setState(() => isLoading = false);
//
//     if (result['success']) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result['message']),
//           backgroundColor: Colors.green,
//         ),
//       );
//       // Navigate to login screen
//       context.go('/login');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result['message']),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBarSection(title: "Welcome to Quick Ticket"),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Enter your details for",
//                     style: TextStyle(color: Colors.black, fontSize: 18),
//                   ),
//                   Text(
//                     " SignUp",
//                     style: TextStyle(
//                       color: kPrimary,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//
//               // Full Name
//               TextFormField(
//                 controller: fullNameController,
//                 decoration: _inputDecoration("Full name", Icons.person),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? "Please enter your name" : null,
//               ),
//               const SizedBox(height: 12),
//
//               // Username
//               TextFormField(
//                 controller: userNameController,
//                 decoration: _inputDecoration("Username", Icons.verified_user_rounded),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? "Please enter your username" : null,
//               ),
//               const SizedBox(height: 12),
//
//               // Email
//               TextFormField(
//                 controller: emailController,
//                 decoration: _inputDecoration("Email", Icons.email),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) =>
//                 value == null || value.isEmpty ? "Please enter your email" : null,
//               ),
//               const SizedBox(height: 12),
//
//               // Phone
//               TextFormField(
//                 controller: phoneController,
//                 decoration: _inputDecoration("Phone", Icons.phone),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) =>
//                 value == null || value.isEmpty ? "Please enter your phone" : null,
//               ),
//               const SizedBox(height: 12),
//
//               // Address
//               TextFormField(
//                 controller: addressController,
//                 decoration: _inputDecoration("Address", Icons.home),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? "Please enter your address" : null,
//               ),
//               const SizedBox(height: 12),
//
//               // Password
//               TextFormField(
//                 controller: passwordController,
//                 decoration: _inputDecoration("Password", Icons.lock).copyWith(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       obscurePassword ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         obscurePassword = !obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: obscurePassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter password";
//                   }
//                   if (value.length < 6) {
//                     return "Password must be at least 6 characters";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//
//               // Confirm Password
//               TextFormField(
//                 controller: confirmPasswordController,
//                 decoration: _inputDecoration("Confirm Password", Icons.lock).copyWith(
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         obscureConfirmPassword = !obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: obscureConfirmPassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please confirm password";
//                   }
//                   if (value != passwordController.text) {
//                     return "Passwords do not match";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//
//               // Sign Up Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : _signUp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: kPrimary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                     "Sign Up",
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               // Guest Login Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: OutlinedButton(
//                   onPressed: () => context.go('/home'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: kPrimary,
//                     side: BorderSide(color: kPrimary),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     "Login as Guest",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//
//               // Login Link
//               TextButton(
//                 onPressed: () => context.go('/login'),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Already have an account?",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     Text(
//                       " Login",
//                       style: TextStyle(color: kPrimary, fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _inputDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: kPrimary, width: 1.5),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 1),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 1.5),
//       ),
//     );
//   }
// }