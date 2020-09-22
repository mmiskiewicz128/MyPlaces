import 'package:flutter/material.dart';
import 'package:places_app/providers/my_places.dart';
import 'package:places_app/screens/place_add_screen.dart';
import 'package:places_app/screens/places_details_screen.dart';
import 'package:places_app/widgets/place_list_item.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.add),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              }),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<MyPlaces>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<MyPlaces>(
                builder: (ctx, places, builderChild) {
                  return places.list.length > 0
                      ? ListView.builder(
                          itemCount: places.list.length,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(PlaceDetailsScreen.routeName, arguments: places.list[index]);
                                },
                                child:
                                    PlaceListItem(places.list[index], index));
                          })
                      : builderChild;
                },
                child: Center(
                  child: Text('No added places yet...'),
                ),
              ),
      ),
    );
  }
}
