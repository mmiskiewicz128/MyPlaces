import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:places_app/helpers/location_helper.dart';
import 'package:places_app/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final isSelection;

  MapScreen(this.initialLocation, {this.isSelection = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PickResult _pickedLocation;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 50,
              left: 10,
              child: Text(_pickedLocation?.formattedAddress ?? '')),
          PlacePicker(
            apiKey: GOOGLE_API_KEY,
            //forceSearchOnZoomChanged: true,
            //automaticallyImplyAppBarLeading: false,
            //autocompleteLanguage: "ko",
            //region: 'au',
            //selectInitialPosition: true,
            useCurrentLocation: true,
            selectedPlaceWidgetBuilder:
                (_, selectedPlace, state, isSearchBarFocused) {
              _pickedLocation = selectedPlace;
              print("state: $state, isSearchBarFocused: $isSearchBarFocused");
              return isSearchBarFocused
                  ? Container()
                  : FloatingCard(
                      elevation: 9,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey[200],
                      width: 300,
                      bottomPosition:
                          10.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                      leftPosition: deviceWidth * 0.2,
                      rightPosition: deviceWidth * 0.2,
                      child: state == SearchingState.Searching
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Text(
                                    selectedPlace.formattedAddress,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 5),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(8.0),
                                    elevation: 9,
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      'Pick Here',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(LatLng(
                                          _pickedLocation.geometry.location.lat,
                                          _pickedLocation
                                              .geometry.location.lng));
                                    },
                                  ),
                                ],
                              ),
                            ),
                    );
            },

            selectInitialPosition: true,

            initialPosition: LatLng(widget.initialLocation.latitude,
                widget.initialLocation.longitude),
            // onPlacePicked: (result) {
            //   _pickedLocation = result;
            //   Navigator.of(context).pop(LatLng(
            //       result.geometry.location.lat, result.geometry.location.lng));
            //   setState(() {});
            // },
          ),
        ],
      ),
    );
  }
}
