// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Screen _$ScreenFromJson(Map<String, dynamic> json) => Screen(
      (json['sections'] as List<dynamic>)
          .map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['footer'] as String,
    );

Map<String, dynamic> _$ScreenToJson(Screen instance) => <String, dynamic>{
      'footer': instance.footer,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
    };
