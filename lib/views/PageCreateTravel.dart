import 'package:flutter/material.dart';

class PageCreateTravel extends StatefulWidget {
  const PageCreateTravel({Key? key}) : super(key: key);

  @override
  State<PageCreateTravel> createState() => _PageCreateTravelState();
}

class _PageCreateTravelState extends State<PageCreateTravel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromRGBO(69, 69, 85, 1),
        ),
      ),
    );
  }
}
