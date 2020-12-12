import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';

import 'package:geolocator/geolocator.dart';
import 'package:mathquestionapp/api/api.dart';
import 'package:mathquestionapp/main.dart';
import 'package:mathquestionapp/model/mathdata.dart';
import 'package:scoped_model/scoped_model.dart';

class StackExpression {
  Queue<String> _queueChar = Queue<String>();
  Queue<String> _queueValues = Queue<String>();

  int get lengthValues => _queueValues.length;
  int get lengthChar => _queueChar.length;

  void clearValues() {
    _queueValues.clear();
  }

  void clearChar() {
    _queueChar.clear();
  }

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
  Api _api = new Api('mathdata');

  StackExpression _stackExpression = StackExpression();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Isolate _isolate;
  ReceivePort _receivePort;
  bool _running = false;

  MathData _mathData = new MathData(
    0,
    '0',
    0,
    0,
    false,
    0,
    0,
    DateTime.now(),
    DateTime.now(),
  );

  MathData get mathData => _mathData;

  List<MathData> mathDataList = [];

  void createMathData() {
    _mathData = new MathData(
      0,
      '',
      0,
      0,
      false,
      0,
      0,
      DateTime.now(),
      DateTime.now(),
    );
    _determinePosition();
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

  void setError(String val) {
    _mathData.error = val;
  }

  String getError() {
    return _mathData.error;
  }

  void setResult(double val) {
    _mathData.result = val;
    notifyListeners();
  }

  double getResult() {
    return _mathData.result;
  }

  void setLatitude(double val) {
    _mathData.latitude = val;
    notifyListeners();
  }

  double getLatitude() {
    return _mathData.latitude;
  }

  void setLongitude(double val) {
    _mathData.longitude = val;
    notifyListeners();
  }

  double getLongitude() {
    return _mathData.longitude;
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

  void setChangedDate(DateTime dateTime){
    _mathData.changedDate = dateTime;
  }

  DateTime getChangedDate(){
    return _mathData.changedDate;
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

  bool validate() {
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
        while(!_stackExpression.isEmptyChar() && _stackExpression.topChar()!='('){
          double val2,val1;
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
        }

        if(!_stackExpression.isEmptyChar()){
          _stackExpression.popChar();
        }

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
      _mathData.error = _stackExpression.popValues();
      print('error:'+_mathData.error);
    } else {
      _mathData.error = 'Invalid Equation';
    }

    setIsCalculated(isCalculated);
    _stackExpression.clearChar();
    _stackExpression.clearValues();

    return isCalculated;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    Position position = await Geolocator.getCurrentPosition();

    _mathData.latitude = position.latitude;
    _mathData.longitude =position.longitude;

    print(_mathData.toJson().toString());

    return position;
  }

  Future<List<MathData>> readAll() async {
    _isLoading = true;
    notifyListeners();

    List<dynamic> listMap = await _api.get();

    mathDataList = listMap.map((e) => MathData.fromJson(e)).toList();

    _isLoading = false;
    notifyListeners();

    return mathDataList;
  }

  Future<bool> create() async {
    String body = await _api.post(_mathData.toJson());
    Map<String, dynamic> list = jsonDecode(body);
    _mathData = MathData.fromJson(list);
    if (_mathData.id != null) {
      if (_mathData.id > 0) {
        mathDataList.add(_mathData);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> update() async {
    String body = await _api.put(_mathData.toJson(), _mathData.id.toString());
    Map<String, dynamic> list = jsonDecode(body);
    _mathData = MathData.fromJson(list);
    if(_mathData.id!=null){
      if(_mathData.id > 0){
        int index = mathDataList.indexWhere(
              (element) => element.id == _mathData.id,
        );
        print('update:'+_mathData.toJson().toString());
        mathDataList[index] = _mathData;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> delete() async {
    int code = await _api.delete(_mathData.id.toString());
    await Future.delayed(Duration(seconds: 4));
    if (code == 204) {
      notifyListeners();
      return true;
    }
    return false;
  }

  void process() {
    mathDataList.forEach((element) {
      DateTime currentTime = DateTime.now();
      DateTime runtAtTime = element.changedDate.add(
        Duration(
          hours: -2,
          seconds: element.responseTime,
        ),
      );

      int v = runtAtTime.difference(currentTime).inSeconds;
      if (v < 0 && element.isCalculated == false) {
        editMathData(element);
        setIsCalculated(true);
        update();
      }
    });
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
    Timer.periodic(Duration(seconds: 10), (timer) {
      sendPort.send('Sending');
    });
  }

  void _handleMessage(dynamic data) {
    print('Received');
    process();
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
    setResponseTime(120);
    create();

    createMathData();
    setExpression('3 * 18 + 3 - 4 / 7');
    setResponseTime(120);
    create();

    await Future.delayed(Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
  }
}
