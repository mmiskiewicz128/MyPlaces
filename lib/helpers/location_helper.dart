import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'YOUR_GOOGLE_MAPS_API_KEY';


class LocationHelper {
  static String generateLocationPreviewImage({double latitude, double longitude}) {
    return'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=800x600&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';  
  }
  
  static Future<String> getPlaceAddress(double latitude, double longitude) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }

} 