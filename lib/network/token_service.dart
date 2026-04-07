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
    print("DATA --------- $email $phone $token");
    await prefs.setString(_key, token);
    await prefs.setString(_email, email);
    await prefs.setString(_phone, phone);
    print("=--------------------------- GETTING EMAIL${prefs.get(_email)}");
  }

  static Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_key);
    return _token;
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phone);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static bool isLoggedInSync() {
    return _token != null && _token!.isNotEmpty;
  }

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_key);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_email);
    await prefs.remove(_phone);
  }
}