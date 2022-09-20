// GENERATED CODE - DO NOT MODIFY BY HAND

part of "supervise_data.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuperviseData _$SuperviseDataFromJson(Map<String, dynamic> json) =>
    SuperviseData(
      ScoutingData.fromJson(json["data"] as Map<String, dynamic>),
      json["flagged"] as bool,
      json["deleted"] as bool,
      json["methodName"] as String,
      json["display1"] as String,
      json["display2"] as String,
      json["name"] as String,
      json["teamNum"] as int,
    );

Map<String, dynamic> _$SuperviseDataToJson(SuperviseData instance) =>
    <String, dynamic>{
      "data": instance.data,
      "flagged": instance.flagged,
      "deleted": instance.deleted,
      "methodName": instance.methodName,
      "display1": instance.display1,
      "display2": instance.display2,
      "name": instance.name,
      "teamNum": instance.teamNum,
    };
