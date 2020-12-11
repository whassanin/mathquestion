import 'package:flutter/material.dart';
import 'package:mathquestionapp/controller/mathdatamodel.dart';
import 'package:mathquestionapp/main.dart';
import 'package:mathquestionapp/widget/mathdatarowwidget.dart';

class MathDataListWidget extends StatefulWidget {
  @override
  _MathDataListWidgetState createState() => _MathDataListWidgetState();
}

class _MathDataListWidgetState extends State<MathDataListWidget> {
  Widget getList() {

    Widget current = Container();

    if(mathDataModel.isLoading){
      current = Center(child: Container(child: CircularProgressIndicator(),),);
    }
    else {
      current = ListView.builder(
        shrinkWrap: true,
        itemCount: MathDataModel.currentList.length,
        itemBuilder: (BuildContext context, int index) {
          return MathDataRowWidget(MathDataModel.currentList[index]);
        },
      );
    }

    return current;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: getList(),
    );
  }
}
