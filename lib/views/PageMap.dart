import 'package:flutter/material.dart';

class PageMap extends StatefulWidget {
  const PageMap({Key? key}) : super(key: key);

  @override
  State<PageMap> createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromARGB(255, 255, 145, 0),
          padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(),
          ),
        ),
      ),
    );
  }
}
