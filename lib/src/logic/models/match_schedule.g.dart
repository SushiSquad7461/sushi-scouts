// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchSchedule _$MatchScheduleFromJson(Map<String, dynamic> json) =>
    MatchSchedule(
      (json['Schedule'] as List<dynamic>)
          .map((e) => Match.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MatchScheduleToJson(MatchSchedule instance) =>
    <String, dynamic>{
      'Schedule': instance.schedule.map((e) => e.toJson()).toList(),
    };

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      (json['teams'] as List<dynamic>)
          .map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'teams': instance.teams.map((e) => e.toJson()).toList(),
    };

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      json['teamNumber'] as int,
      json['station'] as String,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'teamNumber': instance.number,
      'station': instance.station,
    };
