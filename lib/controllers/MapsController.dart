import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  StreamSubscription<Position>? positionStream;
  LatLng _position = LatLng(-27.6357848, -52.2745583);
  late GoogleMapController _mapsController;

  static MapsController get to => Get.find<MapsController>();

  get mapsController => _mapsController;

  get position => _position;

  onMapsCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    watchPosition();
  }

  watchPosition() async {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
        _mapsController.animateCamera(
            CameraUpdate.newLatLng(LatLng(latitude.value, longitude.value)));
      }
    });
  }

  Future<Position> _currentPosition() async {
    LocationPermission permission;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Por favor habilite a localização no smartphone.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosition() async {
    try {
      final position = await _currentPosition();
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      _mapsController.animateCamera(
          CameraUpdate.newLatLng(LatLng(latitude.value, longitude.value)));
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}