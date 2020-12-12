import 'package:flutter/material.dart';
import 'package:mathquestionapp/main.dart';

class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    String location = mathDataModel.getLatitude().toString() +
        ' , ' +
        mathDataModel.getLongitude().toString();

    Widget locationText = Expanded(
      child: Text('Location: ' + location),
    );

    Widget locationRow = Row(
      children: [
        locationText,
      ],
    );

    Widget locationContainer = Container(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: locationRow,
      ),
    );

    Widget locationCard = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      child: locationContainer,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: locationCard,
    );
  }
}
