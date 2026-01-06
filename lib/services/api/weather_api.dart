import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/core/errors/dio_failure_mapper.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/network/api_helper.dart';
import 'package:weather_app/src/models/weather_model.dart';

class WeatherApi {
  static const int pastDays = 7;

  static Future<Either<Failure, WeatherModel>> fetchWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final Response response = await ApiHelper.weatherApiRequest(
        url: '/forecast',
        method: ApiMethod.GET,
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current':
              'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,showers,snowfall,weather_code,pressure_msl,cloud_cover,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m',
          'hourly':
              'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,pressure_msl,cloud_cover,precipitation_probability,precipitation,wind_speed_10m,wind_direction_10m,wind_gusts_10m',
          'daily':
              'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max,precipitation_probability_max,wind_speed_10m_max',
          'timezone': 'auto',
          'past_days': pastDays,
        },
      );

      if (response.data == null ||
          response.data is! Map<String, dynamic> ||
          response.data['current'] == null ||
          response.data['hourly'] == null ||
          response.data['daily'] == null) {
        return Left(Failure('Incomplete weather data'));
      }

      return Right(
        WeatherModel.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(DioFailureMapper.map(e));
    }
  }
}
