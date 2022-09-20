import 'package:json_annotation/json_annotation.dart';

part 'component.g.dart';

@JsonSerializable()
class Component {
  Component(this.name, this.type, this.component, this.timestamp, this.required,
      this.values, this.isCommonValue, this.setCommonValue);

  String name;
  List<String>? values;
  String component;
  String type;
  bool required;
  bool isCommonValue;
  bool setCommonValue;
  bool timestamp;

  factory Component.fromJson(Map<String, dynamic> json) =>
      _$ComponentFromJson(json);
  Map<String, dynamic> toJson() => _$ComponentToJson(this);
}
