import 'package:flutter/material.dart';

class PlaceType {
  int id;
  IconData icon;
  String title;

  PlaceType({this.id, this.icon, this.title});

  static List<PlaceType> getPlaceTypes() {
    return [
      PlaceType(id: 1, icon: Icons.location_on, title: 'Nice Place'),
      PlaceType(id: 2, icon: Icons.restaurant, title: 'Restaurant'),
      PlaceType(id: 3, icon: Icons.shopping_cart, title: 'Shopping'),
      PlaceType(id: 4, icon: Icons.grade, title: 'Entertainment'),
    ];
  }
}


