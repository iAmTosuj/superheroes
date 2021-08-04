import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/server_image.dart';

part 'powerstats.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  Powerstats(this.intelligence, this.strength, this.speed, this.durability,
      this.power, this.combat);

  factory Powerstats.fromJson(final Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);
  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);
}
