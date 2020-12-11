import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'mathdata.g.dart';

@JsonSerializable()
class MathData{
  int id;
  String expression;
  String result;
  int responseTime;
  bool isCalculated;
  DateTime createdDate;
  DateTime executionDate;

  MathData(this.id,this.expression,this.result,this.responseTime,this.isCalculated,this.createdDate,this.executionDate);

  factory MathData.fromJson(Map<String, dynamic> json) => _$MathDataFromJson(json);

  Map<String, dynamic> toJson() => _$MathDataToJson(this);
}