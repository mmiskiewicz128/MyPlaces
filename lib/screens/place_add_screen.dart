import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/models/place_type.dart';
import 'package:places_app/providers/my_places.dart';
import 'package:places_app/widgets/image_input.dart';
import 'package:places_app/widgets/location_input.dart';
import 'package:places_app/widgets/place_type_radio.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  AddPlaceScreenState createState() => AddPlaceScreenState();
}

class AddPlaceScreenState extends State<AddPlaceScreen> {
  final _form = GlobalKey<FormState>();
  File _pickedImage;
  PlaceType _type;
  String _titleField;
  PlaceLocation _selectedLocation;

  bool _isLocationNotValid = false;

  void _selectImage(File picketdImage) {
    _pickedImage = picketdImage;
  }

  void _selectType(PlaceType placeType) {
    _type = placeType;
  }

  void _selectPlace(PlaceLocation location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _savePlace() {
    setState(() {
      _isLocationNotValid = _selectedLocation == null;
    });

    if (_form.currentState.validate() &&
        !_isLocationNotValid) {
      Provider.of<MyPlaces>(context, listen: false).addPlace(
          title: _titleField,
          type: _type,
          pickedImage: _pickedImage,
          location: _selectedLocation);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Add a New Place')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                        onChanged: (value) {
                          _titleField = value;
                        },
                        validator: (value) {
                          return value.isEmpty
                              ? 'Add title for new place'
                              : null;
                        },
                        decoration: InputDecoration(labelText: 'Tile'),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _form.currentState.validate();
                        }),
                    SizedBox(height: 5),
                    ImageInput(_selectImage),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Stack(
                overflow: Overflow.visible,
                children: [
                  if (_isLocationNotValid)
                    Positioned(
                        top: -5,
                        left: 5,
                        child: Text('Add location',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).errorColor))),
                  LoactionInput(_selectPlace),
                ],
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: PlaceTypeRadio(_selectType)),
            ]),
          ),
          Container(
              height: 50,
              child: _selectedLocation != null
                  ? RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_location,
                              color: Colors.white, size: 30),
                          SizedBox(width: 5),
                          SizedBox(
                            width: deviceWidth * 0.8,
                            child: FittedBox(
                              child: Text(
                                  "Add Place (${_selectedLocation.address})",
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                      color: Theme.of(context).accentColor,
                      onPressed: _savePlace)
                  : RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_location,
                              color: Colors.white, size: 30),
                          SizedBox(width: 5),
                          Text("Add Place",
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ],
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                      color: Theme.of(context).accentColor,
                      onPressed: _savePlace)),
        ],
      ),
    );
  }
}
