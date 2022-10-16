import 'package:fast_routes/controllers/MapsController.dart';
import 'package:fast_routes/models/Directions.dart';
import 'package:fast_routes/providers/AddressProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../clients/DirectionsRepository.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final controller = Get.put(MapsController());
  late AddressProvider provider;
  Set<Marker> _markersSet = {};
  Marker? _marker;
  Directions? _info;

  @override
  void dispose() {
    controller.positionStream.cancel();
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
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: controller.position,
                zoom: 18,
              ),
              onMapCreated: controller.onMapsCreated,
              myLocationEnabled: true,
              markers: _addMarker.call(),
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
              onTap: _getRoute,
            ),
            // if (_info != null)
            //   Positioned(
            //     top: 20.0,
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(
            //         vertical: 6.0,
            //         horizontal: 12.0,
            //       ),
            //       decoration: BoxDecoration(
            //           color: Colors.yellowAccent,
            //           borderRadius: BorderRadius.circular(20.0),
            //           boxShadow: const [
            //             BoxShadow(
            //               color: Colors.black26,
            //               offset: Offset(0, 2),
            //               blurRadius: 6.0,
            //             )
            //           ]),
            //       child: Text(
            //         '${_info!.totalDistance}, ${_info!.totalduration}',
            //         style: const TextStyle(
            //           fontSize: 18.0,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Set<Marker> _addMarker() {
    provider.address.forEach((passageiro) => {
          _marker = Marker(
            markerId: MarkerId(passageiro.nome),
            infoWindow: InfoWindow(title: passageiro.nome),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: LatLng(passageiro.latitude, passageiro.longitude),
          ),
          _markersSet.add(_marker!)
        });
    return _markersSet;
  }

  void _getRoute(LatLng pos) async {
    final directions =
        await DirectionsRepository().getDirections(address: provider.address);
    // TODO alterar para enviar lista de LatLng
    setState(() => _info = directions);
  }
}
