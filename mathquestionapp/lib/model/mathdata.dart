import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'mathdata.g.dart';

@JsonSerializable()
class MathData{
  int id;
  String expression;
  double result;
  int responseTime;
  bool isCalculated;
  double latitude;
  double longitude;
  DateTime createdDate;
  DateTime changedDate;

  @JsonKey(ignore: true)
  String error;

  MathData(this.id,this.expression,this.result,this.responseTime,this.isCalculated,this.latitude,this.longitude,this.createdDate,this.changedDate);

  factory MathData.fromJson(Map<String, dynamic> json) => _$MathDataFromJson(json);

  Map<String, dynamic> toJson() => _$MathDataToJson(this);
}