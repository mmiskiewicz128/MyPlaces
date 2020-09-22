import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:map_launcher/map_launcher.dart' as launher;
import 'package:places_app/helpers/location_helper.dart';
import 'package:places_app/models/place.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const String routeName = '/PlaceDetails';

  Future<String> getPlaceAddress(double lat, double lang) async {
    return await LocationHelper.getPlaceAddress(lat, lang);
  }

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context).settings.arguments as Place;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.near_me,
            size: 30,
          ),
          onPressed: () async {
            final availableMaps = await launher.MapLauncher.installedMaps;
            String address = await getPlaceAddress(place.location.latitude,
                                place.location.longitude);

            await showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Wrap(
                        children: <Widget>[
                          for (var map in availableMaps)
                            ListTile(
                              onTap: () => map.showMarker(
                                coords: launher.Coords(place.location.latitude,
                                    place.location.longitude),
                                title: address,
                                description: address
                              ),
                              title: Text(map.mapName),
                              leading: Image(
                                image: map.icon,
                                height: 30.0,
                                width: 30.0,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        appBar: AppBar(title: Text(place.tilte)),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    child: Container(
                        width: double.infinity,
                        child: place.image != null
                            ? Image.file(place.image, fit: BoxFit.cover)
                            : Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                    'assets/images/mapBackground.png',
                                    fit: BoxFit.cover),
                              )),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Card(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Icon(
                          place.placeType.icon,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 5),
              elevation: 9,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: 50,
                color: Theme.of(context).primaryColor,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                        child: FutureBuilder(
                            future: getPlaceAddress(place.location.latitude,
                                place.location.longitude),
                            builder: (_, address) {
                              if (address.connectionState ==
                                  ConnectionState.waiting) return Container();
                              if (address.hasData)
                                return Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.white),
                                      SizedBox(width: 5),
                                      FittedBox(
                                        child: SizedBox(
                                            width: deviceWidth * 1,
                                            child: Text(address.data.toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20))),
                                      ),
                                    ],
                                  ),
                                );
                              return Container();
                            }))),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: GoogleMap(
                  key: ValueKey(place.id),
                  markers: {
                    Marker(
                      GeoCoord(
                          place.location.latitude, place.location.longitude),
                    ),
                  },
                  initialZoom: 17,
                  initialPosition: GeoCoord(place.location.latitude,
                      place.location.longitude), // Los Angeles, CA
                  mapType: MapType.roadmap,
                  interactive: true,
                  mobilePreferences: const MobileMapPreferences(
                    trafficEnabled: true,
                    zoomControlsEnabled: false,
                  ),
                  webPreferences: WebMapPreferences(
                    fullscreenControl: true,
                    zoomControl: true,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
