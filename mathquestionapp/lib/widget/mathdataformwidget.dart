import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mathquestionapp/main.dart';

import '../main.dart';

enum MathDataColumns { expression, result, response }

class MathDataFormWidget extends StatefulWidget {
  final bool isEdit;
  MathDataFormWidget(this.isEdit);
  @override
  _MathDataFormWidgetState createState() => _MathDataFormWidgetState();
}

class _MathDataFormWidgetState extends State<MathDataFormWidget> {
  final _formKey = new GlobalKey<FormState>();

  TextEditingController expressionTEC = new TextEditingController();
  TextEditingController resultTEC = new TextEditingController();
  TextEditingController responseTEC = new TextEditingController();

  void setData(MathDataColumns mathDataColumns, Object val) {
    if (mathDataColumns == MathDataColumns.expression) {
      mathDataModel.setExpression(val);
    } else if (mathDataColumns == MathDataColumns.response) {
      if (val.toString().isNotEmpty) {
        mathDataModel.setResponseTime(int.parse(val));
      }
    }
  }

  void getData() {
    expressionTEC.text = mathDataModel.getExpression();
    resultTEC.text = mathDataModel.getResult().toString();
    responseTEC.text = mathDataModel.getResponseTime().toString();
  }

  void saveData() {
    if (_formKey.currentState.validate()) {
      if (widget.isEdit) {
        mathDataModel.update();
      } else {
        mathDataModel.createMathData();
        mathDataModel.setExpression(expressionTEC.text);
        mathDataModel.setResponseTime(int.parse(responseTEC.text));
        mathDataModel.create();
      }
      //mathDataModel.start();
      Navigator.pop(context);
    }
  }

  void deleteData() {
    mathDataModel.delete();
    Navigator.pop(context);
  }

  Widget textFormField(
    TextEditingController columnTEC,
    String name,
    MathDataColumns mathDataColumns,
    bool isNumber,
    bool isReadOnly,
  ) {
    Widget mathDataTFF = TextFormField(
      controller: columnTEC,
      readOnly: isReadOnly,
      keyboardType: (isNumber ? TextInputType.number : TextInputType.text),
      inputFormatters: (isNumber
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ]
          : null),
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 24),
        labelText: name,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
        ),
      ),
      validator: (v) {

        if (columnTEC.text.isEmpty) {
          return 'Required';
        }else if(mathDataColumns == MathDataColumns.expression){
          setData(mathDataColumns, v);
          if (mathDataModel.validate()==false) {
            return mathDataModel.getError();
          }
        }else if(mathDataColumns == MathDataColumns.response){
          if (columnTEC.text.isEmpty) {
            return 'Required';
          }
        }else {
          setData(mathDataColumns, v);
        }

        return null;
      },
      onChanged: (v) {
        if (mathDataColumns == MathDataColumns.expression ||
            mathDataColumns == MathDataColumns.response) {
          print(v);
          setData(mathDataColumns, v);
        }
      },
      onFieldSubmitted: (v) {
        if (mathDataColumns == MathDataColumns.expression ||
            mathDataColumns == MathDataColumns.response) {
          setData(mathDataColumns, v);
        }
      },
    );

    Widget mathDataRowTFF = Row(
      children: [
        Expanded(
          child: mathDataTFF,
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
        bottom: 5.0,
      ),
      child: mathDataRowTFF,
    );
  }

  Widget button(String name, Color color, {VoidCallback fun}) {
    Widget button = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: color,
      onPressed: () {
        if (fun != null) {
          fun();
        }
      },
    );

    Widget mathDataRowButton = Expanded(
      child: Container(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: button,
        ),
      ),
    );

    return mathDataRowButton;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit) {
      getData();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    expressionTEC.clear();
    responseTEC.clear();
  }

  @override
  Widget build(BuildContext context) {
    Widget resultTFF = Container();

    if (widget.isEdit) {
      if (mathDataModel.getResult().toString().isNotEmpty) {
        resultTFF = textFormField(
          resultTEC,
          'Result',
          MathDataColumns.result,
          true,
          true,
        );
      }
    }

    Widget editButtons = Row(
      children: [
        button('Add Task', Colors.blue, fun: saveData),
      ],
    );

    if (widget.isEdit) {
      editButtons = Row(
        children: [
          button(
            'Save Task',
            Colors.blue,
            fun: saveData,
          ),
          button('Delete Task', Colors.red, fun: deleteData),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          textFormField(
            expressionTEC,
            'Expression',
            MathDataColumns.expression,
            false,
            false,
          ),
          resultTFF,
          textFormField(
            responseTEC,
            'Response',
            MathDataColumns.response,
            true,
            false,
          ),
          editButtons,
        ],
      ),
    );
  }
}
