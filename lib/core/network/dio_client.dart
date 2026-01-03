import 'package:dio/dio.dart';
import 'package:weather_app/core/config/environment.dart';
import 'package:weather_app/core/network/dio_interceptors.dart';

class DioClient {
  static final Dio weatherDio = Dio(
    BaseOptions(
      baseUrl: Environment.baseUrlWeather,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  )..interceptors.add(DioInterceptors());

  static final Dio placeToLatLonDio = Dio(
    BaseOptions(
      baseUrl: Environment.baseUrlGeocoding,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  )..interceptors.add(DioInterceptors());

  static final Dio latLonToPlaceDio = Dio(
    BaseOptions(
      baseUrl: Environment.baseUrlReverseGeocoding,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
      headers: {'User-Agent': 'weather_forecast_app'},
    ),
  )..interceptors.add(DioInterceptors());
}
