// token_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _keyToken = "auth_token";
  static const String _keyEmail = "user_email";
  static const String _keyPhone = "user_phone";
  static const String _keyAddress = "user_address";
  static const String _keyUserName = "user_username";
  static const String _keyFullName = "user_full_name";
  static const String _keyUserId = "user_id";
  static const String _keyRole = "user_role";

  static String? _token;
  static String? _email;
  static String? _phone;
  static String? _address;
  static String? _userName;
  static String? _fullName;
  static String? _userId;
  static String? _role;

  static Future<void> saveUserData({
    required String token,
    required String email,
    required String phone,
    required String address,
    required String fullName,
    required String userName,
    String? userId,
    String? role,
  }) async {
    _token = token;
    _email = email;
    _phone = phone;
    _address = address;
    _fullName = fullName;
    _userName = userName;
    _userId = userId;
    _role = role;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPhone, phone);
    await prefs.setString(_keyAddress, address);
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyUserName, userName);
    if (userId != null) await prefs.setString(_keyUserId, userId);
    if (role != null) await prefs.setString(_keyRole, role);

    print("User data saved successfully");
    print("Email: $email");
    print("Phone: $phone");
    print("Full Name: $fullName");
    print("Username: $userName");
  }

  // Token methods
  static Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_keyToken);
    return _token;
  }

  static Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Email methods
  static Future<String?> getUserEmail() async {
    if (_email != null) return _email;
    final prefs = await SharedPreferences.getInstance();
    _email = prefs.getString(_keyEmail);
    return _email;
  }

  static Future<void> saveUserEmail(String email) async {
    _email = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  // Phone methods
  static Future<String?> getUserPhone() async {
    if (_phone != null) return _phone;
    final prefs = await SharedPreferences.getInstance();
    _phone = prefs.getString(_keyPhone);
    return _phone;
  }

  static Future<void> saveUserPhone(String phone) async {
    _phone = phone;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhone, phone);
  }

  // Full Name methods
  static Future<String?> getUserFullName() async {
    if (_fullName != null) return _fullName;
    final prefs = await SharedPreferences.getInstance();
    _fullName = prefs.getString(_keyFullName);
    return _fullName;
  }

  static Future<void> saveUserFullName(String fullName) async {
    _fullName = fullName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFullName, fullName);
  }

  // Username methods
  static Future<String?> getUserName() async {
    if (_userName != null) return _userName;
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString(_keyUserName);
    return _userName;
  }

  static Future<void> saveUserName(String userName) async {
    _userName = userName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, userName);
  }

  // Address methods
  static Future<String?> getUserAddress() async {
    if (_address != null) return _address;
    final prefs = await SharedPreferences.getInstance();
    _address = prefs.getString(_keyAddress);
    return _address;
  }

  static Future<void> saveUserAddress(String address) async {
    _address = address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAddress, address);
  }

  // User ID methods
  static Future<String?> getUserId() async {
    if (_userId != null) return _userId;
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString(_keyUserId);
    return _userId;
  }

  static Future<void> saveUserId(String userId) async {
    _userId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  // Role methods
  static Future<String?> getUserRole() async {
    if (_role != null) return _role;
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString(_keyRole);
    return _role;
  }

  static Future<void> saveUserRole(String role) async {
    _role = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final email = await getUserEmail();
    return token != null && token.isNotEmpty && email != null && email.isNotEmpty;
  }

  static bool isLoggedInSync() {
    return _token != null && _token!.isNotEmpty && _email != null && _email!.isNotEmpty;
  }

  // Load all user data from storage
  static Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_keyToken);
    _email = prefs.getString(_keyEmail);
    _phone = prefs.getString(_keyPhone);
    _address = prefs.getString(_keyAddress);
    _fullName = prefs.getString(_keyFullName);
    _userName = prefs.getString(_keyUserName);
    _userId = prefs.getString(_keyUserId);
    _role = prefs.getString(_keyRole);
  }

  // Clear all user data (logout)
  static Future<void> clearToken() async {
    _token = null;
    _email = null;
    _phone = null;
    _address = null;
    _fullName = null;
    _userName = null;
    _userId = null;
    _role = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPhone);
    await prefs.remove(_keyAddress);
    await prefs.remove(_keyFullName);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyRole);

    print("User data cleared successfully");
  }

  // Get all user data as a map
  static Future<Map<String, String?>> getAllUserData() async {
    await loadUserData();
    return {
      'token': _token,
      'email': _email,
      'phone': _phone,
      'address': _address,
      'fullName': _fullName,
      'userName': _userName,
      'userId': _userId,
      'role': _role,
    };
  }
}