import 'package:dio/dio.dart';
import 'package:weather_app/core/network/dio_client.dart';

// ignore: constant_identifier_names
enum ApiMethod { GET, POST, PUT, DELETE, PATCH }

class ApiHelper {
  static final ApiHelper _instance = ApiHelper._internal();
  factory ApiHelper() => _instance;
  ApiHelper._internal();

  static Future<Response> weatherApiRequest({
    required String url,
    required ApiMethod method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    return _request(
      dio: DioClient.weatherDio,
      url: url,
      method: method,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
    );
  }

  static Future<Response> latLonToPlaceApiRequest({
    required String url,
    required ApiMethod method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    return _request(
      dio: DioClient.latLonToPlaceDio,
      url: url,
      method: method,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
    );
  }

  static Future<Response> placeToLatLonApiRequest({
    required String url,
    required ApiMethod method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    return _request(
      dio: DioClient.placeToLatLonDio,
      url: url,
      method: method,
      headers: headers,
      queryParameters: queryParameters,
      body: body,
    );
  }

  static Future<Response> _request({
    required Dio dio,
    required String url,
    required ApiMethod method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    return await dio.request(
      url,
      queryParameters: queryParameters,
      data: body,
      options: Options(method: method.name.toUpperCase(), headers: headers),
    );
  }
}
