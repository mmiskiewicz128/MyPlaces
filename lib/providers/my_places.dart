import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:places_app/helpers/db_helper.dart';
import 'package:places_app/models/place_type.dart';
import '../models/place.dart';

class MyPlaces with ChangeNotifier {
  List<Place> _list = [];

  List<Place> get list {
    return _list;
  }

  void addPlace(
      {String title,
      File pickedImage,
      PlaceType type,
      PlaceLocation location}) {
    final newPlace = Place(
      tilte: title,
      placeType: type ?? PlaceType.getPlaceTypes().first,
      id: DateTime.now().toString(),
      image: pickedImage,
      location: location,
    );

    _list.add(newPlace);
    notifyListeners();

    final placeMap = {
      'ID': newPlace.id,
      'Title': newPlace.tilte,
      'Image': newPlace.image?.path,
      'PlaceType': newPlace.placeType.id,
      'Location': json.encode({
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude
      })
    };

    DBHepler.insert(DBHepler.placeTebleName, placeMap);
  }

  Future<void> deletePlace(String placeId) async {
    _list.removeWhere((element) => element.id == placeId);

    await DBHepler.delete(DBHepler.placeTebleName, placeId);
    notifyListeners();
  }

  Future<void> fetchAndSetPlaces() async {
    final data = await DBHepler.getData(DBHepler.placeTebleName);
    _list = data.map((e) {
      return Place(
          id: e['ID'],
          tilte: e['Title'],
          placeType: PlaceType.getPlaceTypes()
              .firstWhere((pt) => pt.id == e['PlaceType']),
          image: e['Image'] != null ? File(e['Image']) : null,
          location: PlaceLocation.fromJson(json.decode(e['Location'])));
    }).toList();

    notifyListeners();
  }
}
