import 'package:flutter/material.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';

import 'PageViagens.dart';
import 'PageMap.dart';
import 'PagePerfil.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _selectedIndex = 1;
  final List<Widget> _telas = [
    PagePerfil(),
    PageMap(),
    PageViagens(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromRGBO(69, 69, 85, 1),
        unselectedItemColor: Color.fromRGBO(255, 255, 255, 1),
        selectedItemColor: Color.fromRGBO(255, 255, 255, 1),
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_outlined,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_sharp,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            label: 'Viagens',
          ),
        ],
      ),
    );
  }
}
