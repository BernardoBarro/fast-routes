import 'package:fast_routes/views/PagePerfil.dart';
import 'package:flutter/material.dart';
import 'package:fast_routes/views/Maps.dart';

class PageMap extends StatefulWidget {
  const PageMap({Key? key}) : super(key: key);

  @override
  State<PageMap> createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Maps(),
    );
  }
}
