import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MapsController extends GetxController {
  FirebaseDatabase db = FirebaseDatabase.instance;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  late StreamSubscription<Position> positionStream;
  final LatLng _position = const LatLng(-27.6357848, -52.2745583);
  late GoogleMapController _mapsController;
  bool watchPositionFlag = false;

  static MapsController get to => Get.find<MapsController>();

  get mapsController => _mapsController;

  get position => _position;

  onMapsCreated(GoogleMapController gmc, bool isMotorista) async {
    watchPositionFlag = !watchPositionFlag;
    _mapsController = gmc;
    if (watchPositionFlag) {
      if(isMotorista){
        watchYourselfPosition();
      }else{
        watchDriverPosition();
      }
    } else {
      positionStream.cancel();
      getPosition();
    }
  }

  watchYourselfPosition() async {
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
    positionStream = Geolocator.getPositionStream().listen((Position position) {

      _mapsController.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));
    });
  }

  watchDriverPosition() async {
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
    db
        .ref("usuarios")
        .child("mHWJoMG77UWtaehzJkLTgGLoB4K3")
        .child("viagens")
        .child("-NER-JZ617H9fgrKwDRR")
        .child("location")
        .onValue
        .listen((event) {
      final position =
      Map<String, dynamic>.from(event.snapshot.value as dynamic);
      _mapsController.animateCamera(CameraUpdate.newLatLng(
          LatLng(position['latitude'], position['longitude'])));
    });
  }

  void getPosition() async {
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

    var position = await Geolocator.getCurrentPosition();
    _mapsController.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }
}
