import 'package:json_annotation/json_annotation.dart';

part 'compressed_data_model.g.dart';

@JsonSerializable()
class CompressedDataModel {
  CompressedDataModel(this.data, this.lengths, this.metadata);

  MetadataModel metadata;

  List<int> lengths;

  List<String> data;

  factory CompressedDataModel.fromJson(Map<String, dynamic> json) => _$CompressedDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompressedDataModelToJson(this);

  void add(CompressedDataModel other) {
    data.addAll(other.data);
    lengths.addAll(other.lengths);
  }

  void addString(String other) {
    data.add(other);
    lengths.add(other.length);
  }
}

@JsonSerializable(explicitToJson: true)
class MetadataModel {
  MetadataModel(this.name, this.version, this.isBackup);
  String name;
  double version;
  bool isBackup;
  factory MetadataModel.fromJson(Map<String, dynamic> json) => _$MetadataModelFromJson(json);
  Map<String, dynamic> toJson() => _$MetadataModelToJson(this);
}