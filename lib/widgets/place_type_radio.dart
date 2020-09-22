import 'package:flutter/material.dart';
import 'package:places_app/models/place_type.dart';

class PlaceTypeRadio extends StatefulWidget {
  final _state = _PlaceTypeRadioState();
  final Function onSelected;

  PlaceTypeRadio(this.onSelected);

  @override
  _PlaceTypeRadioState createState() => _state;
}

class _PlaceTypeRadioState extends State<PlaceTypeRadio> {
  List<PlaceType> _types = PlaceType.getPlaceTypes();
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _types.length,
          itemBuilder: (ctx, index) {
            return radioIcon(_types[index], _types.length);
          }),
    );
  }

  Widget radioIcon(PlaceType type, int itemsCount) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: GestureDetector(
        child: Container(
          width: deviceWidth / itemsCount - deviceWidth * 0.01,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: type.id == _selectedIndex
                  ? Colors.amber[700]
                  : Theme.of(context).primaryColor),
          child: Icon(type.icon, color: Colors.white),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = type.id;
            widget.onSelected(type);
          });
        },
      ),
    );
  }
}
