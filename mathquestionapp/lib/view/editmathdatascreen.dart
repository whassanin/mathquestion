import 'package:flutter/material.dart';
import 'package:mathquestionapp/controller/mathdatamodel.dart';
import 'package:mathquestionapp/main.dart';
import 'package:mathquestionapp/widget/mathdataformwidget.dart';
import 'package:scoped_model/scoped_model.dart';

class EditMathDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MathDataModel>(
      model: mathDataModel,
      child: ScopedModelDescendant(
        builder: (
            BuildContext context,
            Widget child,
            MathDataModel mathDataModel,
            ) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Math Question'),
            ),
            body: MathDataFormWidget(true),
          );
        },
      ),
    );
  }
}
