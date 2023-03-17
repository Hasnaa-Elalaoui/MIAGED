import 'dart:math';

import 'package:flutter/material.dart';
import 'package:startup_name/api/firestore.dart';

import '../models/cloth.dart';
import 'ClothDetailsPage.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class ClothesPage extends StatefulWidget {
  @override
  _ClothesPageState createState() => _ClothesPageState();
}

class _ClothesPageState extends State<ClothesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['Tous', 'pantalon', 'veste', 'chemise','robe', 'chaussures', 'chapeaux'];
  var category = '';
  Map<String, List<Cloth>> _categoryClothesMap = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _categories.length);
    _tabController.addListener(_onTabChanged);
    _getClothesByCategory();
  }

  // map each cloth to its corresponding category
  void _getClothesByCategory() async {
    List<Cloth> allClothes = await Firestore.getAllClothes();
    for (String category in _categories) {
      if (category == 'Tous') {
        _categoryClothesMap[category] = allClothes;
      } else {
        List<Cloth> clothesInCategory = allClothes.where((cloth) => cloth.category == category).toList();
        _categoryClothesMap[category] = clothesInCategory;
      }
    }
    setState(() {});
  }

  void _onTabChanged() {
    setState(() {});
  }

  RangeValues _rangeValues = RangeValues(0.0, 200.0);

  // filter clothes by max and min price
  List<Cloth>? _getFilteredClothes() {
    return _categoryClothesMap[category]?.where((cloth) =>
        cloth.price >= _rangeValues.start &&
        cloth.price <= _rangeValues.end)
        .toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Filtres"),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fourchette de prix : ${_rangeValues.start.round()} - ${_rangeValues.end.round()}"),
                  SizedBox(height: 10),
                  RangeSlider(
                    values: _rangeValues,
                    min: 0.0,
                    max: 200.0,
                    divisions: 20,
                    labels: RangeLabels(
                      _rangeValues.start.round().toString(),
                      _rangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _rangeValues = values;
                        _onTabChanged();
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Appliquer"),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: _categories.map((category) => Tab(text: category.capitalize())).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          this.category = category;
          return _buildClothesList(_getFilteredClothes() ?? []);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        child: Icon(Icons.filter_alt),
      ),
    );
  }

  Widget _buildClothesList(List<Cloth> clothesList) {
    if (clothesList.isEmpty) {
      return Center(child: Text('No clothes found'));
    }
    return ListView.builder(
      itemCount: clothesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClothDetailPage(cloth: clothesList[index]),
              ),
            );
          },
          child: ListTile(
            leading: Image.network(
              clothesList[index].imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text('${clothesList[index].name} - ${clothesList[index].size}'),
            subtitle: Text(clothesList[index].description),
            trailing: Text('\$${clothesList[index].price.toStringAsFixed(2)}'),
          ),
        );
      },
    );
  }
}
