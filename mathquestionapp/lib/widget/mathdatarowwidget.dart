import 'package:flutter/material.dart';
import 'package:mathquestionapp/main.dart';
import 'package:mathquestionapp/model/mathdata.dart';
import 'package:mathquestionapp/view/editmathdatascreen.dart';

class MathDataRowWidget extends StatefulWidget {
  final MathData mathData;
  MathDataRowWidget(this.mathData);
  @override
  _MathDataRowWidgetState createState() => _MathDataRowWidgetState();
}

class _MathDataRowWidgetState extends State<MathDataRowWidget> {
  Widget getContent() {
    Widget progressWidget = Text(
      'In Progress',
      style: TextStyle(backgroundColor: Colors.red, color: Colors.white),
    );

    Widget resultWidget = Text(widget.mathData.result.toString());

    Widget resultText =
        (widget.mathData.isCalculated ? resultWidget : progressWidget);

    Widget equationValueColumn = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.mathData.id.toString()),
          SizedBox(
            height: 10,
          ),
          Text(widget.mathData.expression),
          SizedBox(
            height: 10,
          ),
          resultText,
          SizedBox(
            height: 10,
          ),
          Text(widget.mathData.responseTime.toString() + ' seconds'),
        ],
      ),
    );

    Widget equationColumn = Container(
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task Id: '),
          SizedBox(
            height: 10,
          ),
          Text('Expression: '),
          SizedBox(
            height: 10,
          ),
          Text('Result: '),
          SizedBox(
            height: 10,
          ),
          Text('Response in: '),
        ],
      ),
    );

    Widget mathDataRowContainer = Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          equationColumn,
          Expanded(child: equationValueColumn),
        ],
      ),
    );

    Widget mathDataCard = Card(
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

    return GestureDetector(
      child: mathDataCard,
      onTap: () {
        mathDataModel.editMathData(widget.mathData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditMathDataScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return getContent();
  }
}
