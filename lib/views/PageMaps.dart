import 'dart:async';

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
  final String? chaveViagem;
  final String? chaveMotorista;
  final bool preview;

  const PageMaps(this.preview,
      {Key? key, this.chaveViagem, this.chaveMotorista})
      : super(key: key);

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

    if (widget.chaveViagem != null && widget.chaveMotorista != null) {
      positionStream = db
          .ref("usuarios")
          .child(widget.chaveMotorista!)
          .child("viagens")
          .child(widget.chaveViagem!)
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

    if (widget.chaveViagem != null) {
      setState(() {
        _markersSet = {};
      });
      positionStream = location.onLocationChanged.listen((newLoc) {
        currentLocation = LatLng(newLoc.latitude!, newLoc.longitude!);

        Map<String, dynamic> position = {
          'latitude': newLoc.latitude,
          'longitude': newLoc.longitude,
        };

        db
            .ref("usuarios")
            .child(usuarioLogado!.uid)
            .child("viagens")
            .child(widget.chaveViagem!)
            .child("location")
            .set(position)
            .catchError((error) => print("Ocorreu um erro $error"));

        setState(() {
          if (!widget.preview) {
            _getRoute(newLoc.latitude, newLoc.longitude);
            _markersSet
                .removeWhere((marker) => marker.markerId == "currentLocation");
            _markersSet.add(Marker(
                markerId: const MarkerId("currentLocation"),
                position: LatLng(
                    currentLocation!.latitude, currentLocation!.longitude)));
          } else {
            _addMarker();
          }
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
    var largura = MediaQuery.of(context).size.width;
    var alturaTotal = MediaQuery.of(context).size.height;
    var alturaAppBar = AppBar().preferredSize.height;
    var alturaLiquida = alturaTotal - alturaAppBar;

    var alturaMapa = alturaLiquida * 0.70;
    var alturaContainer = alturaLiquida * 0.30;

    provider = Provider.of<AddressProvider>(context, listen: true);
    return Scaffold(
        body: GetBuilder<MapsController>(
      init: controller,
      builder: (value) => _info == null
          ? Stack(
              alignment: Alignment.center,
              children: [
                currentLocation == null
                    ? const Center(child: Text("Loading..."))
                    : GoogleMap(
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation!.latitude,
                              currentLocation!.longitude),
                          zoom: 18,
                        ),
                        myLocationEnabled: (!isMotorista ||
                            widget.chaveViagem == null ||
                            widget.preview),
                        markers: _markersSet,
                        onMapCreated: (gmc) => {
                          _googleMapController = gmc,
                          controller.onMapsCreated(
                              _googleMapController,
                              isMotorista,
                              widget.chaveMotorista,
                              widget.chaveViagem),
                        },
                      ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 60.0,
                    width: 60.0,
                    child: FloatingActionButton(
                      backgroundColor: Color.fromARGB(0, 255, 255, 255),
                      onPressed: () => controller.onMapsCreated(
                          _googleMapController,
                          isMotorista,
                          widget.chaveMotorista,
                          widget.chaveViagem),
                      child: Icon(
                        Icons.center_focus_strong_outlined,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                currentLocation == null
                    ? const Center(child: Text("Loading..."))
                    : Container(
                        width: largura,
                        height: alturaMapa,
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation!.latitude,
                                currentLocation!.longitude),
                            zoom: 18,
                          ),
                          myLocationEnabled: (!isMotorista ||
                              widget.chaveViagem == null ||
                              widget.preview),
                          markers: _markersSet,
                          onMapCreated: (gmc) => {
                            _googleMapController = gmc,
                            controller.onMapsCreated(
                                _googleMapController,
                                isMotorista,
                                widget.chaveMotorista,
                                widget.chaveViagem),
                          },
                        ),
                      ),
                _info == null
                    ? const Center(child: Text("Loading..."))
                    : SingleChildScrollView(
                    child: Container(
                        decoration: new BoxDecoration(
                        color: Color.fromARGB(255, 250, 242, 242),
                        borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                      )),
                        width: largura,
                        height: alturaContainer,
                        child: ListView.builder(
                            itemCount: _info!.distance.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top:10,right: 180.0),
                                  child: Container(
                                    height: 30,
                                    decoration: new BoxDecoration(
                                      color: Color.fromARGB(255, 221, 216, 216),
                                      borderRadius: BorderRadius.circular(10)
                                            ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                                        child: Text(_info!.distance[index].nome +
                                          " - " +
                                          _info!.distance[index].distance),
                                      ),
                                  ),
                                ),
                              );
                            }),
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
                markerId: MarkerId(passageiro.nome),
                infoWindow: InfoWindow(title: passageiro.nome),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                position: LatLng(
                    passageiro.origemLatitude, passageiro.origemLongitude),
              ),
              provisorio.add(_marker!),
            }
          else
            {},
          if (widget.preview)
            {
              _marker = Marker(
                markerId: MarkerId(passageiro.nome),
                infoWindow: InfoWindow(title: passageiro.nome),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                position: LatLng(
                    passageiro.destinoLatitude, passageiro.destinoLongitude),
              ),
              provisorio.add(_marker!),
            }
        });
    setState(() {
      _markersSet = provisorio;
    });
  }

  void _getRoute(double? latitude, double? longitude) async {
    passageiros = [];
    provider.address.forEach((element) {
      passageiros.add(element);
    });
    final directions = await DirectionsRepository().getDirections(
        address: passageiros, latitude: latitude, longitude: longitude);
    setState(() {
      _info = directions;
      _addMarkerWithDistance(directions!);
      _changeOrigem(directions);
    });
  }

  _addMarkerWithDistance(Directions directions) {
    directions.distance.forEach((passageiro) => {
          if (passageiro.origem)
            {
              _marker = Marker(
                markerId: MarkerId(passageiro.nome),
                infoWindow: InfoWindow(title: passageiro.nome),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                position: LatLng(
                    passageiro.origemLatitude, passageiro.origemLongitude),
              ),
              setState(() {
                _markersSet.removeWhere(
                    (marker) => marker.markerId == passageiro.nome);
                _markersSet.add(_marker!);
              }),
            }
          else
            {
              _marker = Marker(
                markerId: MarkerId(passageiro.nome),
                infoWindow: InfoWindow(title: passageiro.nome),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                position: LatLng(
                    passageiro.destinoLatitude, passageiro.destinoLongitude),
              ),
              setState(() {
                _markersSet.removeWhere(
                    (marker) => marker.markerId == passageiro.nome);
                _markersSet.add(_marker!);
              }),
            }
        });
  }

  void _changeOrigem(Directions directions) {
    directions.distance.forEach((element) {
      if (element.distanceValue <= 15) {
        Map<String, dynamic> origem = {
          'origem': false,
        };
        db
            .ref("usuarios")
            .child(usuarioLogado!.uid)
            .child("viagens")
            .child(widget.chaveViagem!)
            .child("passageiros")
            .child(element.passagerUid)
            .update(origem);
      }
    });
  }
}
