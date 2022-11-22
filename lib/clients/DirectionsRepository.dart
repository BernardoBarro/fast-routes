import 'package:dio/dio.dart';
import 'package:fast_routes/models/Passageiro.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fast_routes/.env.dart';

import '../models/Directions.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    // TODO alterar para retornar lista de LatLng
    required List<Passageiro> address,
    double? latitude,
    double? longitude,
  }) async {
    address.removeWhere((element) => element.participa == false);
    String destination = "";
    address.forEach((element) {
      if(element.origem){
        destination += "${element.origemLatitude},${element.origemLongitude}|";
      }else{
        destination += "${element.destinoLatitude},${element.destinoLongitude}|";
      }
    });
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origins': '${latitude},${longitude}',
        'destinations': destination,
        'key': googleAPIKey,
      },
    );
    return Directions.fromMap(response.data, address);
  }
}
