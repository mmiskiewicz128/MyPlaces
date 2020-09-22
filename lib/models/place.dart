import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:places_app/models/place_type.dart';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation(
      {@required this.latitude, @required this.longitude, this.address});

  factory PlaceLocation.fromJson(Map<String, dynamic> map) {
    return PlaceLocation(
        latitude: map['lat'] as double, longitude: map["lng"] as double);
  }
}

class Place {
  final String id;
  final String tilte;
  final PlaceLocation location;
  final PlaceType placeType;
  final File image;

  Place(
      {@required this.id,
      @required this.tilte,
      @required this.location,
      @required this.placeType,
      @required this.image});
}
