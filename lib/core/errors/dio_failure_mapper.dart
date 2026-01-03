import 'package:dio/dio.dart';
import 'failure.dart';

class DioFailureMapper {
  static Failure map(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkFailure('Connection timeout');

      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Server not responding');

      case DioExceptionType.badResponse:
        return ServerFailure('Server error: ${error.response?.statusCode}');

      default:
        return const NetworkFailure('Unexpected error occurred');
    }
  }
}
