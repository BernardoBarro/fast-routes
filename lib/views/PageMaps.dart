import 'dart:async';
import 'dart:ffi';

import 'package:fast_routes/models/Directions.dart';
import 'package:fast_routes/models/Passageiro.dart';
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
  final String? chave;

  const PageMaps({Key? key, this.chave}) : super(key: key);

  @override
  State<PageMaps> createState() => _PageMapsState();
}

class _PageMapsState extends State<PageMaps> {
  List<Passageiro> passageiros = [];
  bool modalBottom = false;
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
              isMotorista = (snapshot.value as dynamic),
              isMotorista ? getCurrentLocation() : getDriverLocation()
            });
  }

  getDriverLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      setState(() {
        currentLocation = LatLng(location.latitude!, location.longitude!);
      });
    });
    if (widget.chave != null) {
      positionStream = db
          .ref("usuarios")
          .child("mHWJoMG77UWtaehzJkLTgGLoB4K3")
          .child("viagens")
          .child(widget.chave!)
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
              position: LatLng(
                  currentLocation!.latitude, currentLocation!.longitude)));
        });
      });
    }
  }

  getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      setState(() {
        currentLocation = LatLng(location.latitude!, location.longitude!);
      });
    });

    if (widget.chave != null) {
      positionStream = location.onLocationChanged.listen((newLoc) {
        currentLocation = LatLng(newLoc.latitude!, newLoc.longitude!);

        Map<String, dynamic> position = {
          'latitude': newLoc.latitude,
          'longitude': newLoc.longitude,
        };
        _getRoute(newLoc.latitude, newLoc.longitude);

        db
            .ref("usuarios")
            .child(usuarioLogado!.uid)
            .child("viagens")
            .child(widget.chave!)
            .child("location")
            .set(position)
            .catchError((error) => print("Ocorreu um erro $error"));

        setState(() {
          _addMarker();
          _markersSet
              .removeWhere((marker) => marker.markerId == "currentLocation");
          _markersSet.add(Marker(
              markerId: const MarkerId("currentLocation"),
              position: LatLng(
                  currentLocation!.latitude, currentLocation!.longitude)));
        });
      });
    }
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
                  myLocationEnabled: (!isMotorista || widget.chave == null),
                  markers: _markersSet,
                  // polylines: {
                  //   if (_info != null)
                  //     Polyline(
                  //       polylineId: const PolylineId('overview_polyline'),
                  //       color: Colors.red,
                  //       width: 5,
                  //       points: _info!.polylinePoints
                  //           .map((e) => LatLng(e.latitude, e.longitude))
                  //           .toList(),
                  //     ),
                  // },
                  onMapCreated: (gmc) => {
                    _googleMapController = gmc,
                    controller.onMapsCreated(_googleMapController, isMotorista),
                  },
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
          if (passageiro.participa)
            {
              _marker = Marker(
                markerId: MarkerId(passageiro.nome + " origem"),
                infoWindow: InfoWindow(title: passageiro.nome),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                position: LatLng(
                    passageiro.origemLatitude, passageiro.origemLongitude),
              ),
              provisorio.add(_marker!),
              _marker = Marker(
                markerId: MarkerId(passageiro.nome + " destino"),
                infoWindow: InfoWindow(title: passageiro.nome),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                position: LatLng(
                    passageiro.destinoLatitude, passageiro.destinoLongitude),
              ),
              provisorio.add(_marker!)
            }
        });
    setState(() {
      _markersSet = provisorio;
    });
  }

  void _getRoute(double? latitude, double? longitude) async {
    provider.address.forEach((element) {
      passageiros.add(element);
    });
    final directions = await DirectionsRepository().getDirections(
        address: passageiros, latitude: latitude, longitude: longitude);
    setState(() => _info = directions);
    if (!modalBottom) {
      modalBottom = true;
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView.builder(
                itemCount: _info!.distance.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_info!.distance[index].nome +
                        " - " +
                        _info!.distance[index].distance),
                  );
                });
          });
    }
  }
}
