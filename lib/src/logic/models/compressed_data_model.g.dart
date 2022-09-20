// GENERATED CODE - DO NOT MODIFY BY HAND

part of "compressed_data_model.dart";

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompressedDataModel _$CompressedDataModelFromJson(Map<String, dynamic> json) =>
    CompressedDataModel(
      (json["data"] as List<dynamic>).map((e) => e as String).toList(),
      (json["lengths"] as List<dynamic>).map((e) => e as int).toList(),
      MetadataModel.fromJson(json["metadata"] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompressedDataModelToJson(
        CompressedDataModel instance) =>
    <String, dynamic>{
      "metadata": instance.metadata.toJson(),
      "lengths": instance.lengths,
      "data": instance.data,
    };

MetadataModel _$MetadataModelFromJson(Map<String, dynamic> json) =>
    MetadataModel(
      json["name"] as String,
      json["configId"] as String,
      json["isBackup"] as bool,
      json["teamNum"] as int,
      json["eventCode"] as String,
    );

Map<String, dynamic> _$MetadataModelToJson(MetadataModel instance) =>
    <String, dynamic>{
      "name": instance.name,
      "configId": instance.configId,
      "isBackup": instance.isBackup,
      "teamNum": instance.teamNum,
      "eventCode": instance.eventCode,
    };
