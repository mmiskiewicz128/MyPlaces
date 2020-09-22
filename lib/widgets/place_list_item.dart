import 'package:flutter/material.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/providers/my_places.dart';
import 'package:provider/provider.dart';

class PlaceListItem extends StatelessWidget {
  final Place place;
  final int index;

  PlaceListItem(this.place, this.index);

  Alignment _getImageAlignmentByIndex(int index) {
    if (index % 3 == 0) {
      return Alignment.bottomCenter;
    }
    if (index % 2 == 0) {
      return Alignment.center;
    }

    return Alignment.topCenter;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(place.id),
      direction: DismissDirection.endToStart,
      background: Card(
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 10),
        child: Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, size: 30, color: Colors.white)),
        color: Theme.of(context).accentColor,
      ),
      onDismissed: (direction) {
        Provider.of<MyPlaces>(context, listen: false)
            .deletePlace(this.place.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want remove the place?'),
                  actions: [
                    FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                    FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        })
                  ]);
            });
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 10),
        elevation: 9,
        child: Container(
          height: 80,
          width: double.infinity,
          child: Stack(
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              if (place.image != null)
                Container(
                    width: double.infinity,
                    child: Image.file(place.image, fit: BoxFit.cover)),
              if (place.image == null)
                Opacity(
                  opacity: 0.5,
                  child: Container(
                      width: double.infinity,
                      child: Image.asset('assets/images/mapBackground.png',
                          fit: BoxFit.cover,
                          alignment: _getImageAlignmentByIndex(index))),
                ),
              Positioned(
                right: 15,
                bottom: -10,
                child: Container(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
                      child: Row(
                        children: [
                          Icon(
                            place.placeType?.icon ?? Icons.markunread,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            (place.tilte ?? ''),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .accentTextTheme
                                  .subtitle1
                                  .color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
