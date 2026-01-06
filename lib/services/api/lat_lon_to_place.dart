import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/core/errors/dio_failure_mapper.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/network/api_helper.dart';
import 'package:weather_app/src/models/place_model.dart';

class LatLonToPlace {
  static Future<Either<Failure, PlaceModel>> getPlaceName(
    double lat,
    double lon,
  ) async {
    try {
      final response = await ApiHelper.latLonToPlaceApiRequest(
        url: '/reverse',
        method: ApiMethod.GET,
        queryParameters: {'format': 'json', 'lat': lat, 'lon': lon},
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        return Left(Failure('Place data not available'));
      }

      return Right(
        PlaceModel.fromReverseJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(DioFailureMapper.map(e));
    }
  }
}
