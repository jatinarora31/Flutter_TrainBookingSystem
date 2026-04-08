// auth_service.dart
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/token_service.dart';

class AuthService {
  static final Dio _dio = DioClient.getDio();

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/users/sign_in",
        data: {
          "user": {
            "email": email,
            "password": password,
          }
        },
      );

      print("Login Response Status: ${response.statusCode}");
      print("Login Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final token = data["token"];
          final user = data["user"];

          if (token != null && user is Map<String, dynamic>) {
            await TokenService.saveUserData(
              token: token.toString(),
              email: user["email"]?.toString() ?? email,
              phone: user["phone"]?.toString() ?? "",
              address: user["address"]?.toString() ?? "",
              fullName: user["full_name"]?.toString() ?? "",
              userName: user["username"]?.toString() ?? "",
              userId: user["id"]?.toString(),
              role: user["role"]?.toString(),
            );

            return {
              'success': true,
              'message': data["message"] ?? "Login successful",
              'data': data,
            };
          }
        }
      }

      String errorMessage = "Invalid email or password";
      if (response.data is Map<String, dynamic>) {
        errorMessage = response.data["message"]?.toString() ?? errorMessage;
      } else if (response.data is String) {
        errorMessage = response.data;
      }

      return {
        'success': false,
        'message': errorMessage,
        'data': null,
      };
    } on DioException catch (e) {
      print("Login Dio Error: ${e.message}");
      print("Login Dio Response: ${e.response?.data}");

      String errorMessage = "Login failed";

      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data["message"]?.toString() ?? errorMessage;
      } else if (e.response?.data is String) {
        errorMessage = e.response?.data as String;
      }

      return {
        'success': false,
        'message': errorMessage,
        'data': null,
      };
    } catch (e) {
      print("Login Error: $e");
      return {
        'success': false,
        'message': "Login failed: $e",
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String fullName,
    required String address,
    required String userName,
  }) async {
    if (password != confirmPassword) {
      return {
        'success': false,
        'message': "Passwords do not match",
        'data': null,
      };
    }

    if (password.length < 6) {
      return {
        'success': false,
        'message': "Password must be at least 6 characters",
        'data': null,
      };
    }

    try {
      final response = await _dio.post(
        "/users",
        data: {
          "user": {
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "phone": phone,
            "full_name": fullName,
            "address": address,
            "username": userName,
          }
        },
      );

      print("Register Response Status: ${response.statusCode}");
      print("Register Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final token = data["token"];
          final user = data["user"];

          if (token != null && user is Map<String, dynamic>) {
            await TokenService.saveUserData(
              token: token.toString(),
              email: user["email"]?.toString() ?? email,
              phone: user["phone"]?.toString() ?? phone,
              address: user["address"]?.toString() ?? address,
              fullName: user["full_name"]?.toString() ?? fullName,
              userName: user["username"]?.toString() ?? userName,
              userId: user["id"]?.toString(),
              role: user["role"]?.toString(),
            );
          }

          return {
            'success': true,
            'message': data["message"] ?? "Registration successful",
            'data': data,
          };
        }
      }

      String errorMessage = "Registration failed";
      if (response.data is Map<String, dynamic>) {
        errorMessage = response.data["message"]?.toString() ?? errorMessage;
      }

      return {
        'success': false,
        'message': errorMessage,
        'data': null,
      };
    } on DioException catch (e) {
      print("Register Dio Error: ${e.message}");

      String errorMessage = "Registration failed";

      if (e.response?.data is Map<String, dynamic>) {
        final errorData = e.response?.data as Map<String, dynamic>;

        if (errorData.containsKey("errors")) {
          final errors = errorData["errors"];
          if (errors is Map<String, dynamic>) {
            if (errors.containsKey("email")) {
              final emailErrors = errors["email"];
              errorMessage = emailErrors is List && emailErrors.isNotEmpty
                  ? emailErrors[0].toString()
                  : emailErrors.toString();
            } else if (errors.containsKey("username")) {
              final usernameErrors = errors["username"];
              errorMessage = usernameErrors is List && usernameErrors.isNotEmpty
                  ? usernameErrors[0].toString()
                  : usernameErrors.toString();
            } else if (errors.containsKey("phone")) {
              final phoneErrors = errors["phone"];
              errorMessage = phoneErrors is List && phoneErrors.isNotEmpty
                  ? phoneErrors[0].toString()
                  : phoneErrors.toString();
            }
          }
        } else {
          errorMessage = errorData["message"]?.toString() ?? errorMessage;
        }
      }

      return {
        'success': false,
        'message': errorMessage,
        'data': null,
      };
    } catch (e) {
      print("Register Error: $e");
      return {
        'success': false,
        'message': "Registration failed: $e",
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = await TokenService.getToken();
      if (token != null && token.isNotEmpty) {
        await _dio.post("/users/sign_out");
      }
      await TokenService.clearToken();

      return {
        'success': true,
        'message': "Logged out successfully",
      };
    } catch (e) {
      print("Logout Error: $e");
      await TokenService.clearToken();
      return {
        'success': true,
        'message': "Logged out successfully",
      };
    }
  }
}