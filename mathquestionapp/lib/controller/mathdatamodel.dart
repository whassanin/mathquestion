import 'dart:collection';

import 'package:mathquestionapp/model/mathdata.dart';
import 'package:scoped_model/scoped_model.dart';

class StackExpression {
  Queue<String> _queueChar = Queue<String>();
  Queue<String> _queueValues = Queue<String>();

  int get lengthValues => _queueValues.length;
  int get lengthChar => _queueChar.length;

  void pushChar(String val) {
    if (!_queueChar.contains(val)) {
      _queueChar.addLast(val);
    }
  }

  void pushValues(String val) {
    if (!_queueValues.contains(val)) {
      _queueValues.addLast(val);
    }
  }

  String popChar() {
    if (_queueChar.length > 0) {
      return _queueChar.removeLast();
    }
    return null;
  }

  String popValues() {
    if (_queueValues.length > 0) {
      return _queueValues.removeLast();
    }
    return null;
  }

  bool isEmptyChar() {
    return _queueChar.length == 0 ? true : false;
  }

  bool isEmptyValues() {
    return _queueValues.length == 0 ? true : false;
  }

  String topValues() {
    return _queueValues.elementAt(_queueValues.length - 1);
  }

  String topChar() {
    return _queueChar.elementAt(_queueChar.length - 1);
  }
}

class MathDataModel extends Model {
  StackExpression _stackExpression = StackExpression();

  MathData _mathData = new MathData('', '', 0);

  MathData get mathData => _mathData;

  List<MathData> mathDataList = [];

  void createMathData() {
    _mathData = new MathData('', '', 0);
  }

  void editMathData(MathData editMathData) {
    _mathData = editMathData;
  }

  void setExpression(String val) {
    _mathData.expression = val;
  }

  String getExpression() {
    return _mathData.expression;
  }

  void setResult(String val) {
    _mathData.result = val;
    notifyListeners();
  }

  String getResult() {
    return _mathData.result;
  }

  void setResponseTime(int val) {
    _mathData.responseTime = val;
    notifyListeners();
  }

  int getResponseTime() {
    return _mathData.responseTime;
  }

  void getNumber(String num) {
    int isNumber = int.tryParse(num.toString());
    if (isNumber != null) {
      int val = 0;

      for (int i = 0; i < num.length - 1; i++) {}
    }
  }

  int precedence(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
  }

  double applyOp(double num1, double num2, String op) {
    double z = 0;
    double a = num1.toDouble();
    double b = num2.toDouble();
    if (op == '+') {
      z = a + b;
    } else if (op == '-') {
      z = a - b;
    } else if (op == '*') {
      z = a * b;
    } else if (op == '/') {
      z = a / b;
    }
    return z;
  }

  void evaluateExpression() {
    DateTime startTime = DateTime.now();

    String expression = _mathData.expression;
    for (int i = 0; i <= expression.length - 1; i++) {
      if (expression[i] == ' ') {
        continue;
      } else if (int.tryParse(expression[i].toString()) != null) {
        int val = 0;
        int j = i;
        int isNumber = int.tryParse(expression[i].toString());
        while (j < expression.length && isNumber != null) {
          isNumber = int.tryParse(expression[j].toString());
          if (isNumber != null) {
            val = (val * 10) + isNumber;
            j++;
          } else {
            break;
          }
        }
        _stackExpression.pushValues(val.toString());
        i = j;
        i--;
      } else if (expression[i] == '(') {
        _stackExpression.pushChar(expression[i]);
      } else if (expression[i] == ')') {
      } else {
        while (!_stackExpression.isEmptyChar()) {
          int pre1 = precedence(_stackExpression.topChar());
          int pre2 = precedence(expression[i]);
          if (pre1 >= pre2) {
            double val2, val1;
            if (!_stackExpression.isEmptyValues()) {
              val2 = double.parse(_stackExpression.topValues());
              _stackExpression.popValues();
            }

            if (!_stackExpression.isEmptyValues()) {
              val1 = double.parse(_stackExpression.topValues());
              _stackExpression.popValues();
            }
            if (val1 != null && val2 != null) {
              String op = _stackExpression.topChar();
              _stackExpression.popChar();
              double v = applyOp(val1, val2, op);
              _stackExpression.pushValues(v.toString());
            } else {
              break;
            }
          } else {
            break;
          }
        }
        _stackExpression.pushChar(expression[i]);
      }
    }

    bool isCalculated = true;

    while (!_stackExpression.isEmptyChar()) {
      double val2, val1;
      if (!_stackExpression.isEmptyValues()) {
        val2 = double.parse(_stackExpression.topValues());
        _stackExpression.popValues();
      }

      if (!_stackExpression.isEmptyValues()) {
        val1 = double.parse(_stackExpression.topValues());
        _stackExpression.popValues();
      }

      if (val1 != null && val2 != null) {
        String op = _stackExpression.topChar();
        _stackExpression.popChar();
        double v = applyOp(val1, val2, op);
        _stackExpression.pushValues(v.toString());
        isCalculated = true;
      } else {
        isCalculated = false;
        break;
      }
    }

    if (isCalculated) {
      _mathData.result = _stackExpression.popValues();
    } else {
      _mathData.result = 'Invalid Equation';
    }

    DateTime endTime = DateTime.now();

    Duration diff = endTime.difference(startTime);

    _mathData.responseTime = diff.inMicroseconds;

    notifyListeners();
  }

  void createData() {
    List<MathData> list = [];

    createMathData();
    setExpression('2 * 18 + 3 - 4 / 6');
    evaluateExpression();
    list.add(_mathData);

    createMathData();
    setExpression('3 * 18 + 3 - 4 / 7');
    evaluateExpression();
    list.add(_mathData);

    createMathData();
    setExpression('4 * 18 + 3 - 4 / 8');
    evaluateExpression();
    list.add(_mathData);

    createMathData();
    setExpression('6 * 18 + 3 - 4 / 9');
    evaluateExpression();
    list.add(_mathData);

    createMathData();
    setExpression('2 * 18 + 3 - 4 / 10');
    evaluateExpression();
    list.add(_mathData);

    createMathData();
    setExpression('8 * 18 + 3 - 4 / 11');
    evaluateExpression();
    list.add(_mathData);

    createMathData();
    setExpression('2 * 18 + 3 - 4 / 12');
    evaluateExpression();
    list.add(_mathData);

    createMathData();
    setExpression('10 * 18 + 3 - 4 / 51');
    evaluateExpression();
    list.add(_mathData);

    createMathData();
    setExpression('2 * 18 + 3 - 4 / 60');
    evaluateExpression();
    list.add(_mathData);

    mathDataList = list;
    notifyListeners();
  }
}
