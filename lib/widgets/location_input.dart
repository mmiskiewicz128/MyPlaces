import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:places_app/helpers/location_helper.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/screens/map_screen.dart';

class LoactionInput extends StatefulWidget {
  final Function onSelected;

  LoactionInput(this.onSelected);

  @override
  _LoactionInputState createState() => _LoactionInputState();
}

class _LoactionInputState extends State<LoactionInput> {
  ScrollController _controller;
  String _previewImageUrl;
  bool _isCurrentLocationSeleted = false;
  bool _isOnMapSelected = false;
  bool _animationDone = true;
  Image _mapImage;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  Future<void> _selectCurrentUserLocation() async {
    final locationData = await Location().getLocation();

    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locationData.latitude, longitude: locationData.longitude);

    final address =
        await getPlaceAddress(locationData.latitude, locationData.longitude);

    setState(() {
      _isOnMapSelected = false;
      _previewImageUrl = staticMapImageUrl;
      _isCurrentLocationSeleted = staticMapImageUrl != null;
      _mapImage = Image.network(_previewImageUrl, fit: BoxFit.fill);

      widget.onSelected(PlaceLocation(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
          address: address));
    });
  }

  Future<void> _selectOnMap() async {
    final location = await Location().getLocation();

    final selectedLocation = await Navigator.of(context)
        .push<LatLng>(MaterialPageRoute(builder: (ctx) {
      return MapScreen(
        PlaceLocation(
            latitude: location.latitude, longitude: location.longitude),
        isSelection: true,
      );
    }));

    if (selectedLocation == null) {
      return;
    }

    final address = await getPlaceAddress(
        selectedLocation.latitude, selectedLocation.longitude);

    setState(() {
      final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude);
      _previewImageUrl = staticMapImageUrl;
      _isCurrentLocationSeleted = false;
      _isOnMapSelected = true;
      _mapImage = Image.network(_previewImageUrl, fit: BoxFit.fill);

      widget.onSelected(PlaceLocation(
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude,
          address: address));
    });
  }

  Future<String> getPlaceAddress(double lat, double lang) async {
    return await LocationHelper.getPlaceAddress(lat, lang);
  }

  void _scrollToCenter() {
    if(_previewImageUrl == null){
      return;
    }

    _animationDone = false;
    _controller.animateTo(
      110,
      duration: new Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ExpansionTile(
            onExpansionChanged: (value) async {
              if (value && _animationDone) {
                await new Future.delayed(const Duration(milliseconds: 500));
                return _scrollToCenter();
              } else {
                _animationDone = true;
              }
            },
            trailing: !_isCurrentLocationSeleted && !_isOnMapSelected
                ? SizedBox(width: 2)
                : null,
            title: Row(
              children: [
                FlatButton.icon(
                    onPressed: _selectCurrentUserLocation,
                    icon: Icon(
                      Icons.location_on,
                      color: _isCurrentLocationSeleted
                          ? Theme.of(context).accentColor
                          : Colors.black,
                    ),
                    label: Text(
                      'Current location',
                      style: TextStyle(
                          color: _isCurrentLocationSeleted
                              ? Theme.of(context).accentColor
                              : Colors.black),
                    )),
                FlatButton.icon(
                    onPressed: _selectOnMap,
                    icon: Icon(
                      Icons.location_on,
                      color: _isOnMapSelected
                          ? Theme.of(context).accentColor
                          : Colors.black,
                    ),
                    label: Text(
                      'Select on map',
                      style: TextStyle(
                          color: _isOnMapSelected
                              ? Theme.of(context).accentColor
                              : Colors.black),
                    )),
              ],
            ),
            children: [
              Container(
                width: double.infinity,
                height: 150,
                child: SingleChildScrollView(
                    controller: _controller,
                    child: Container(
                        height: 400,
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        child: _previewImageUrl == null
                            ? Text('No Locaton Chosen',
                                textAlign: TextAlign.center)
                            : _mapImage)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
