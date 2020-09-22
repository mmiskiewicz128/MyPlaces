import 'package:flutter/material.dart';
import 'package:places_app/providers/my_places.dart';
import 'package:places_app/screens/place_add_screen.dart';
import 'package:places_app/screens/places_details_screen.dart';
import 'package:places_app/screens/places_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) {
          return MyPlaces();
        })
      ],
      child: MaterialApp(
        routes: {
          AddPlaceScreen.routeName: (ctx) {
            return AddPlaceScreen();
          },
          PlaceDetailsScreen.routeName: (ctx) {
            return PlaceDetailsScreen();
          }
          
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          inputDecorationTheme:
              InputDecorationTheme(contentPadding: const EdgeInsets.all(4)),
          primarySwatch: Colors.teal,
          accentColor: Colors.redAccent,
        ),
        home: PlacesListScreen(),
      ),
    );
  }
}
