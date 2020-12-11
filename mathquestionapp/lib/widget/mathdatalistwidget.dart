import 'package:flutter/material.dart';
import 'package:mathquestionapp/main.dart';
import 'package:mathquestionapp/widget/mathdatarowwidget.dart';

class MathDataListWidget extends StatefulWidget {
  @override
  _MathDataListWidgetState createState() => _MathDataListWidgetState();
}

class _MathDataListWidgetState extends State<MathDataListWidget> {
  Widget getList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: mathDataModel.mathDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return MathDataRowWidget(mathDataModel.mathDataList[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return getList();
  }
}
