// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compressed_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompressedDataModel _$CompressedDataModelFromJson(Map<String, dynamic> json) =>
    CompressedDataModel(
      (json['data'] as List<dynamic>).map((e) => e as String).toList(),
      (json['lengths'] as List<dynamic>).map((e) => e as int).toList(),
      MetadataModel.fromJson(json['metaData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompressedDataModelToJson(
        CompressedDataModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'lengths': instance.lengths,
      'metaData': instance.metadata,
    };

MetadataModel _$MetadataModelFromJson(Map<String, dynamic> json) =>
    MetadataModel(
      json['name'] as String,
      json['version'] as String,
    );

Map<String, dynamic> _$MetadataModelToJson(MetadataModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
    };