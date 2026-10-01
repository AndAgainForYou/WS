import 'package:dio/dio.dart';
import 'package:ws_test/core/utils/json_utils.dart';

String mapDioError(DioException error) {
  final data = error.response?.data;
  if (data != null) {
    try {
      final message = asJsonMap(data)['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    } on Exception {
      // Fall through to Dio's own message.
    }
  }

  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout =>
      'Connection timeout. Please try again.',
    DioExceptionType.connectionError =>
      'No internet connection. Please try again.',
    DioExceptionType.badResponse =>
      'Server error (${error.response?.statusCode ?? 'unknown'}).',
    _ => error.message ?? 'Unexpected network error.',
  };
}
