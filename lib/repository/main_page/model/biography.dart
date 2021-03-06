import 'package:json_annotation/json_annotation.dart';

part 'biography.g.dart';

@JsonSerializable()
class Biography {
  final String fullName;
  final String alignment;

  Biography(this.fullName, this.alignment);

  factory Biography.fromJson(final Map<String, dynamic> json) =>
      _$BiographyFromJson(json);

  Map<String, dynamic> toJson() => _$BiographyToJson(this);
}
