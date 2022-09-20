// Package imports:
import "package:json_annotation/json_annotation.dart";

// Project imports:
import "scouting_data_models/scouting_data.dart";

part "supervise_data.g.dart";

@JsonSerializable()
class SuperviseData {
  ScoutingData data;
  bool flagged;
  bool deleted;
  String methodName;
  String display1;
  String display2;
  String name;
  int teamNum;

  SuperviseData(this.data, this.flagged, this.deleted, this.methodName,
      this.display1, this.display2, this.name, this.teamNum);

  factory SuperviseData.fromJson(Map<String, dynamic> json) =>
      _$SuperviseDataFromJson(json);

  Map<String, dynamic> toJson() => _$SuperviseDataToJson(this);
}
