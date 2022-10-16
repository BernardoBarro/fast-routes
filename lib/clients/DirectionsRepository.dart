import 'package:dio/dio.dart';
import 'package:fast_routes/models/Passageiro.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fast_routes/.env.dart';

import '../models/Directions.dart';


class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required List<Passageiro> origin,
  }) async {
    List<Map<String, dynamic>> responseList = [];
    for(int i=0;i<origin.length-1;i++){
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin![i].latitude},${origin![i].longitude}',
          'destination': '${origin![i+1].latitude},${origin![i+1].longitude}',
          'key': googleAPIKey,
        },
      );
      if(response.statusCode == 200) {
        responseList.add(response.data);
      }
    }

    return Directions.fromMap(responseList);
  }
}