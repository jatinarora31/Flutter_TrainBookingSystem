import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/token_service.dart';

class AuthService {
  static final Dio _dio = DioClient.getDio();

  static Future<bool> login({
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
      final data = response.data;
      print("LOGIN RESPONSE: $data");
      final token = data["token"];
      final userEmail = data["user"]?["email"] ?? email;
      final userPhone = data["user"]?["phone"] ?? "";
      if (token != null) {
        await TokenService.saveToken(token,userEmail,userPhone);
        return true;
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }


  static Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        "/users",
        data: {
          "user": {
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "phone": phone,
          }
        },
      );
      final data = response.data;
      print("REGISTER RESPONSE: $data");
      if (data["message"] == "Signed up successfully.") {
        return true;
      }
      return false;
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }
}