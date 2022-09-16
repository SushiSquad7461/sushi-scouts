import 'package:dio/dio.dart';

class ErrorHelper {
  static String handleError(Exception error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errorDescription = "Request cancelled";
          break;
        case DioErrorType.connectTimeout:
          errorDescription = "Connection timeout";
          break;
        case DioErrorType.other:
          errorDescription = "No internet connection";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
        case DioErrorType.response:
          switch (error.response?.statusCode ?? 0) {
            case 400:
              if (error.response!.data is String) {
                errorDescription = error.response!.data;
              } else {
                errorDescription = error.response!.data["error"];
              }
              break;
            case 401:
              errorDescription = 'Unauthorized request';
              break;
            case 403:
              errorDescription = error.response!.data;
              break;
            case 404:
              errorDescription = error.response!.data;
              break;
            case 409:
              errorDescription = "Error due to a conflict";
              break;
            case 500:
              errorDescription = "Internal Server Error";
              break;
            case 503:
              errorDescription = 'Service unavailable';
              break;
            default:
              errorDescription =
                  "Received invalid status code: ${error.response?.statusCode ?? ''}";
          }
      }
    }
    return errorDescription;
  }
}
