import 'package:flutter/material.dart';
import 'package:mathquestionapp/model/mathdata.dart';
class MathDataRowWidget extends StatefulWidget {
  final MathData mathData;
  MathDataRowWidget(this.mathData);
  @override
  _MathDataRowWidgetState createState() => _MathDataRowWidgetState();
}

class _MathDataRowWidgetState extends State<MathDataRowWidget> {
  Widget getContent(){

    Widget valueColumn = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.mathData.expression),
          SizedBox(
            height: 10,
          ),
          Text(widget.mathData.result),
          SizedBox(
            height: 10,
          ),
          Text(widget.mathData.responseTime.toString() + ' in microseconds'),
        ],
      ),
    );

    Widget titleColumn = Container(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Expression: '),
          SizedBox(
            height: 10,
          ),
          Text('Result: '),
          SizedBox(
            height: 10,
          ),
          Text('Response: '),
        ],
      ),
    );

    Widget mathDataRowContainer = Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleColumn,
          Expanded(child: valueColumn),
        ],
      ),
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: mathDataRowContainer,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return getContent();
  }
}
