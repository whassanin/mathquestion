// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mathdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MathData _$MathDataFromJson(Map<String, dynamic> json) {
  return MathData(
    json['id'] as int,
    json['expression'] as String,
    (json['result'] as num)?.toDouble(),
    json['responseTime'] as int,
    json['isCalculated'] as bool,
    json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    json['changedDate'] == null
        ? null
        : DateTime.parse(json['changedDate'] as String),
  );
}

Map<String, dynamic> _$MathDataToJson(MathData instance) => <String, dynamic>{
      'id': instance.id,
      'expression': instance.expression,
      'result': instance.result,
      'responseTime': instance.responseTime,
      'isCalculated': instance.isCalculated,
      'createdDate': instance.createdDate?.toIso8601String(),
      'changedDate': instance.changedDate?.toIso8601String(),
    };
