import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/core/errors/dio_failure_mapper.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/network/dio_client.dart';
import 'package:weather_app/src/models/place_model.dart';

class PlaceToLatLon {
  static Future<Either<Failure, List<PlaceModel>>> getLatLon(
    String query,
  ) async {
    try {
      final response = await DioClient.placeToLatLonDio.get(
        '/search',
        queryParameters: {'name': query},
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        return Left(Failure('Invalid response format'));
      }

      final data = response.data as Map<String, dynamic>;
      
      if (data['results'] == null || data['results'] is! List<dynamic>) {
        return Left(Failure('Place data not available'));
      }

      try {
        final results = (data['results'] as List<dynamic>)
            .map((e) {
              if (e is! Map<String, dynamic>) {
                return null;
              }
              return PlaceModel.fromSearchJson(e);
            })
            .whereType<PlaceModel>()
            .toList();

        if (results.isEmpty) {
          return Left(Failure('No places found'));
        }

        return Right(results);
      } catch (e) {
        return Left(Failure('Failed to parse place data: $e'));
      }
    } on DioException catch (e) {
      return Left(DioFailureMapper.map(e));
    }
  }
}
