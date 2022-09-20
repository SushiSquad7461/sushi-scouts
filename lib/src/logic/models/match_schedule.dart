import "package:json_annotation/json_annotation.dart";

part "match_schedule.g.dart";

@JsonSerializable(explicitToJson: true)
class MatchSchedule {
  MatchSchedule(this.schedule);

  @JsonKey(name: "Schedule")
  List<Match> schedule;

  factory MatchSchedule.fromJson(Map<String, dynamic> json) =>
      _$MatchScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$MatchScheduleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Match {
  Match(this.teams);
  List<Team> teams;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);
}

@JsonSerializable(explicitToJson: false)
class Team {
  Team(this.number, this.station);

  @JsonKey(name: "teamNumber")
  int number;
  String station;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
