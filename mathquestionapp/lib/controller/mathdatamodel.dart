import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:mathquestionapp/main.dart';
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
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  StackExpression _stackExpression = StackExpression();

  MathData _mathData = new MathData(
    0,
    '',
    '',
    0,
    false,
    DateTime.now(),
    DateTime.now(),
  );

  MathData get mathData => _mathData;

  List<MathData> mathDataList = [];

  static List<MathData> currentList = [];

  int _currentId = 0;

  Isolate _isolate;
  ReceivePort _receivePort;
  bool _running = false;

  MathDataModel() {
    generateData();
    currentList = mathDataList;
    _currentId = mathDataList.length;
  }

  void createMathData() {
    _mathData = new MathData(
      0,
      '',
      '',
      0,
      false,
      DateTime.now(),
      DateTime.now(),
    );
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
  }

  int getResponseTime() {
    return _mathData.responseTime;
  }

  void setIsCalculated(bool val) {
    _mathData.isCalculated = val;
    notifyListeners();
  }

  bool getIsCalculated() {
    return _mathData.isCalculated;
  }

  void sortList() {
    mathDataList.sort((a, b) => a.responseTime.compareTo(b.responseTime));
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
      setIsCalculated(isCalculated);
      update();
    } else {
      _mathData.result = 'Invalid Equation';
    }
    notifyListeners();
  }

  bool isExist() {
    int index = mathDataList.indexWhere(
      (element) => element.expression.trim() == _mathData.expression.trim(),
    );

    print(_mathData.expression.trim());

    print('index exists:' + index.toString());
    if (index < 0) {
      return false;
    }

    return true;
  }

  void create() {
    int index = mathDataList.indexWhere(
      (element) => element.expression.trim() == _mathData.expression.trim(),
    );

    if (index < 0) {
      _currentId = _currentId + 1;
      _mathData.id = _currentId;
      _mathData.executionDate = _mathData.createdDate.add(
        Duration(
          seconds: _mathData.responseTime,
        ),
      );

      mathDataList.add(_mathData);
      sortList();
      notifyListeners();
    }
  }

  void update() {
    int index = mathDataList.indexWhere(
      (element) => element.id == _mathData.id,
    );
    mathDataList[index] = _mathData;
    sortList();
    notifyListeners();
  }

  void delete() {
    int index = mathDataList.indexWhere(
      (element) => element.id == _mathData.id,
    );
    mathDataList.removeAt(index);
    sortList();
    notifyListeners();
  }

  void start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTask, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone: () {
      print('Evaluated');
    });
  }

  static void _checkTask(SendPort sendPort) async {
    currentList = mathDataModel.mathDataList;
    print('handle' + currentList.length.toString());
    currentList.forEach((element) {
      if (element.isCalculated == false) {
        sendPort.send(element.toJson());
      }
    });
  }

  void _handleMessage(dynamic data) {
    print('Received');
    MathData mathData = MathData.fromJson(data);
    editMathData(mathData);
    evaluateExpression();
  }

  void stop() {
    if (_isolate != null) {
      _running = false;
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  void generateData() async {
    _isLoading = true;
    notifyListeners();

    List<MathData> list = [];

    createMathData();
    setExpression('2 * 18 + 3 - 4 / 6');
    setResponseTime(5);
    create();

    createMathData();
    setExpression('3 * 18 + 3 - 4 / 7');
    setResponseTime(10);
    create();

    createMathData();
    setExpression('4 * 18 + 3 - 4 / 8');
    setResponseTime(15);
    create();

    createMathData();
    setExpression('6 * 18 + 3 - 4 / 9');
    setResponseTime(20);
    create();

    createMathData();
    setExpression('2 * 18 + 3 - 4 / 10');
    setResponseTime(25);
    create();

    createMathData();
    setExpression('8 * 18 + 3 - 4 / 11');
    setResponseTime(30);
    create();

    createMathData();
    setExpression('2 * 18 + 3 - 4 / 12');
    setResponseTime(35);
    create();

    createMathData();
    setExpression('10 * 18 + 3 - 4 / 51');
    setResponseTime(40);
    create();

    createMathData();
    setExpression('2 * 18 + 3 - 4 / 60');
    setResponseTime(45);
    create();

    sortList();

    await Future.delayed(Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
  }
}
