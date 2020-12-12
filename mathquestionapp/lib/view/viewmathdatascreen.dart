import 'package:flutter/material.dart';
import 'package:mathquestionapp/controller/mathdatamodel.dart';
import 'package:mathquestionapp/main.dart';
import 'package:mathquestionapp/view/newmathdatascreen.dart';
import 'package:mathquestionapp/widget/mathdatalistwidget.dart';
import 'package:scoped_model/scoped_model.dart';

import '../main.dart';

class ViewMathDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    mathDataModel.readAll();

    return ScopedModel<MathDataModel>(
      model: mathDataModel,
      child: ScopedModelDescendant(
        builder: (
          BuildContext context,
          Widget child,
          MathDataModel mathDataModel,
        ) {
          AppBar appBar = new AppBar(
            title: Text('Math Question'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  mathDataModel.createMathData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewMathDataScreen(),
                    ),
                  );
                },
              )
            ],
          );

          return Scaffold(
            appBar: appBar,
            body: MathDataListWidget(),
          );
        },
      ),
    );
  }
}
