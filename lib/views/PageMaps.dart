import 'dart:async';

import 'package:fast_routes/models/Directions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../clients/DirectionsRepository.dart';
import '../controllers/MapsController.dart';
import '../providers/AddressProvider.dart';

class PageMaps extends StatefulWidget {
  const PageMaps({Key? key}) : super(key: key);

  @override
  State<PageMaps> createState() => _PageMapsState();
}

class _PageMapsState extends State<PageMaps> {
  Set<Marker> _markersSet = {};
  Marker? _marker;
  late GoogleMapController _googleMapController;
  final controller = Get.put(MapsController());
  bool isMotorista = false;
  late StreamSubscription positionStream;
  FirebaseDatabase db = FirebaseDatabase.instance;
  User? usuarioLogado = FirebaseAuth.instance.currentUser;
  LatLng? currentLocation;
  late AddressProvider provider;
  Directions? _info;

  performingSingleFetch() {
    db
        .ref("usuarios")
        .child(usuarioLogado!.uid)
        .child("isMotorista")
        .get()
        .then((snapshot) => {
              print(snapshot.value),
              isMotorista = (snapshot.value as dynamic),
              _addMarker(),
              if (isMotorista) {getCurrentLocation()} else {getDriverLocation()}
            });
  }

  getDriverLocation() async {
    positionStream = db
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
      setState(() {
        _markersSet
            .removeWhere((marker) => marker.markerId == "currentLocation");
        _markersSet.add(Marker(
            markerId: const MarkerId("currentLocation"),
            position:
                LatLng(currentLocation!.latitude, currentLocation!.longitude)));
      });
    });
  }

  getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = LatLng(location.latitude!, location.longitude!);
    });

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

      setState(() {
        _markersSet
            .removeWhere((marker) => marker.markerId == "currentLocation");
        _markersSet.add(Marker(
            markerId: const MarkerId("currentLocation"),
            position:
                LatLng(currentLocation!.latitude, currentLocation!.longitude)));
      });
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
    provider = Provider.of<AddressProvider>(context, listen: true);
    return Scaffold(
        body: GetBuilder<MapsController>(
      init: controller,
      builder: (value) => Stack(
        alignment: Alignment.center,
        children: [
          currentLocation == null
              ? const Center(child: Text("Loading..."))
              : GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                    zoom: 18,
                  ),
                  myLocationEnabled: !isMotorista,
                  markers: _markersSet,
                  polylines: {
                    if (_info != null)
                      Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: Colors.red,
                        width: 5,
                        points: _info!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                  onMapCreated: (gmc) => {
                    _googleMapController = gmc,
                    controller.onMapsCreated(_googleMapController, isMotorista)
                  },
                  onTap: _getRoute,
                ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 60.0,
              width: 60.0,
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(0, 255, 255, 255),
                onPressed: () =>
                    controller.onMapsCreated(_googleMapController, isMotorista),
                child: Icon(
                  Icons.center_focus_strong_outlined,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  _addMarker() {
    Set<Marker> provisorio = {};
    provider.address.forEach((passageiro) => {
          _marker = Marker(
            markerId: MarkerId(passageiro.nome),
            infoWindow: InfoWindow(title: passageiro.nome),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: LatLng(passageiro.latitude, passageiro.longitude),
          ),
          provisorio.add(_marker!)
        });
    setState(() {
      _markersSet = provisorio;
    });
  }

  void _getRoute(LatLng pos) async {
    final directions =
        await DirectionsRepository().getDirections(address: provider.address);
    // TODO alterar para enviar lista de LatLng
    setState(() => _info = directions);
  }
}
