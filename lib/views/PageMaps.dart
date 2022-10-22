import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PageMaps extends StatefulWidget {
  const PageMaps({Key? key}) : super(key: key);

  @override
  State<PageMaps> createState() => _PageMapsState();
}

class _PageMapsState extends State<PageMaps> {
  bool isMotorista = false;
  late StreamSubscription positionStream;
  FirebaseDatabase db = FirebaseDatabase.instance;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;

  // final Completer<GoogleMapController> _controller = Completer();
  LatLng? currentLocation;

  performingSingleFetch() {
    db
        .ref("usuarios")
        .child(usuarioLogado!.uid)
        .child("isMotorista")
        .get()
        .then((snapshot) => {
              print(snapshot.value),
              isMotorista = (snapshot.value as dynamic),
              if (isMotorista) {getCurrentLocation()} else {getDriverLocation()}
            });
  }

  getDriverLocation() async {
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
      currentLocation = LatLng(position['latitude'], position['longitude']);
      setState(() {});
    });
  }

  getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = LatLng(location.latitude!, location.longitude!);
    });

    // GoogleMapController gmc = await _controller.future;

    positionStream = location.onLocationChanged.listen((newLoc) {
      currentLocation = LatLng(newLoc.latitude!, newLoc.longitude!);

      Map<String, dynamic> position = {
        'latitude': newLoc.latitude,
        'longitude': newLoc.longitude,
      };

      db
          .ref("usuarios")
          .child("mHWJoMG77UWtaehzJkLTgGLoB4K3")
          .child("viagens")
          .child("-NER-JZ617H9fgrKwDRR")
          .child("location")
          .set(position)
          .catchError((error) => print("Ocorreu um erro $error"));

      // gmc.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //   target: LatLng(newLoc.latitude!, newLoc.longitude!),
      //   zoom: 13.5,
      // )));

      setState(() {});
    });
  }

  @override
  void initState() {
    performingSingleFetch();
    super.initState();
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentLocation == null
            ? const Center(child: Text("Loading"))
            : GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 18,
                ),
                myLocationEnabled: true,
                markers: {
                  Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!)),
                },
                // onMapCreated: (mapController) {
                //   verify();
                // },
              ));
  }
}
