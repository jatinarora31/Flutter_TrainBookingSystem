import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _key = "auth_token";
  static const _email = "email";
  static const _phone = "phone";
  static String? _token;

  static Future<void> saveToken(String token,String email, String phone) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
    await prefs.setString(_email, email);
    await prefs.setString(_phone, phone);
  }

  static Future<String?> getToken() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_key);
    return _token;
  }

  static bool isLoggedInSync() {
    return _token != null;
  }

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_key);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}