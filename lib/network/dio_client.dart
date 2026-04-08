// dio_client.dart
import 'package:dio/dio.dart';
import 'package:quick_ticket/network/token_service.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://172.30.1.49:3000",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip adding token for login and register endpoints
        final isAuthEndpoint = options.path.contains('/users/sign_in') ||
            options.path.contains('/users');

        if (!isAuthEndpoint) {
          final token = await TokenService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
            print("Token added to request: ${options.path}");
          } else {
            print("No token → guest mode for: ${options.path}");
          }
        } else {
          print("Auth endpoint, skipping token: ${options.path}");
        }

        print("Request: ${options.method} ${options.path}");
        print("Request Data: ${options.data}");

        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("Response Status: ${response.statusCode}");
        print("Response Data: ${response.data}");
        return handler.next(response);
      },
      onError: (error, handler) async {
        print("Error: ${error.message}");
        print("Error Response: ${error.response?.data}");
        print("Error Status: ${error.response?.statusCode}");

        if (error.response?.statusCode == 401) {
          // Only clear token if it's not an auth endpoint
          final isAuthEndpoint = error.requestOptions.path.contains('/users/sign_in') ||
              error.requestOptions.path.contains('/users');
          if (!isAuthEndpoint) {
            await TokenService.clearToken();
            print("Token cleared due to 401");
          }
        }
        return handler.next(error);
      },
    ));

    // Add log interceptor for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ));

    return dio;
  }
}