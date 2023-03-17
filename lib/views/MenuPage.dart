import 'package:flutter/material.dart';

import 'AccountPage.dart';
import 'ClothesListPage.dart';
import 'ShoppingCartPage.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    ClothesPage(),
    ShoppingCartPage(),
    AccountPage(),
  ];

  void onTabClicked(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MIAGED'),
        automaticallyImplyLeading: false,
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabClicked,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
      ),
    );
  }
}
