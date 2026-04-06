
import 'package:dio/dio.dart';
import 'package:quick_ticket/network/token_service.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(baseUrl: "http://172.30.1.49:3000")
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (option, handler) async {
       final token = await TokenService.getToken();
       if(token != null) {
         option.headers["Authorization"] = "Bearer $token";
       } else {
         print("No token → guest mode");
       }
       return handler.next(option);
      },
      onError: (error, handler) async {
        if(error.response?.statusCode == 401) {
          await TokenService.clearToken();
        }
        return handler.next(error);
      },
    ));

    dio.interceptors.add(LogInterceptor(requestBody: true,responseBody: true));
    return dio;
  }
}